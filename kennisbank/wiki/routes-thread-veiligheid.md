---
titel: Routes-handlers en de Revit API-thread — waarom model-aanrakende routes crashen
status: concept
laatst-bijgewerkt: 2026-09-17
bronnen:
  - "KNOWN_ISSUES.md (repo-root), commits 8b70d7c, d695d83 en e9232b4 (2026-09-07 t/m 2026-09-09)"
  - "revit_mcp/views.py:378-400 (route /selection_info/, uitgeschakeld met status 501)"
  - "W:\\4 - Tijdelijk en verwijderen\\AWO\\Extensions\\03_R&D\\RnD.extension\\03_R&D.tab\\Tools.panel\\Lees_MCP.pushbutton\\script.py (docstring, versie 1.2)"
verwant:
  - mcp-revit-koppeling.md
  - mcp-eigen-tools-toevoegen.md
  - lees-mcp-koppeling.md
  - modeless-venster-persistente-engine.md
  - mcp-versus-custom-tools.md
skill: pyrevit-codestijl
---

# Routes-handlers en de Revit API-thread

De MCP-server uit deze repo praat met Revit via pyRevit Routes
(`mcp-revit-koppeling.md` §1). Die keten crasht Revit met tussenpozen zodra een
route het model aanraakt. Dit artikel legt vast wat daarover gemeten is en welke
voorwaarde een nieuwe route moet halen.

## 1. Het symptoom

Revit valt hard weg, zonder traceback, als een route het model of de geometrie
leest of wijzigt. Het gebeurt niet bij elke aanroep. Dezelfde route kan een paar
keer goed gaan en de volgende keer Revit laten crashen (`KNOWN_ISSUES.md`,
§Symptoom).

| Actie | Raakt het model? | Gedrag |
|---|---|---|
| `GET /status/` | nee | stabiel |
| `POST /execute_code/` (willekeurige IronPython) | ja | crashte Revit, route verwijderd |
| `GET /selection_info/` (alleen lezen: selectie, `get_BoundingBox`, locaties) | ja | twee keer goed, de derde keer crash; uitgeschakeld |

Bron: `KNOWN_ISSUES.md`, tabel "Wat wel en niet stabiel is".

## 2. De vermoedelijke oorzaak

De Revit API is single-threaded. De Routes-handlers draaien op de thread van de
HTTP-server, niet op de API-thread. `Document`, `FilteredElementCollector`,
`Element.get_BoundingBox` en `Selection` aanroepen vanaf die thread is niet
thread-safe (`KNOWN_ISSUES.md`, §Vermoedelijke oorzaak).

Dat verklaart waarom een **read-only** route ook crasht. Alleen lezen is hier
niet hetzelfde als veilig (`revit_mcp/views.py`, docstring van
`get_selection_info`). Het verklaart ook de eerdere diagnose van
`execute_code` niet volledig weg: die route voerde willekeurige code uit zonder
sandbox of transactie (`mcp-revit-koppeling.md` §4), maar de crash van
`/selection_info/` laat zien dat het probleem breder is dan die ene route.

Dit is een derde technisch risico naast de twee die `mcp-versus-custom-tools.md`
§2 noemt (geen transactie, timeout annuleert niet), en versterkt het advies daar:
bouw vaste knoppen met AI in plaats van de modelbewerking via de brug te laten
lopen.

[ONBEVESTIGD] Thread-onveiligheid is een verklaring die bij alle waarnemingen
past, geen aangetoonde oorzaak. Er is geen dump of stacktrace die hem bewijst.

Aanvullend, uit de docstring van de Lees MCP-knop (versie 1.2): de
Routes-server heeft spin-loops zonder time-out als Revit niet idle is, één
globale requesthandler, en een `print` op de server-thread liet Revit op
10-09-2026 hard crashen.

## 3. De tegenmeting van 09-09-2026

Revit 2025.4, model `S-9132_R25`, net herstart en idle. Zes model-aanrakende
routes achter elkaar, allemaal HTTP 200, geen crash: `/list_levels/` (17
levels), `/current_view_info/`, `/model_info/`, `/list_families/` (41
treffers), `/current_view_elements/` (215 elementen). `/status/` gaf
`api_context: true` (`KNOWN_ISSUES.md`, §Bewijs).

Dat weerlegt het probleem niet. Een reeks geslaagde aanroepen is precies wat
thread-onveiligheid oplevert, want `/selection_info/` ging ook twee keer goed.
Wat de meting wél toevoegt: het gaat niet mis bij de eerste aanraking, en het
hangt vermoedelijk samen met of Revit idle is.

## 4. Stand in de repo (2026-09-17)

- `/execute_code/` is uit `startup.py`; `revit_mcp/code_execution.py` en
  `tools/code_execution_tools.py` zijn op 09-09-2026 verwijderd (commit
  `d695d83`). Tot dan stond de MCP-tool nog geregistreerd en gaf hij een 404.
- `/selection_info/` staat nog in `revit_mcp/views.py:378`, maar geeft direct
  **501** terug. De implementatie is intact als basis voor een fix. Er hoort
  geen MCP-tool bij.
- De zeventien routes met een MCP-tool zijn ongewijzigd. Alleen `/status/` raakt
  volgens `KNOWN_ISSUES.md` het model niet; de rest is even kwetsbaar.
  De MCP-tools `launch_revit` en `list_revit_installations` draaien buiten Revit
  en vallen hierbuiten.

## 5. Wat een model-aanrakende route nodig heeft

Het advies uit `KNOWN_ISSUES.md` §Aanbeveling:

1. Geen model lezen of schrijven via deze Routes-server zolang de handlers niet
   naar de API-thread gemarshald worden.
2. Geen nieuwe read-routes toevoegen in de huidige vorm.
3. Wie het in eigen beheer wil: laat elke model-aanrakende handler lopen via een
   `IExternalEventHandler` met `ExternalEvent`, of via `UIApplication.Idling`.
   Dan gebeurt de API-aanroep op de Revit-thread. Pas dan kan de guard uit
   `/selection_info/` weg.

Dat patroon bestaat inmiddels werkend, alleen niet in deze repo maar in de
Lees-MCP: een eigen `TcpListener` op een achtergrondthread die de API nooit
aanraakt, een wachtrij, `ExternalEvent.Raise()` en wachten met een time-out.
Zie `lees-mcp-koppeling.md`.

Een callback die via `ExternalEvent` loopt, heeft zijn eigen valkuil op een
niet-persistente engine: de module-scope is dan gewist. Zie
`modeless-venster-persistente-engine.md`.

## 6. Leesroutes die wel stabiel zijn

- **Nonica-connector** — los product, doet vergelijkbare leesacties en is stabiel;
  marshalt zijn aanroepen vermoedelijk naar de API-thread
  (`KNOWN_ISSUES.md`). Heeft een daglimiet (docstring Lees MCP-knop).
- **Lees-MCP** — eigen koppeling sinds 14-09-2026, zie `lees-mcp-koppeling.md`.

Aanleiding van dit alles was de knop Tag Details (03_R&D): tagposities moesten
nagemeten worden om de plaatsing te kalibreren. Dat nameten liep daarna via
Nonica (`KNOWN_ISSUES.md`, §Context).
