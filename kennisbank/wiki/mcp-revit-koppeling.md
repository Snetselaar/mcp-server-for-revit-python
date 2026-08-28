---
titel: De MCP-Revit-koppeling — opbouw, tools en faalpunten
status: concept
laatst-bijgewerkt: 2026-08-28
bronnen:
  - README.md (deze repo)
  - main.py, startup.py, tools/, revit_mcp/ (deze repo)
  - .mcp.json (deze repo)
  - skill sci-bim-context, references/template-en-mcp.md §C
  - "gemeten 2026-08-26: Revit PID 30312, model S-9132_R25, luisterpoort 48885"
  - "%APPDATA%/pyRevit/pyRevit_config.ini, sectie [routes]"
verwant:
  - rebar-api-parameters.md
  - revit-bronnen-en-communities.md
skill: sci-bim-context
---

# De MCP-Revit-koppeling

Hoe Claude bij een draaiend Revit-model komt. Dit artikel beschrijft de keten
zoals hij in **deze repo** (`mcp-server-for-revit-python`) is geïmplementeerd,
inclusief de plekken waar hij stukgaat.

De skill `sci-bim-context` beschrijft de koppeling op hoofdlijnen
(`references/template-en-mcp.md` §C). Dit artikel gaat een niveau dieper en legt
één afwijking bloot — zie §6.

---

## 1. Twee servers, geen één

De keten bestaat uit twee losse servers die elk een ander protocol spreken en op
een andere poort luisteren (`README.md`, sectie "Key Architecture Components"):

```
Claude / MCP-client
      |  MCP-protocol (stdio of HTTP)
      v
  main.py                          — MCP-server, CPython 3.13, buiten Revit
      |  HTTP naar de Routes-poort (basis 48884 — zie §2)
      v
  pyRevit Routes                   — REST-API, IronPython 2.7, BINNEN Revit
      |  Revit API-aanroepen
      v
  Revit
```

De twee helften draaien op verschillende Python-versies. `main.py` en `tools/`
op CPython 3.13 (`.python-version`, `pyproject.toml` `requires-python = ">=3.11"`).
`startup.py` en alles in `revit_mcp/` op een **Python 2-engine binnen Revit** —
zichtbaar in `revit_mcp/code_execution.py:11`: `from StringIO import StringIO`.
Dat het om de **IronPython 2.7**-engine gaat en niet om de CPython-engine van
pyRevit staat niet in deze repo; die vaststelling komt uit de skill
`pyrevit-codestijl`. Daar gelden ook de beperkingen die eruit volgen: geen
f-strings, geen `pathlib`.

**Uitzondering:** de tools `launch_revit` en `list_revit_installations` draaien
volledig aan de MCP-kant met `subprocess`, en pollen daarna het
health-endpoint tot de brug staat (`README.md`, noot onder het architectuurblok).
Zij zijn daarmee de enige twee tools die zonder draaiende Revit iets kunnen —
afgeleid uit `tools/launch_tools.py`, dat als enige tool-module geen
`revit_post`/`revit_get`-aanroep naar de Routes-poort nodig heeft voor zijn
kernwerk.

## 2. Poorten en adressen

| Wat | Waarde | Bron |
|---|---|---|
| pyRevit Routes | `localhost:48884` (basispoort, zie hieronder) | `main.py:24-25` (`REVIT_HOST`, `REVIT_PORT`) |
| Basis-URL naar Revit | `http://localhost:48884/revit_mcp` | `main.py:26` |
| MCP-server bij HTTP-transport | `127.0.0.1:8000` | `main.py:14-15` |
| API-naam in pyRevit | `revit_mcp` | `startup.py`, `routes.API("revit_mcp")` |

De API-naam `revit_mcp` is het pad-voorvoegsel van elk endpoint. Dat is waarom
de health check op `.../revit_mcp/status/` staat en niet op `/status/`.

### De poort ligt niet vast

48884 is de **basispoort**, niet gegarandeerd de poort waarop geluisterd wordt.
Gemeten op 2026-08-26: Revit (PID 30312, model `S-9132_R25 - versie drie
kappen`) luisterde op **48885**, en op 48884 luisterde niets. De sectie
`[routes]` in `%APPDATA%\pyRevit\pyRevit_config.ini` bevat geen `port`-sleutel
— alleen `enabled = true` en `core_api = true` — dus de poortkeuze komt uit
pyRevit zelf en niet uit een instelling op deze machine.
[ONBEVESTIGD] Waarschijnlijk schuift pyRevit per Revit-instantie op vanaf de
basispoort; dat is niet in de pyRevit-broncode nagelopen.

Sinds 2026-08-26 is de poort daarom instelbaar (`main.py:24-25`):

```python
REVIT_HOST = os.environ.get("REVIT_HOST", "localhost")
REVIT_PORT = int(os.environ.get("REVIT_PORT", "48884"))
```

De default blijft 48884, zodat het gedrag zonder omgevingsvariabelen gelijk is
aan upstream. De werkelijke poort staat in `.mcp.json` onder `env`.

De poort opzoeken:

```powershell
Get-NetTCPConnection -State Listen |
  Where-Object { $_.LocalPort -ge 48884 -and $_.LocalPort -le 48890 } |
  Select-Object LocalPort, OwningProcess
```

## 3. Timeouts

Drie verschillende, en dat verklaart een deel van de "hij doet niks"-momenten:

- **30 seconden** voor gewone GET/POST (`main.py:59`, `timeout: float = 30.0`).
- **60 seconden** voor beeldexport (`main.py:42`), want een view exporteren duurt
  langer.
- Bij een timeout geeft `main.py` terug: *"The operation may still be running in
  Revit"* (`main.py:72`). Dat is letterlijk waar. **Een timeout is geen
  annulering** — de transactie in Revit loopt door. Opnieuw aanroepen kan de
  bewerking dus dubbel uitvoeren.

## 4. De 20 tools en hun endpoints

Elke MCP-tool in `tools/` mapt op één Routes-endpoint in `revit_mcp/`.
Nagelopen op 2026-08-25 tegen `tools/*.py` en `revit_mcp/*.py`; deze tabel
verschuift zodra upstream een tool toevoegt.

| MCP-tool | Endpoint | Methode | Handler |
|---|---|---|---|
| `get_revit_status` | `/status/` | GET | `revit_mcp/status.py:15` |
| `get_revit_model_info` | `/model_info/` | GET | `revit_mcp/model_info.py:20` |
| `get_revit_view` | `/get_view/<view_name>` | GET | `revit_mcp/views.py:28` |
| `list_revit_views` | `/list_views/` | GET | `revit_mcp/views.py:208` |
| `get_current_view_info` | `/current_view_info/` | GET | `revit_mcp/views.py:294` |
| `get_current_view_elements` | `/current_view_elements/` | POST | `revit_mcp/views.py:378` |
| `list_levels` | `/list_levels/` | GET | `revit_mcp/placement.py:440` |
| `list_families` | `/list_families/` | POST | `revit_mcp/placement.py:305` |
| `list_family_categories` | `/list_family_categories/` | GET | `revit_mcp/placement.py:380` |
| `place_family` | `/place_family/` | POST | `revit_mcp/placement.py:19` |
| `color_splash` | `/color_splash/` | POST | `revit_mcp/colors.py:1087` |
| `clear_colors` | `/clear_colors/` | POST | `revit_mcp/colors.py:1128` |
| `list_category_parameters` | `/list_category_parameters/` | POST | `revit_mcp/colors.py:1160` |
| `execute_revit_code` | `/execute_code/` | POST | `revit_mcp/code_execution.py:20` |
| `open_document` | `/open_document/` | POST | `revit_mcp/document.py:19` |
| `close_document` | `/close_document/` | POST | `revit_mcp/document.py:131` |
| `save_document` | `/save_document/` | POST | `revit_mcp/document.py:197` |
| `sync_with_central` | `/sync_with_central/` | POST | `revit_mcp/document.py:271` |
| `list_revit_installations` | — (MCP-kant) | — | `tools/launch_tools.py` |
| `launch_revit` | — (MCP-kant) | — | `tools/launch_tools.py` |

Registratievolgorde staat in `tools/__init__.py` (MCP-kant) en `startup.py`
(Revit-kant). Een nieuwe tool vereist een wijziging in beide.

### `execute_revit_code` is de ontsnappingsklep

Voert IronPython uit binnen de Revit-context met `doc`, `uidoc`, `DB` en `revit`
al in de namespace (`revit_mcp/code_execution.py:53-58`). `print` wordt
opgevangen in een `StringIO` en teruggegeven, dus printen is het debugkanaal
(`revit_mcp/code_execution.py:49-61`).

De handler geeft nuttige foutafhandeling terug: bij `AttributeError`,
`NullReferenceException` en `InvalidOperationException` komt er een gerichte hint
mee (`revit_mcp/code_execution.py:93-116`), plus de volledige traceback.

Dit is de tool die alles kan wat de andere negentien niet kunnen, en de tool die
het model kan slopen.

#### `use_transaction` doet niets

De docstring documenteert een payload-veld `use_transaction` met default true,
"set false for UI ops like switching the active view"
(`revit_mcp/code_execution.py:29`). **Dat veld wordt nergens uitgelezen.**
Gecontroleerd op 2026-08-25: `use_transaction` komt in het hele bestand van 140
regels alleen in die docstring voor, en het woord `Transaction` alleen nog in een
hint-string op regel 115. De handler doet niets meer dan `exec(code_to_execute,
namespace)` (`revit_mcp/code_execution.py:65`).

**Gevolg: er is geen automatische transactie.** Modelwijzigende code moet zijn
eigen transactie openen, precies zoals het transactiepatroon uit de skill
`pyrevit-codestijl` voorschrijft:

```python
# IronPython 2.7
t = DB.Transaction(doc, "beschrijving")
t.Start()
try:
    # wijzigingen
    t.Commit()
except Exception:
    t.RollBack()
    raise
```

Zonder eigen transactie faalt modelwijzigende code met een
`InvalidOperationException`; de handler geeft dan zelf de hint om een transactie
te openen (`revit_mcp/code_execution.py:112-116`). Dat is meteen de bevestiging
dat er geen omhullende transactie is.

## 5. Faalpunten

Op volgorde van hoe vaak ze voorkomen.

1. **Routes Server staat uit.** Aanzetten via pyRevit-tab → Settings → Routes →
   `Routes Server` (`README.md`, "Activate pyRevit Routes"). Zonder dit luistert
   er niets op de Routes-poort. De instelling wordt bewaard: op 2026-08-26 stond
   `enabled = true` in `[routes]` van `pyRevit_config.ini`. [ONBEVESTIGD] Of dit
   per Revit-sessie opnieuw aan moet is daarmee nog niet nagemeten — de README
   zegt elders dat de Routes-service automatisch laadt bij het starten van Revit
   ("Testing Your Connection").
2. **Geen actief document.** `/status/` geeft dan HTTP **503** met
   `"error": "No active Revit document"` (`revit_mcp/status.py:36-41`). Revit
   draait wel, maar er staat geen model open. Een leeg Revit-venster telt niet.
3. **Extensie niet geladen of pyRevit niet herladen.** Na het toevoegen van het
   extensiepad is een pyRevit-reload nodig, soms een volledige Revit-herstart
   (`README.md`, stap 6 van de handmatige installatie). Dit komt overeen met de
   waarschuwing in `sci-bim-context` §2 over handmatig toevoegen van extensies.
4. **Timeout terwijl de bewerking doorloopt.** Zie §3.
5. **Verkeerd pad in `.mcp.json`.** Het pad is absoluut en machine-specifiek,
   zowel de venv-Python als `main.py`. Geen theoretisch risico: tot 2026-08-26
   wees `.mcp.json` naar
   `C:\Users\S-WOU1A\Documents\GitHub\mcp-server-for-revit-python\`, waar na de
   OneDrive-verhuizing alleen de pyRevit-helft staat (`startup.py`, `revit_mcp/`,
   `extension.json`) en géén `main.py` of `.venv`. De MCP-server kon dus niet
   starten. Op 2026-08-26 rechtgezet naar de clone onder
   `OneDrive - Snetselaar Constructieve Ingenieurs\Documenten\GitHub\`.

6. **Bewerking in de verkeerde kopie.** Revit laadt de extensie niet uit deze
   repo maar uit
   `%APPDATA%\pyRevit\Extensions\mcp-server-for-revit-python.extension` — een
   losse kopie van `startup.py`, `extension.json` en `revit_mcp/`. De vier
   W:-paden in `userextensions` van `pyRevit_config.ini` bevatten hem niet. Op
   2026-08-26 waren die kopie en deze clone byte-gelijk (`startup.py`,
   `revit_mcp/status.py`, `revit_mcp/code_execution.py`, `revit_mcp/views.py`
   vergeleken), maar dat blijft niet vanzelf zo: een wijziging in `revit_mcp/`
   in deze repo doet in Revit niets tot hij naar die map is gekopieerd én
   pyRevit is herladen.

### Snelle diagnose

```
http://localhost:48884/revit_mcp/status/      (of 48885 — zie §2)
```

in een browser. Verwacht antwoord (`README.md`, "Testing Your Connection"):

```json
{"status": "active",
 "health": "healthy",
 "revit_available": true,
 "document_title": "your_revit_filename",
 "api_name": "revit_mcp"}
```

Geen antwoord = verkeerde poort (§2), Routes staat uit, of de extensie is niet
geladen (punt 1 of 3).
HTTP 503 = Revit draait, geen document open (punt 2).

## 6. Conflict met de skill `sci-bim-context`

> **Conflict met skill `sci-bim-context`:** `references/template-en-mcp.md` §C
> noemt onder "Veelgebruikte Revit-MCP-tools (en geobserveerde ID's)" acht
> tools: `get_active_view_in_revit`, `get_all_workset_information`,
> `get_all_warnings_in_the_model`, `get_all_used_families_in_model`,
> `get_all_project_units`, `get_category_by_keyword`,
> `get_elements_by_category`, `get_parameter_value_for_element_ids`.
> (De health check van 2026-08-25 telde er zeven en sloeg
> `get_elements_by_category` over; op 2026-08-28 nageteld in de skillbron
> `Snetselaar_BIM/sci-bim-context/references/template-en-mcp.md`.)
>
> **Geen van die acht namen komt voor in deze repo.** Gecontroleerd tegen de
> twintig tools in `tools/*.py` (§4). De dichtstbijzijnde equivalenten heten
> hier anders: `get_current_view_info` in plaats van `get_active_view_in_revit`,
> `list_families` in plaats van `get_all_used_families_in_model`. Voor worksets,
> warnings en project units bestaat hier **geen** tool; die zijn alleen via
> `execute_revit_code` te benaderen.

**Vastgesteld op 2026-08-26: het is déze repo die in Revit draait.** De health
check op `http://localhost:48885/revit_mcp/status/` gaf:

```json
{"health": "healthy", "revit_available": true,
 "document_title": "S-9132_R25 - versie drie kappen",
 "api_name": "revit_mcp", "status": "active"}
```

`api_name: "revit_mcp"` is de API-naam die `startup.py` van deze repo
registreert. De acht toolnamen uit de skill horen dus bij een andere server, of
bij een versie waarin ze anders heetten. [ONBEVESTIGD] Welke van de twee is niet
uitgezocht, en voor het gebruik maakt het niet uit: hier gelden de namen uit §4.

Ook de startwijze verschilt. De skill noemt combined HTTP-modus
(`uv run --with "mcp[cli]" main.py --combined`, client op
`http://localhost:8000/mcp`); `.mcp.json` in deze repo configureert
**stdio-transport** — de venv-Python roept `main.py` aan zonder vlaggen, en
zonder vlaggen is het transport `stdio` (`main.py:115` en `main.py:127`). Beide werken, maar
het zijn twee verschillende opstellingen.

**Stand 2026-08-28:** de tabel is vervangen door de twintig namen uit §4, in de
skillbron `Snetselaar_BIM/sci-bim-context/references/template-en-mcp.md`. Ook de
repo-naam, de poort en de startwijze in die sectie zijn gelijkgetrokken. De rem
uit `../CLAUDE.md` §3 regel 2 gold zolang niet vaststond welke server draaide;
dat staat nu vast.

Het conflict hierboven beschrijft dus de skill zoals hij tot 2026-08-28 luidde —
en het blijft gelden voor de versie die Claude in een gesprek leest, totdat de
skill opnieuw naar claude.ai is geüpload. Die upload is handwerk.

## 7. Waar dit niet over gaat

- Categorie- en parameter-ID's: staan in `sci-bim-context`,
  `references/template-en-mcp.md` §C. `hoofd_map` en `sub_map` altijd op naam
  opzoeken, nooit op ID.
- Het schrijven van IronPython voor `execute_revit_code`: skill
  `pyrevit-codestijl`.
- Het opzoeken van Revit API-signaturen: skill `revit-api-docs`, en voor het
  bredere bronnenlandschap `revit-bronnen-en-communities.md`.
- Concrete parameters uitlezen: `rebar-api-parameters.md`. Dat gaat in de praktijk
  via `execute_revit_code`, en let dan op §4 hierboven — die tool opent géén
  transactie. Lezen kan zonder, schrijven niet.
