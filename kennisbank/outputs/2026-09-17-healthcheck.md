---
type: healthcheck
datum: 2026-09-17
argument: geen (zonder web)
---

# Health check 2026-09-17

- **Artikelen:** 19 in `wiki/` (5 nieuw sinds de vorige check van 2026-08-31), alle 19 volledig gelezen, plus `CLAUDE.md`, `stijlgids.md`, `index.md`, `memory.md`, de raw-koppen en de repo-bestanden waar de wiki naar verwijst.
- **Bevindingen:** tegenstrijdigheden 10 · claims zonder bron 7 · gaten 7 · veroudering 6 · stijl 6 · kruisverwijzingen 7 · coverage 2.
- **Ernstigste punt:** `mcp-revit-koppeling.md` en `mcp-eigen-tools-toevoegen.md` beschrijven een keten die niet meer bestaat. `KNOWN_ISSUES.md` (repo-root, 09-09-2026) stelt dat élke model-aanrakende route kan crashen omdat de handlers niet op de Revit API-thread draaien, en raadt nieuwe read-routes in de huidige vorm af. De wiki leert precies zo'n route bouwen en kent dat document niet.
- **Tweede punt:** de Lees-MCP (`revit-lezen`, gebouwd 14-09-2026) is inmiddels de leesroute onder twee wiki-artikelen, maar staat zelf nergens in de wiki beschreven.
- **Methode:** kruisverwijzingen en stijlwoorden met een Python-script; code-regelnummers tegen `main.py`, `revit_mcp/` en `tools/`; paden gemeten op de werkplek. URL's niet opnieuw opgehaald (geen `web`).

---

## 1. Tegenstrijdigheden

### 1.1 Wanneer en waarom `execute_code` verdween — vier versies [hoog]

| Bron | Zegt |
|---|---|
| `wiki/mcp-revit-koppeling.md` §4 (r. 200-208), `memory.md` regel 2026-08-31 | route, registratie in `startup.py` én `tools/code_execution_tools.py` verwijderd op 31-08-2026; oorzaak: `exec()` zonder sandbox gaf een access violation |
| `KNOWN_ISSUES.md` r. 3, 13, 61-66 | route crashte op 28-08-2026 en ging toen uit `startup.py`; de twee bestanden pas op 09-09-2026 verwijderd; de MCP-tool stond tot dan nog geregistreerd en gaf 404 |
| `../CLAUDE.md` afwijkingentabel | 2026-09-07 |
| `outputs/2026-09-07-mcp-server-herstel.md` | MCP-handshake gaf op 09-07 nog **20** tools |
| `wiki/rebar-api-parameters.md` §0 | op 28-08-2026 draaide `/execute_code/` nog, met `Enum.IsDefined` |

De oorzaak verschilt ook: de wiki legt het bij `exec()` zonder sandbox, `KNOWN_ISSUES.md` bij thread-onveiligheid die álle model-routes treft (ook de read-only `/selection_info/` crashte). **Voorstel:** `KNOWN_ISSUES.md` volgen, want het is nieuwer (09-09, met tegenmeting) en verklaart de crash van een read-only route, wat de wiki-uitleg niet kan. Datering: route uit `startup.py` in de week van 28-08 (exacte dag onzeker, want 28-08 draaide hij nog), toolbestanden weg op 09-09. In §4 en `memory.md` expliciet maken dat "31-08" de datum van het besluit is, niet van de verwijdering van de bestanden.

### 1.2 Een eigen route bouwen versus "geen nieuwe read-routes" [hoog]

`wiki/mcp-eigen-tools-toevoegen.md` §1 geeft een recept voor een GET-route die `uidoc.Selection` leest vanaf de Routes-handler. `KNOWN_ISSUES.md` §Aanbeveling: "Ook geen nieuwe read-routes toevoegen in de huidige vorm", en `/selection_info/` (vrijwel dezelfde route) geeft sinds 09-09 meteen 501. **Voorstel:** conflictblok bovenaan §1 met de ExternalEvent-voorwaarde; de Lees-MCP (TcpListener + ExternalEvent) als werkend tegenvoorbeeld noemen.

### 1.3 Waar de extensie vandaan laadt [middel]

`mcp-revit-koppeling.md` §5 punt 5 en 6, en `mcp-eigen-tools-toevoegen.md` §3, zeggen: de Documents-map heeft geen `main.py` of `.venv`; `%APPDATA%\pyRevit\Extensions\mcp-server-for-revit-python.extension` is een losse kopie die je handmatig bijwerkt. Gemeten op 2026-09-17:

- `%APPDATA%\...\mcp-server-for-revit-python.extension` is een **junction** naar `C:\Users\S-WOU1A\Documents\GitHub\mcp-server-for-revit-python`.
- Die map is sinds de merge van 09-09 een volledige clone (`main.py`, `pyproject.toml`, `uv.lock`, remotes `origin` + `upstream`).
- `.mcp.json` start met `uv run --directory ${REVIT_MCP_HOME:-...\Documents\...}` (commit `d3ca260`), niet met de venv-Python uit de OneDrive-clone.

Een wijziging in `revit_mcp/` komt dus wél direct in Revit aan (na reload of herstart). Het faalpunt "bewerking in de verkeerde kopie" is omgekeerd: de OneDrive-clone is nu de kopie die achterloopt. Ook de skill `sci-bim-context` (`references/template-en-mcp.md` r. 49) zegt nog "de venv-Python roept `main.py` aan" — skill én wiki verouderd, geen onderling conflict.

### 1.4 De "acht verzonnen toolnamen" zijn Nonica's namen [middel]

`mcp-revit-koppeling.md` §6 (r. 355-357): "[ONBEVESTIGD] Welke van de twee is niet uitgezocht" — horen de acht namen bij een andere server of een oude versie. In deze sessie biedt de connector `Revit` (de Nonica-connector) exact die namen aan: `get_active_view_in_revit`, `get_all_workset_information`, `get_all_warnings_in_the_model`, `get_all_used_families_in_model`, `get_all_project_units`, `get_category_by_keyword`, `get_elements_by_category`, `get_parameter_value_for_element_ids`. De Lees-MCP neemt ze grotendeels over. **Voorstel:** markering vervangen door die vaststelling (bron: toollijst van de MCP-connectors, 2026-09-17). Het oordeel "verzonnen" in `memory.md` en `index.md` is daarmee te hard: de skill beschreef de verkeerde server, geen niet-bestaande.

### 1.5 Draait SCI Revit 2027? [middel]

`mcp-versus-custom-tools.md` §4 (r. 139-143): de 2027-server valt op "een Revit-versie die SCI grotendeels nog niet draait", en welke versies in productie draaien is [ONBEVESTIGD]. `ifc-import-verboden-tekens-in-namen.md` §4 meet op 2026-09-16 in projectmodel `S-9497_R27` (Revit 2027). `modeless-venster-persistente-engine.md` meet `S9475_R25`. **Voorstel:** §4 bijwerken — 2025 en 2027 staan aantoonbaar in productie; de open vraag in `index.md` versmallen tot 2024 en 2026.

### 1.6 `kennisbank/CLAUDE.md` §3: "tien" skills, tabel toont er zeven [laag]

De tabel en `memory.md` (2026-08-31: "alle zeven skills") tellen zeven. **Voorstel:** "tien" → "zeven". Dit is `CLAUDE.md`, geen wiki; wijziging vraagt een opdracht.

### 1.7 `ai-brain-kennisorganisatie-pyrevit.md` §5: "acht genummerde secties" [laag]

`CLAUDE.md` heeft er negen (§9 De herinnering). De zin is gedateerd (2026-08-31); was het toen ook al negen, dan is het een telfout. **Voorstel:** "acht" → "negen", of de telling weglaten.

### 1.8 `index.md`: "Alle veertien artikelen staan op concept" [laag]

Het zijn er 19, allemaal nog `concept`. Binnen de check zelf te herstellen (zie §9); gedaan.

### 1.9 Bounding box in `externe-patronen-revit-repos.md` §2 versus de memory [laag]

Het artikel (r. 122-123) verwijst naar `solid-boundingbox-transform` met "een bbox staat in het assenstelsel van het element". Die memory zegt: in het assenstelsel van de **solid**, en gaat over `Solid.GetBoundingBox`. Het patroon zelf gebruikt `Element.get_BoundingBox`, dat een ander gedrag heeft. **Voorstel:** de verwijzing aanpassen of schrappen; de valkuil hoort bij solids, niet bij deze dubbeldetectie.

### 1.10 Tussen wiki en skills

Gecontroleerd: `sci-bim-context/references/template-en-mcp.md` §C, `technische-issues.md` §A, `SKILL.md`; `pyrevit-codestijl` op persistent/modeless. Geen nieuwe tegenspraak tussen wiki en skill. Wel lopen beide gelijk achter op 1.1 en 1.3, en de skill (laatst gewijzigd `cb0a05c`, 2026-08-31) kent `KNOWN_ISSUES.md` ook niet. `pyrevit-codestijl` zegt niets over modeless vensters; `modeless-venster-persistente-engine.md` vult een gat, spreekt niets tegen.

---

## 2. Claims zonder bron

| Bestand:regel | Claim | Voorstel |
|---|---|---|
| `bluebeam-sets-revisies-automatisch.md:65` | "Dat vraagt eXtreme of Max, niet Complete." | [ONBEVESTIGD]. "eXtreme" is de naam uit Revu 20; bij Revu 21 heten de abonnementen anders. De foutmelding noemt geen niveau. |
| `bluebeam-sets-revisies-automatisch.md:67-69` | Revu koppelt een nieuwe pagina alleen aan een revisie als hij al een bladnummer heeft, "en dat komt uit AutoMark" | bron toevoegen (Revu-help of waarneming) of markeren |
| `ifc-export-staalgewicht.md:125-126` | "de gangbare waarde voor constructiestaal is 7850 kg/m³" | NEN-EN 1991-1-1 als bron noemen |
| `ifc-import-verboden-tekens-in-namen.md:113` | "Of importeer in Revit 2025 en upgrade de resulterende RVT." | [ONBEVESTIGD]: niet getest, de gebruiker vond een RVT |
| `modeless-venster-persistente-engine.md:118-122` | reload laat Revit vastlopen bij een levende persistente engine | bron ontbreekt in de frontmatter; waarneming staat in de memory `persistente-engine-reload-hang` |
| `modeless-venster-persistente-engine.md:137-138` | `API_ERROR … Assembly version conflict` staat "op elke werkplek" | beperken tot de ingeziene journaals, of markeren |
| `mcp-revit-koppeling.md:219-220` | "de tool die het model kon slopen" | nuanceren met 1.1: ook read-only routes crashen |

**Bronnen die niet meer kloppen:**

- `mcp-revit-koppeling.md` §1 r. 58 en §4 r. 211-258 verwijzen naar `revit_mcp/code_execution.py` met regelnummers. Het bestand bestaat niet meer. §4 is als historisch gemarkeerd, maar §1 gebruikt `code_execution.py:11` nog als bewijs dat de Revit-kant Python 2 draait. Nieuw bewijs nodig (bv. `print`-statement of `except X, e` elders, of `startup.py`).
- Regelnummers in `main.py` zijn verschoven (gemeten 2026-09-17): `REVIT_HOST`/`REVIT_PORT` staan op **22-23** (wiki: 24-25), `BASE_URL` op **24** (wiki: 26), timeout 60 s op **40** (wiki: 42), 30 s op **57** (wiki: 59), de timeouttekst op **70** (wiki: 72), `transport = "stdio"` op **113** (wiki: 115/127). Ook `../CLAUDE.md` noemt `main.py:21-25`.
- `revit_mcp/status.py:15` → de route staat op **16**. `revit_mcp/views.py:378` is nu `/selection_info/`; `current_view_elements` staat op **499**.
- `externe-patronen-revit-repos.md:6`: bron `Downloads/kennisextractie-externe-revit-repos.md` staat niet in `raw/`. Volgens `CLAUDE.md` §2 is het raw-bestand het bewijs; dit bewijs ligt in een Downloads-map. Verder verwijst het artikel zes keer naar memory-slugs als bron (`modelcheck-registry`, `nlrs-code-als-classificatie`, `align-lock-overconstraint`, `autodim-sectie-y-layout`, `revit-api-verifieren-lokaal`, `solid-boundingbox-transform`). Memory staat buiten de kennisbank, en `modelcheck-registry` bestaat niet (de memory heet `modelcheck-tool`).
- De acht URL's in `rebar-api-parameters.md` zijn niet opnieuw opgehaald (geen `web`-argument).

---

## 3. Gaten

1. **`KNOWN_ISSUES.md` staat niet in de kennisbank** [hoog]. Thread-onveiligheid van Routes-handlers, `/selection_info/` op 501, de tegenmeting van 09-09, het advies om via `ExternalEvent` te marshallen. Verwante memories (`nonica-versus-eigen-mcp`, `routes-print-crasht-revit`, `mcp-revit-routes-werkend-krijgen`: routes hangen als Revit niet idle is) evenmin.
2. **De Lees-MCP heeft geen artikel** [hoog]. `revit-lezen` staat in `.mcp.json` (nog ongecommit), wijst naar `W:\...\03_R&D\RnD.extension\mcp_lezen\revit_lezen_server.py`, en is de meetbron onder `ifc-export-staalgewicht.md` en `ifc-import-verboden-tekens-in-namen.md`. De memory `lees-mcp-eigen-koppeling` zegt "nog niet in Revit getest"; de twee artikelen bewijzen het tegendeel.
3. **`/selection_info/` ontbreekt in de endpointtabel** van `mcp-revit-koppeling.md` §4. Route zonder MCP-tool, uitgeschakeld.
4. **`outputs/2026-09-07-mcp-server-herstel.md` is nooit teruggekoppeld.** Vier oorzaken (onoplosbare `requirements.txt`, venv-pad, gewiste `[routes]`-sectie, `default_enabled: False` in `extension.json`) zijn faalpunten die in `mcp-revit-koppeling.md` §5 thuishoren. Terugkoppellus (`CLAUDE.md` §7) is handwerk van de gebruiker.
5. **Open vragen uit `index.md` die inmiddels (deels) beantwoord zijn:**
   - "Blijft de Routes Server aan tussen sessies?" Ja, tenzij de ini wordt herschreven: op 07-09 verdween `[routes]` bij een reset (herstelverslag). Op 2026-09-17 staat `enabled = true`, `host = "127.0.0.1"`.
   - "Draait er ergens pyRevit 6.5.3?" Gemeten: werkplek AWO 6.5.5, S-WUL1N 6.1.0 (`modeless-venster-persistente-engine.md`). 6.5.3 niet aangetroffen; de rest van het team niet gemeten.
   - "Welke Revit-versies in productie?" Zie 1.5.
6. **De 2024-typewijziging van `BuiltInParameter`** staat nog steeds niet in `sci-bim-context/references/technische-issues.md` §A (nagelopen 2026-09-17). Blijft open.
7. **Geen domeinartikel over het SCI-lint zelf** (runmark, toollog, persistente engine, W:-structuur) — terecht, de skills dekken het. Wel ontbreekt een brug: `modeless-venster-persistente-engine.md` noemt `runmark` en `Gebruikslog.csv` zonder `skill: bimtools-logging`.

---

## 4. Veroudering

Geen artikel is ouder dan 90 dagen; het oudste is van 2026-08-26 (22 dagen). Inhoudelijk verschoven ondanks de jonge datum:

| Artikel | Wat verschoof | Ernst |
|---|---|---|
| `mcp-revit-koppeling.md` (2026-08-31) | regelnummers, §5.5/§5.6 paden, `.venv` → `uv`, crash-oorzaak, geen Lees-MCP, geen `/selection_info/` | hoog |
| `mcp-eigen-tools-toevoegen.md` (2026-08-31) | §1 recept botst met `KNOWN_ISSUES.md`; §3 junction | hoog |
| `mcp-versus-custom-tools.md` (2026-08-31) | §4 Revit 2027 in productie | middel |
| `nlrs-en-bim-standaarden.md` | op 2026-09-16 aangevuld (§2 slotalinea, `verwant:`), maar `laatst-bijgewerkt` staat nog op **2026-08-26**; `index.md` neemt die datum over | middel |
| `ai-tools-voor-pyrevit-ontwikkeling.md` §1 | `ox-alpha` gratis per 2026-08-31; per ontwerp tijdelijk, niet opnieuw nagegaan | laag |
| `bluebeam-sets-revisies-automatisch.md` §6 | "door collega's in test", testpakket op `W:\4 - Tijdelijk en verwijderen` — pad en stand verlopen per definitie | laag, datum staat erbij |

`status: concept` blijft liggen: alle 19. Geen enkel artikel is ouder dan een maand, dus nog geen "maanden niet geraakt".

---

## 5. Stijl

| Regel | Waar | Wat |
|---|---|---|
| 6 | `externe-patronen-revit-repos.md:102` | "robuuste element-link" |
| 16 | `externe-patronen-revit-repos.md:321, 346` | koppen `## §2 Openstaande vragen` en `## §3 Repo-register` botsen met de genummerde `## 2.`/`## 3.` erboven; `§2` wijst dubbelzinnig |
| 19 | `externe-patronen-revit-repos.md` | 40+ bold-markeringen, ook voor nadruk ("**exact 2024 en 2027**", "**geen licentiebestand**") |
| `CLAUDE.md` §5 | `externe-patronen-revit-repos.md` (358 r.), `mcp-revit-koppeling.md` (408), `rebar-api-parameters.md` (281), `rebar-3d-modelleren.md` (207) | boven de 200-regelgrens; de eerste twee behandelen elk meerdere onderwerpen (9 patronen; keten + historiek) |
| `CLAUDE.md` §5 | `modeless-venster-persistente-engine.md` | frontmatter mist het veld `verwant:` helemaal |
| 3/11 | `mcp-revit-koppeling.md` §6 | twee opeenvolgende conflictblokken plus twee "Opgelost"-alinea's: 70 regels historiek in een naslagartikel; kandidaat om naar een eigen sectie "Geschiedenis" te verhuizen |

Regel 9 (em-dashes) gaf tien treffers, allemaal tabelcellen met `—` als lege waarde: geen overtreding. `outputs/`: geen treffers op regel 6 of 7.

---

## 6. Kapotte kruisverwijzingen

Script uit `/kb-check`, aangevuld met tekstverwijzingen.

| Soort | Waar | Voorstel |
|---|---|---|
| Eenzijdig | `externe-patronen-revit-repos.md` → `rebar-api-parameters.md` | terugverwijzing bij `rebar-api-parameters.md` §6 (DoesBarExistAtPosition 2024/2027 geverifieerd) |
| Eenzijdig | `externe-patronen-revit-repos.md` → `nlrs-en-bim-standaarden.md` | terugverwijzing bij §1 (NLRS_ModelChecker-checklijst) |
| Eenzijdig | `externe-patronen-revit-repos.md` → `mcp-eigen-tools-toevoegen.md` | tekstuele grond ontbreekt in `externe-patronen` zelf; link schrappen of onderbouwen |
| Wees | `bluebeam-sets-revisies-automatisch.md` (`verwant: []`) | geen natuurlijke partner in de wiki; aanvaardbaar |
| Wees | `modeless-venster-persistente-engine.md` (geen veld) | `verwant:` toevoegen; kandidaat `externe-patronen-revit-repos.md` §7 (ES-transactie, ProjectNotitie) |
| Wees | `externe-patronen-revit-repos.md` | wordt wees door de drie eenzijdige links; oplossen met de terugverwijzingen hierboven |
| Tekst zonder `verwant:` | `mcp-versus-custom-tools.md` → `rebar-api-parameters.md` (§4), `revit-bronnen-en-communities.md` → `rebar-documentatie-en-staten.md` (§4) | toevoegen aan `verwant:` |

Sectieverwijzingen: `mcp-versus-custom-tools.md` §4 verwijst naar `rebar-api-parameters.md` §4 (bestaat); `externe-patronen` "Zie §2" in patroon 1 en 9 wijst naar de verkeerde §2 (zie §5).

---

## 7. Coverage

| Bronbestand | Stand |
|---|---|
| `2026-08-25 samenvatting-bronnen.md` | ongewijzigd sinds vorige check: volledig |
| `2026-08-25-samenvatting-revit-structure-rebar.md` | volledig |
| `2026-08-25 zelfverbeterende-kennisbank-claude.md` | bewust niet naar wiki (buiten bereik), gelogd |
| `2026-08-27_revit_mcp_bronnen_transcripties.md` | volledig op twee bewuste omissies na |
| `2026-08-31-uitgebreide-transcriptie-…md` | §2-§7 volledig. **§1 gedeeltelijk:** alleen "AI-agents vs. deterministische automatisering" is verwerkt. Niet terug te vinden: *Kwaliteit van de code en modelvoorkeuren* (compacte Markdown-context boven 8.000 woorden), *Ethiek en licenties* (AI negeert licenties — raakt direct de licentiefilter in `externe-patronen-revit-repos.md`), *Toekomst van add-ins* (DiRoots, dat in SCI's tech stack staat), *Forma/APS/Dynamo* (Gavin herschrijft zijn Dynamo-pakket "Pickles" in C# omdat Python in Dynamo onbetrouwbaar is). Jevons-paradox en sponsorblok terecht weggelaten. De vorige check noemde §1 volledig. |
| `2026-09-01-automated-alignment-researchers.md` | **onverwerkt** (de SessionStart-hook meldt het). Onderwerp: AI-alignmentonderzoek, buiten `CLAUDE.md` §1. Voorstel: dezelfde behandeling als de zelfverbeterende-kennisbank-dump — niet naar de wiki, wel een logregel in `memory.md` met de bestandsnaam, zodat de hook zwijgt. |

Omgekeerd: `memory.md` noemt geen raw-bestand dat niet bestaat. Drie recente artikelen (15-09, 16-09, 17-09) en `externe-patronen` (14-09) zijn buiten `raw/` om ontstaan; dat staat eerlijk in `memory.md`.

---

## Actieplan

| # | Actie | Wie |
|---|---|---|
| 1 | Schrijf nieuw artikel `wiki/routes-thread-veiligheid.md` uit `KNOWN_ISSUES.md` (thread-onveiligheid, tegenmeting 09-09, `/selection_info/` op 501, ExternalEvent als voorwaarde), met verwant naar `mcp-revit-koppeling.md` en `mcp-eigen-tools-toevoegen.md` | Claude |
| 2 | Zet in `mcp-eigen-tools-toevoegen.md` §1 een conflictblok: geen nieuwe route zonder marshalling naar de API-thread (bron `KNOWN_ISSUES.md`) | Claude |
| 3 | Herschrijf `mcp-revit-koppeling.md` §5 punt 5 en 6 naar de gemeten stand van 2026-09-17: junction `%APPDATA%` → Documents-clone, `.mcp.json` met `uv run --directory`; voeg de vier oorzaken uit het herstelverslag van 09-07 toe als faalpunten | Claude, na terugkoppeling van dat verslag naar `raw/` door de gebruiker (of op expliciete opdracht rechtstreeks) |
| 4 | Werk in `mcp-revit-koppeling.md` alle regelnummers in `main.py`, `status.py` en `views.py` bij naar de metingen in §2 van dit rapport, voeg `/selection_info/` toe aan de §4-tabel, en vervang in §1 het bewijs uit `code_execution.py:11` | Claude |
| 5 | Corrigeer de verwijderdatum van `execute_code` in `mcp-revit-koppeling.md` §4, `mcp-eigen-tools-toevoegen.md` r. 25-26 en een correctieregel in `memory.md`: route uit `startup.py` eind augustus, bestanden weg op 09-09-2026 | Claude |
| 6 | Vervang in `mcp-revit-koppeling.md` §6 de [ONBEVESTIGD]-regel door: de acht namen zijn de toolnamen van de Nonica-connector | Claude |
| 7 | Schrijf een artikel over de Lees-MCP (`revit_lezen_server.py`, TcpListener + ExternalEvent, sessiekeuze, mm-eenheden) | Claude kan het skelet uit de code op W: halen; werking en testgeschiedenis vragen de gebruiker |
| 8 | Log `2026-09-01-automated-alignment-researchers.md` in `memory.md` als bewust niet verwerkt (buiten bereik) | Claude, na akkoord |
| 9 | Werk `mcp-versus-custom-tools.md` §4 bij: Revit 2025 en 2027 in productie (S-9475_R25, S-9497_R27) | Claude |
| 10 | Zet `laatst-bijgewerkt` van `nlrs-en-bim-standaarden.md` op 2026-09-16 en voeg de ifc-import-bron toe | Claude |
| 11 | Repareer de kruisverwijzingen uit §6 (twee terugverwijzingen, één link schrappen, `verwant:` in `modeless-venster-persistente-engine.md`, twee tekstlinks opnemen) | Claude |
| 12 | Markeer de zeven claims uit §2 als [ONBEVESTIGD] of voorzie ze van een bron; controleer bij de Bluebeam-claim de abonnementsnaam van Revu 21 | Claude; de Revu-abonnementsnaam desnoods de gebruiker |
| 13 | Verwerk de vier overgeslagen deelsecties van §1 van de 2026-08-31-bron (licenties bij `externe-patronen`, Pickles/Dynamo bij `revit-bronnen-en-communities`) | Claude |
| 14 | Stijl in `externe-patronen-revit-repos.md`: "robuuste" weg, koppen `§2`/`§3` hernoemen tot "Openstaande vragen"/"Repo-register", bold terugbrengen; bron uit Downloads naar `raw/` kopiëren | Claude; kopiëren naar `raw/` is handwerk van de gebruiker |
| 15 | `kennisbank/CLAUDE.md` §3 "tien" → "zeven"; `ai-brain-kennisorganisatie-pyrevit.md` §5 "acht" → "negen" | Claude, op opdracht |
| 16 | Bijwerken van de memories `lees-mcp-eigen-koppeling` ("nog niet getest" klopt niet meer) en `execute-code-crasht-revit` (datum) | Claude |
| 17 | Skill `sci-bim-context` `references/template-en-mcp.md` r. 49 ("venv-Python") bijwerken en uploaden | Claude wijzigt de bron; upload is handwerk van de gebruiker |
| 18 | Beslissen of de OneDrive-clone nog nodig is nu de Documents-map een volledige clone is | gebruiker |
