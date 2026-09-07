# Known issues

## Revit crasht bij het benaderen van het model via onze routes (28-08-2026)

### Symptoom
Revit gaat met tussenpozen plat (harde crash, geen traceback) zodra een route
van deze server het **model of geometrie** aanraakt. Het is niet reproduceerbaar
bij elke call: dezelfde route kan een paar keer goed werken en de volgende keer
Revit laten crashen.

### Wat wel en niet stabiel is
| Actie | Raakt het model? | Gedrag |
|---|---|---|
| `GET /status/` | nee | stabiel |
| `compile()` op een scriptbestand (geen route) | nee | stabiel |
| `POST /execute_code/` (arbitraire IronPython) | ja | crashte Revit → **route verwijderd** |
| `GET /selection_info/` (read-only: selectie, `get_BoundingBox`, locaties) | ja | werkte 2x, crashte de 3e keer |

### Vermoedelijke oorzaak
De pyRevit-routes-handlers draaien **niet op de Revit API-thread**. De Revit API
is single-threaded en apartment-gebonden: `Document`/`FilteredElementCollector`/
`Element.get_BoundingBox`/`Selection` aanroepen vanaf de HTTP-server-thread is
niet thread-safe en laat Revit onvoorspelbaar crashen. Routes die het model niet
aanraken (`/status/`) blijven daarom overeind.

Dit is dus geen bug in één specifieke route (bv. `execute_code`), maar een
structureel probleem van model-toegang vanaf de routes-server zoals die nu
draait.

### Bewijs / verloop
- `/execute_code/` liet Revit meerdere keren crashen (28-08-2026) en is uit
  `startup.py`/`register_routes` gehaald.
- Een nieuw toegevoegde, puur lezende route `/selection_info/`
  (`revit_mcp/views.py`) gaf twee keer correcte data en liet Revit de derde keer
  platgaan — klassiek beeld van thread-onveiligheid.
- De **Nonica AI Connector** (los product) doet vergelijkbare uitleesacties en is
  wél stabiel; die marshalt zijn calls kennelijk netjes naar de API-thread.

### Aanbeveling
- **Niet** het model lezen/schrijven via deze routes-server zolang de handlers
  niet naar de API-thread gemarshald worden. Ook geen nieuwe read-routes
  toevoegen in de huidige vorm.
- Voor uitlezen/nameten: gebruik de Nonica-connector.
- Wil je dit tóch in eigen beheer: draai elke model-aanrakende handler via een
  `IExternalEventHandler` + `ExternalEvent` (of `UIApplication.Idling`), zodat de
  API-aanroep op de Revit-thread gebeurt in plaats van op de HTTP-thread. Dan
  kan `/selection_info/` alsnog veilig.
- `/selection_info/` staat nog in `revit_mcp/views.py` als basis voor die fix,
  maar is in de huidige vorm **onveilig om aan te roepen**.

### Context
Dit kwam op tijdens het bouwen van de pushbutton **Tag Details** (03_R&D), waar
tag-posities nagemeten moesten worden om de plaatsing te kalibreren. Dat nameten
gebeurt sindsdien via Nonica.
