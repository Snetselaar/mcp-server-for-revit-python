---
titel: De MCP-Revit-koppeling — opbouw, tools en faalpunten
status: concept
laatst-bijgewerkt: 2026-09-17
bronnen:
  - README.md (deze repo)
  - main.py, startup.py, tools/, revit_mcp/ (deze repo)
  - .mcp.json (deze repo)
  - skill sci-bim-context, references/template-en-mcp.md §C
  - "gemeten 2026-08-26: Revit PID 30312, model S-9132_R25, luisterpoort 48885"
  - "%APPDATA%/pyRevit/pyRevit_config.ini, sectie [routes]"
  - "raw/2026-08-27_revit_mcp_bronnen_transcripties.md §2, §3, §6"
  - "gemeten 2026-08-31: Revit PID 19100, model S-9464 Apartementen_R25, luisterpoort 48884"
  - "pyrevitlib/pyrevit/routes/server/server.py:41-42, 108-132 (pyRevit-Master clone)"
  - "gebruiker, bevestigd in sessie op 2026-08-31: Nonica-connector als vervangende leesroute"
  - "KNOWN_ISSUES.md (repo-root, 2026-09-09) en commit d695d83"
  - "outputs/2026-09-07-mcp-server-herstel.md, met de onderliggende bestanden extension.json, requirements.txt en %APPDATA%/pyRevit/pyRevit_config.ini (herlezen 2026-09-17)"
  - "gemeten 2026-09-17: junction %APPDATA%/pyRevit/Extensions/mcp-server-for-revit-python.extension, regelnummers in main.py en revit_mcp/"
  - "toollijst van de MCP-connectors Revit (Nonica) en revit-lezen, gelezen 2026-09-17"
verwant:
  - rebar-api-parameters.md
  - revit-bronnen-en-communities.md
  - mcp-eigen-tools-toevoegen.md
  - mcp-versus-custom-tools.md
  - vyssuals-datavisualisatie.md
  - routes-thread-veiligheid.md
  - lees-mcp-koppeling.md
skill: sci-bim-context
---

# De MCP-Revit-koppeling

Hoe Claude bij een draaiend Revit-model komt. Dit artikel beschrijft de keten
zoals hij in **deze repo** (`mcp-server-for-revit-python`) is geïmplementeerd,
inclusief de plekken waar hij stukgaat.

De skill `sci-bim-context` beschrijft de koppeling op hoofdlijnen
(`references/template-en-mcp.md` §C). Dit artikel gaat een niveau dieper en legt
één afwijking bloot — zie §6.

> **Lees eerst `routes-thread-veiligheid.md`.** Sinds 09-09-2026 staat in
> `KNOWN_ISSUES.md` dat routes die het model aanraken Revit met tussenpozen laten
> crashen, omdat de handlers niet op de Revit API-thread draaien. Voor uitlezen
> zijn de Nonica-connector en de eigen Lees-MCP (`lees-mcp-koppeling.md`) de
> stabiele routes.

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
zichtbaar in `revit_mcp/utils.py:33`: `unicode(text)`, een builtin die in
Python 3 niet bestaat. (Tot 09-09-2026 stond het bewijs in
`revit_mcp/code_execution.py:11`, `from StringIO import StringIO`; dat bestand is
verwijderd.)
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
| pyRevit Routes | `localhost:48884` (basispoort, zie hieronder) | `main.py:22-23` (`REVIT_HOST`, `REVIT_PORT`) |
| Basis-URL naar Revit | `http://localhost:48884/revit_mcp` | `main.py:24` |
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

Sinds 2026-08-26 is de poort daarom instelbaar (`main.py:22-23`, regelnummers
gemeten 2026-09-17):

```python
REVIT_HOST = os.environ.get("REVIT_HOST", "localhost")
REVIT_PORT = int(os.environ.get("REVIT_PORT", "48884"))
```

De default blijft 48884, zodat het gedrag zonder omgevingsvariabelen gelijk is
aan upstream. De werkelijke poort staat in `.mcp.json` onder `env`.

Op 2026-08-31 stond in `.mcp.json` nog `48885` terwijl de draaiende Revit
(PID 19100) op **48884** luisterde — de client wees dus naar een poort waar
niets stond. Teruggezet op 48884. Dit blijft een handmatige stap zolang de
poort per Revit-instantie opschuift.

De poort opzoeken:

```powershell
Get-NetTCPConnection -State Listen |
  Where-Object { $_.LocalPort -ge 48884 -and $_.LocalPort -le 48890 } |
  Select-Object LocalPort, OwningProcess
```

### Beveiliging: Routes bindt standaard op 0.0.0.0

pyRevit Routes bindt standaard aan `0.0.0.0`
(`raw/2026-08-27_revit_mcp_bronnen_transcripties.md` §3; pyRevit-docs,
`user_config.routes.host`/`.port`). Elke machine op hetzelfde netwerk (LAN of VPN)
kan de Routes-poort dan bereiken en het open Revit-model uitlezen of wijzigen. De
veilige binding is `127.0.0.1` — alleen lokaal, en genoeg, want de MCP-server
verbindt via localhost (`main.py:22`, `REVIT_HOST` default `localhost`).

**Gemeten 2026-08-28 op de werkplek:** de live socket stond op `0.0.0.0:48884`
(PID 37684) en `[routes]` in `pyRevit_config.ini` had geen `host`-sleutel — dus de
standaard. Bevestigd kwetsbaar; het eerdere vermoeden is daarmee een meting.

**Let op — de opdracht uit de meeste tutorials klopt niet voor deze
pyRevit-versie.** `pyrevit config routes --host localhost` bestaat hier niet:
`pyrevit configs routes` kent alleen `enable`/`disable`, `port` en `coreapi`
(nagelopen 2026-08-28 met `pyrevit configs routes --help`). Zet de host via het
generieke optie-pad:

```bash
pyrevit configs "routes:host" 127.0.0.1
```

Dat schrijft `host = 127.0.0.1` onder `[routes]`. **Op 2026-08-28 ingesteld en
geactiveerd.** Na een Revit-herstart bindt de socket op `127.0.0.1:48884`
(geverifieerd met `Get-NetTCPConnection`) en antwoordt `/status/` normaal — de
MCP-keten werkt dus op de localhost-binding, wat klopt want de MCP-server
verbindt zelf via localhost.

Twee dingen die daarbij opvielen:

- Een gewone **pyRevit-reload liet Revit vastlopen** (bekend probleem, de
  persistente-engine-hang). Een volledige **Revit-herstart** is de betrouwbare
  manier om de config-wijziging te activeren.
- In de ini staat de waarde na de herstart als `host = "127.0.0.1"` — met quotes.
  pyRevit serialiseert strings zo; de socket bewijst dat de waarde gehonoreerd
  wordt.

## 3. Timeouts

Drie verschillende, en dat verklaart een deel van de "hij doet niks"-momenten:

- **30 seconden** voor gewone GET/POST (`main.py:57`, `timeout: float = 30.0`).
- **60 seconden** voor beeldexport (`main.py:40`), want een view exporteren duurt
  langer.
- Bij een timeout geeft `main.py` terug: *"The operation may still be running in
  Revit"* (`main.py:70`). Dat is letterlijk waar. **Een timeout is geen
  annulering** — de transactie in Revit loopt door. Opnieuw aanroepen kan de
  bewerking dus dubbel uitvoeren.

## 4. De tools en hun endpoints

Elke MCP-tool in `tools/` mapt op één Routes-endpoint in `revit_mcp/`.
Nagelopen op 2026-08-25, regelnummers opnieuw gemeten op 2026-09-17 tegen
`tools/*.py` en `revit_mcp/*.py`; deze tabel verschuift zodra upstream een tool
toevoegt.

| MCP-tool | Endpoint | Methode | Handler |
|---|---|---|---|
| `get_revit_status` | `/status/` | GET | `revit_mcp/status.py:16` |
| `get_revit_model_info` | `/model_info/` | GET | `revit_mcp/model_info.py:20` |
| `get_revit_view` | `/get_view/<view_name>` | GET | `revit_mcp/views.py:28` |
| `list_revit_views` | `/list_views/` | GET | `revit_mcp/views.py:208` |
| `get_current_view_info` | `/current_view_info/` | GET | `revit_mcp/views.py:294` |
| `get_current_view_elements` | `/current_view_elements/` | POST | `revit_mcp/views.py:499` |
| — (geen tool) | `/selection_info/` | GET | `revit_mcp/views.py:378`, **uitgeschakeld**: geeft sinds 09-09-2026 direct 501, zie `routes-thread-veiligheid.md` |
| `list_levels` | `/list_levels/` | GET | `revit_mcp/placement.py:440` |
| `list_families` | `/list_families/` | POST | `revit_mcp/placement.py:305` |
| `list_family_categories` | `/list_family_categories/` | GET | `revit_mcp/placement.py:380` |
| `place_family` | `/place_family/` | POST | `revit_mcp/placement.py:19` |
| `color_splash` | `/color_splash/` | POST | `revit_mcp/colors.py:1087` |
| `clear_colors` | `/clear_colors/` | POST | `revit_mcp/colors.py:1128` |
| `list_category_parameters` | `/list_category_parameters/` | POST | `revit_mcp/colors.py:1160` |
| ~~`execute_revit_code`~~ | ~~`/execute_code/`~~ | — | **verwijderd**, zie hieronder |
| `open_document` | `/open_document/` | POST | `revit_mcp/document.py:19` |
| `close_document` | `/close_document/` | POST | `revit_mcp/document.py:131` |
| `save_document` | `/save_document/` | POST | `revit_mcp/document.py:197` |
| `sync_with_central` | `/sync_with_central/` | POST | `revit_mcp/document.py:271` |
| `list_revit_installations` | — (MCP-kant) | — | `tools/launch_tools.py` |
| `launch_revit` | — (MCP-kant) | — | `tools/launch_tools.py` |

Registratievolgorde staat in `tools/__init__.py` (MCP-kant) en `startup.py`
(Revit-kant). Een nieuwe tool vereist een wijziging in beide.

### `execute_revit_code` was de ontsnappingsklep — VERWIJDERD

> **Deze route en tool bestaan niet meer.** De verwijdering ging in twee
> stappen. Eind augustus 2026 ging de registratie van `/execute_code/` uit
> `startup.py`; `KNOWN_ISSUES.md` dateert de crashes op 28-08-2026, terwijl de
> route die dag ook nog een geslaagde meting deed (`rebar-api-parameters.md`
> §0). Het besluit is in deze kennisbank gelogd op 31-08-2026. De bestanden
> `revit_mcp/code_execution.py` en `tools/code_execution_tools.py` zijn pas op
> **09-09-2026** verwijderd (commit `d695d83`). Tot dan stond de MCP-tool nog
> geregistreerd en gaf hij een 404; de handshake van 07-09 telde daarom nog
> twintig tools (`outputs/2026-09-07-mcp-server-herstel.md`).
>
> Reden: de route `exec()`te willekeurige IronPython in het levende Revit-proces
> zonder schema, sandbox of transactie. De verklaring van de crash is sindsdien
> verbreed: ook de read-only route `/selection_info/` crashte Revit, dus het
> probleem zit in model-toegang vanaf de Routes-thread, niet alleen in `exec()`.
> Zie `routes-thread-veiligheid.md`.
>
> De beschrijving hieronder blijft staan als verantwoording van het besluit.
> De regelverwijzingen naar `code_execution.py` wijzen naar een bestand dat niet
> meer bestaat; ze gelden voor de stand van 2026-08-25.

Voert IronPython uit binnen de Revit-context met `doc`, `uidoc`, `DB` en `revit`
al in de namespace (`revit_mcp/code_execution.py:53-58`). `print` wordt
opgevangen in een `StringIO` en teruggegeven, dus printen is het debugkanaal
(`revit_mcp/code_execution.py:49-61`).

De handler geeft nuttige foutafhandeling terug: bij `AttributeError`,
`NullReferenceException` en `InvalidOperationException` komt er een gerichte hint
mee (`revit_mcp/code_execution.py:93-116`), plus de volledige traceback.

Dit is de tool die alles kon wat de andere negentien niet kunnen. Dat hij het
model kon slopen, deelt hij met elke route die het model aanraakt
(`routes-thread-veiligheid.md`).

**Vervangende leesroute (bevestigd door de gebruiker, 2026-08-31): de
Nonica-connector.** Voor worksets, warnings, project units en
per-element-parameters — de vier categorieën die geen eigen endpoint hebben en
tot eind augustus via `execute_revit_code` gingen — is de Nonica-connector de
weg om uit te lezen. Sinds 14-09-2026 is er een tweede: de eigen Lees-MCP, met
dezelfde toolnamen (`lees-mcp-koppeling.md`). De Nonica-connector kán ook schrijven: hij biedt naast de
leestools `set_*`-tools aan, onder meer `set_parameter_value_for_elements`,
`set_movement_for_elements`, `set_rotation_for_elements`, `set_copy_elements` en
`set_delete_elements` (toollijst van de connector, 2026-09-17). Die horen alleen
op expliciete opdracht gebruikt te worden. [ONBEVESTIGD] Hoe Nonica de aanroepen
naar de API-thread brengt, is niet uitgezocht. De Lees-MCP kan bewust niet
schrijven.

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
5. **Verkeerd pad of kapotte omgeving in `.mcp.json`.** Twee keer misgegaan.
   Tot 2026-08-26 wees `.mcp.json` naar een map zonder `main.py`; daarna naar een
   hardgecodeerde `.venv`-Python in de OneDrive-clone, en op 2026-09-07 startte de
   server helemaal niet meer
   (`outputs/2026-09-07-mcp-server-herstel.md`). **Stand 2026-09-17:**
   `.mcp.json` start met
   `uv run --directory ${REVIT_MCP_HOME:-C:\Users\S-WOU1A\Documents\GitHub\mcp-server-for-revit-python} main.py`
   (commit `d3ca260`). `uv` bouwt de omgeving zelf uit `uv.lock`, dus er is geen
   venv-pad meer om te verouderen. Die Documents-map is sinds de merge van
   09-09-2026 een volledige clone met `main.py`, `pyproject.toml` en `uv.lock`.

6. **Bewerking in de verkeerde kopie.** Revit laadt de extensie uit
   `%APPDATA%\pyRevit\Extensions\mcp-server-for-revit-python.extension`, en dat is
   een **junction** naar `C:\Users\S-WOU1A\Documents\GitHub\mcp-server-for-revit-python`
   (gemeten 2026-09-17). Een wijziging in `revit_mcp/` van die clone komt dus na
   een reload of herstart direct in Revit aan. De kopie die kan achterlopen is de
   tweede clone onder `OneDrive - Snetselaar Constructieve Ingenieurs\Documenten\GitHub\`.
   Dat het risico reëel is, bleek op 07-09: `revit_mcp/views.py` in de live map
   liep 104 regels vóór op git, omdat `/selection_info/` nooit was gecommit
   (herstelverslag, "Losse observatie"). Tot eind augustus was de extensiemap nog
   een losse kopie; toen was dit faalpunt andersom.

7. **Kapotte pyRevit-versie.** [ONBEVESTIGD] pyRevit **6.5.3** heeft volgens de
   bron een bug in de Routes-module; **6.4.0** wordt aangeraden
   (`raw/2026-08-27_revit_mcp_bronnen_transcripties.md` §3, Stap 1). Niet zelf
   nagemeten en geen issuenummer bij vermeld. Staat Routes ondanks `enabled =
   true` niet te luisteren, dan is de pyRevit-versie een kandidaat. Gemeten
   versies tot nu toe: 6.5.5 op de werkplek van AWO en 6.1.0 bij S-WUL1N
   (`modeless-venster-persistente-engine.md`); 6.5.3 niet aangetroffen.

8. **`requirements.txt` onoplosbaar.** Op 2026-09-07 eiste `mcp==1.23.0`
   `typing-inspection>=0.4.1`, terwijl die op `0.4.0` gepind stond. Stand
   2026-09-17: `mcp==1.29.1` en `typing-inspection==0.4.4` (`requirements.txt:18`
   en `:37`). Bij elke dependency-bump opnieuw `uv sync` draaien.

9. **`[routes]` verdwenen uit `pyRevit_config.ini`.** Op 2026-09-07 om 07:36 werd
   de ini herschreven en verloor `[routes]`, de clones-registratie en de
   extensie-sectie; ook `tab_colors` kromp. Oorzaak onbekend. Herstel:
   `pyrevit configs routes enable`, `coreapi enable`, en `host = "127.0.0.1"`
   mét aanhalingstekens. Stand 2026-09-17: `enabled = true` en
   `host = "127.0.0.1"` staan erin.

10. **Extensie staat uit ondanks alles.** `extension.json` heeft
    `"default_enabled": "False"`. Zonder de sectie
    `[mcp-server-for-revit-python.extension]` met `disabled = false` in
    `pyRevit_config.ini` draait `startup.py` nooit. De Routes-server antwoordt dan
    wel, maar met `RouteHandlerNotDefinedException`. `pyrevit extensions enable`
    vindt deze extensie niet, want hij ziet de junction niet; de sectie moet met de
    hand in de ini, gevolgd door een Revit-herstart. Stand 2026-09-17: de sectie
    staat erin (`pyRevit_config.ini:60-61`).

11. **Routes-handler crasht Revit.** Model-aanrakende routes kunnen Revit met
    tussenpozen laten crashen. Zie `routes-thread-veiligheid.md`.

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
`RouteHandlerNotDefinedException` = Routes draait, maar `startup.py` van deze
extensie niet (punt 10).
HTTP 501 op `/selection_info/` = bewust uitgeschakeld (§4).

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
registreert. De acht toolnamen uit de skill horen dus bij een andere server.

**Welke server, vastgesteld op 2026-09-17: de Nonica-connector.** De
MCP-connector `Revit` (Nonica) biedt precies deze acht namen aan, naast andere:
`get_active_view_in_revit`, `get_all_workset_information`,
`get_all_warnings_in_the_model`, `get_all_used_families_in_model`,
`get_all_project_units`, `get_category_by_keyword`, `get_elements_by_category` en
`get_parameter_value_for_element_ids` (toollijst van de connector in een
Claude Code-sessie). De skill beschreef dus niet verzonnen tools, maar die van
de verkeerde server. De eigen Lees-MCP neemt de meeste van die namen over
(`lees-mcp-koppeling.md` §4).

Ook de startwijze verschilt. De skill noemt combined HTTP-modus
(`uv run --with "mcp[cli]" main.py --combined`, client op
`http://localhost:8000/mcp`); `.mcp.json` in deze repo configureert
**stdio-transport**. Op 2026-08-28 riep de venv-Python `main.py` aan zonder
vlaggen; sinds 2026-09-07 doet `uv run --directory` dat (§5 punt 5). Zonder
vlaggen is het transport `stdio` (`main.py:113`, gemeten 2026-09-17). Beide
opstellingen werken, maar het zijn er twee.

**Stand 2026-08-28:** de tabel is vervangen door de twintig namen uit §4, in de
skillbron `Snetselaar_BIM/sci-bim-context/references/template-en-mcp.md`. Ook de
repo-naam, de poort en de startwijze in die sectie zijn gelijkgetrokken. De rem
uit `../CLAUDE.md` §3 regel 2 gold zolang niet vaststond welke server draaide;
dat staat nu vast.

**Opgelost 2026-08-28.** De gecorrigeerde skill is die dag naar claude.ai
geüpload en vastgelegd met `skill_uploads.ps1 -Mark sci-bim-context` (sha256
`6513f443…`, commit `aec356d`). Wat Claude in een gesprek leest komt nu overeen
met §4. Het conflictblok hierboven is daarmee historisch — het beschrijft de
skill zoals hij tot 2026-08-28 luidde en is bewaard als bronketen, niet als een
openstaande tegenspraak.

> **Conflict met skill `sci-bim-context`, gevonden bij de health check van
> 2026-08-31 — opgelost dezelfde dag.** `references/template-en-mcp.md` §C
> telde nog "Twintig stuks" tools en noemde `execute_revit_code` —
> "Willekeurige IronPython in de Revit-context" — als bestaande rij, inclusief
> de zin dat worksets, warnings, project units en per-element-parameters daar
> allemaal doorheen gingen. Die route bestond op dat moment al niet meer (zie
> hierboven); de skillbron was dus opnieuw stale, drie dagen na de vorige
> correctie. Zie `outputs/2026-08-31-healthcheck.md` bevinding 1.
>
> **Opgelost 2026-08-31.** De skillbron is bijgewerkt (rij verwijderd,
> "Twintig" → "Negentien", de tekst over de ontsnappingsklep herschreven met de
> Nonica-connector als vervangende leesroute), ingepakt met `pack_skill.ps1`,
> geüpload naar claude.ai en vastgelegd met `skill_uploads.ps1 -Mark
> sci-bim-context` (sha256 `97ec9542…`, commit `921994f`). Wat Claude in een
> gesprek leest komt weer overeen met §4 hierboven.

## 7. Waar dit niet over gaat

- Categorie- en parameter-ID's: staan in `sci-bim-context`,
  `references/template-en-mcp.md` §C. `hoofd_map` en `sub_map` altijd op naam
  opzoeken, nooit op ID.
- IronPython schrijven voor de resterende routes (zeventien met een tool, plus
  het uitgeschakelde `/selection_info/`; geteld 2026-09-17): skill
  `pyrevit-codestijl`. (Tot eind augustus gold dit ook voor `execute_revit_code`;
  die route is verwijderd, zie §4.) Een nieuwe model-aanrakende route: eerst
  `routes-thread-veiligheid.md`.
- Het opzoeken van Revit API-signaturen: skill `revit-api-docs`, en voor het
  bredere bronnenlandschap `revit-bronnen-en-communities.md`.
- Concrete parameters uitlezen: `rebar-api-parameters.md`. Dat ging tot
  eind augustus via `execute_revit_code` (zonder eigen transactie, zie §4); sinds
  de verwijdering zijn de Nonica-connector en de Lees-MCP de leesroutes (§4). Nonica
  kan ook schrijven via `set_*`-tools; de Lees-MCP niet.
