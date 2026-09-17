---
titel: De Lees-MCP — eigen alleen-lezen koppeling tussen Claude en Revit
status: concept
laatst-bijgewerkt: 2026-09-17
bronnen:
  - "W:\\4 - Tijdelijk en verwijderen\\AWO\\Extensions\\03_R&D\\RnD.extension\\03_R&D.tab\\Tools.panel\\Lees_MCP.pushbutton\\script.py (versie 1.2, docstring en r. 124-137, 1471-1625)"
  - "hetzelfde pad, bundle.yaml (tooltip, engine: persistent: true)"
  - "W:\\4 - Tijdelijk en verwijderen\\AWO\\Extensions\\03_R&D\\RnD.extension\\mcp_lezen\\revit_lezen_server.py (versie 1.0)"
  - ".mcp.json (deze repo), server revit-lezen, gelezen 2026-09-17"
  - "waargenomen: gebruikt als meetroute in S-9479_R25 (2026-09-15) en S-9497_R27 (2026-09-16)"
verwant:
  - routes-thread-veiligheid.md
  - mcp-revit-koppeling.md
  - ifc-export-staalgewicht.md
  - ifc-import-verboden-tekens-in-namen.md
  - modeless-venster-persistente-engine.md
  - mcp-versus-custom-tools.md
  - rebar-api-parameters.md
  - mcp-eigen-tools-toevoegen.md
skill: sci-bim-context
---

# De Lees-MCP

Een eigen MCP-koppeling waarmee Claude een open Revit-model **alleen leest**.
Gebouwd op 14-09-2026 als vervanger van de Nonica-connector, die een daglimiet
heeft, en als uitweg uit de instabiele pyRevit Routes-server
(`routes-thread-veiligheid.md`). Stand 2026-09-17: knop in 03_R&D, versie 1.2.

## 1. Twee helften

| Helft | Waar | Draait op |
|---|---|---|
| Knop **Lees MCP** | `03_R&D.tab\Tools.panel\Lees_MCP.pushbutton` | IronPython 2.7 in Revit, persistente engine |
| MCP-server `revit-lezen` | `RnD.extension\mcp_lezen\revit_lezen_server.py` | CPython ≥ 3.11 via `uv run --script` (inline dependency `mcp>=1.23,<2`), stdio |

`.mcp.json` in deze repo start de server met
`uv run --script "W:\...\mcp_lezen\revit_lezen_server.py"` (gelezen 2026-09-17,
nog niet gecommit).

Anders dan bij `mcp-revit-koppeling.md` zit er **geen pyRevit Routes en geen
HTTP** tussen (docstring van de server, r. 18).

## 2. Werking

Uit de docstring van de knop:

1. Klikken zet een .NET `TcpListener` aan op `127.0.0.1`, eerste vrije poort in
   de reeks **48950-48969**, op één achtergrondthread. Die thread raakt de
   Revit API nooit aan, print niet en logt niet, en vangt elke exception af.
2. Een verzoek is één regel JSON. De thread zet het in een wachtrij, roept
   `ExternalEvent.Raise()` aan en wacht met `ManualResetEvent.WaitOne` op een
   time-out (`script.py:1605-1625`).
3. Revit voert de handler pas uit tussen twee commando's: nooit tijdens een
   commando of een modale dialoog. Komt Revit niet op tijd, dan krijgt Claude
   een foutmelding en wordt het verzoek als `verlopen` gemarkeerd en later
   overgeslagen.
4. Er wordt nergens een `Transaction` geopend.

Dit is het `ExternalEvent`-patroon dat `KNOWN_ISSUES.md` voorschrijft voor
model-aanrakende routes (`routes-thread-veiligheid.md` §5). Wie een eigen tool wil
toevoegen, doet dat hier veiliger dan met het route-recept in
`mcp-eigen-tools-toevoegen.md`: een `t_<naam>`-functie in de knop, een regel in de tabel
`TOOLS` (`script.py:1423`) en een `@mcp.tool` in de server.

## 3. Sessies en beveiliging

- Bij het aanzetten schrijft de knop `%LOCALAPPDATA%\SCI_RevitLeesMCP\sessie_<pid>.json`
  met poort en sleutel. Elk verzoek moet die sleutel meesturen. Het bestand is
  alleen leesbaar voor het eigen Windows-account, dus een webpagina kan de poort
  niet misbruiken.
- De server leest alle sessiebestanden, pingt elke sessie en gebruikt alleen de
  levende (`revit_lezen_server.py:101-133`).
- Staan er meerdere Revit-sessies aan, dan weigert elke tool tot er een gekozen
  is met `kies_revit_sessie`. `lijst_revit_sessies` toont pid, Revit-versie en
  document.
- Na een Revit-herstart staat de koppeling uit. Aan → uit → aan geeft een nieuwe
  poort en een nieuwe sleutel (docstring knop).

## 4. De tools

40 tools (`@mcp.tool` in `revit_lezen_server.py`, geteld 2026-09-17). Twee voor
sessiebeheer, `get_status`, en 37 leestools. De namen volgen grotendeels die van
de Nonica-connector (`get_all_workset_information`, `get_all_warnings_in_the_model`,
`get_parameter_value_for_element_ids` enzovoort), met eigen aanvullingen zoals
`get_element_summaries` en `get_revit_links`.

Afspraken die de server aan Claude meegeeft (`revit_lezen_server.py:36-45`):
lengtes en coördinaten in **millimeters** ten opzichte van de projectinterne
oorsprong, element-id's als gehele getallen, en bij een time-out de gebruiker
vragen de dialoog of het commando af te ronden in plaats van in een lus opnieuw
te proberen.

Time-outs: 30 s standaard, 120 s voor zware tools aan de serverkant; aan de
Revit-kant maximaal 300 s. Per aanroep maximaal 1.000 id's, lijsten afgekapt op
20.000 (`script.py:124-133`, `revit_lezen_server.py:32-33`).

## 5. Versiegeschiedenis en opgeloste fouten

| Versie | Datum | Wat |
|---|---|---|
| 1.0 | 14-09-2026 | eerste versie |
| 1.1 | 14-09-2026 | eerste echte run op `S-9464`, Revit 2025: elk verzoek faalde op `4138977L is not JSON serializable` — een `System.Int64` uit `ElementId.Value`. Nu `int()` plus een json-terugval |
| 1.2 | 14-09-2026 | `'unknown' codec can't decode byte 0xb2` bij het teken ² in een weergavewaarde. IronPython-`json` met `ensure_ascii=True` decodeert tekst ≥ 0x80 als UTF-8; nu `ensure_ascii=False` |

Beide fouten zijn IronPython 2.7-eigenaardigheden en horen bij de valkuilen uit
de skill `pyrevit-codestijl`.

Compatibiliteit volgens de docstring: Revit 2024 t/m 2027, met
`ElementId.Value` en een `IntegerValue`-terugval; alle API-leden op 14-09-2026
via reflectie tegen de vier `RevitAPI.dll`'s gecontroleerd.

## 6. Waar hij sindsdien op gemeten heeft

- `S-9479_R25` (Revit 2025), 2026-09-15: staalgewicht en exportparameters, zie
  `ifc-export-staalgewicht.md`.
- `S-9497_R27` (Revit 2027), 2026-09-16: Project Information, zie
  `ifc-import-verboden-tekens-in-namen.md`.

Daarmee draait hij aantoonbaar op 2025 en 2027.

## 7. Aandachtspunten

- **Persistente engine is vereist** (`bundle.yaml`), anders sterft de engine
  achter de luisterthread. De toestand staat in AppDomain-data, omdat pyRevit
  elke run een verse scope geeft. Na een pyRevit-reload bouwt de volgende klik de
  luisteraar opnieuw op (docstring knop). Zie voor het versierisico van die vlag
  `modeless-venster-persistente-engine.md`.
- [ONBEVESTIGD] Of de koppeling op pyRevit 6.1.0 werkt, waar de
  persistent-vlag niet in de gecompileerde knop aankwam. Niet getest.
- Alleen lezen is een ontwerpkeuze, geen beperking van het patroon. Schrijven
  zou dezelfde wachtrij plus een `Transaction` in de handler vragen.
- Staat in 03_R&D, dus alleen voor de beperkte doelgroep.
- Werkt op 2025 én 2027, en is daarmee een versie-onafhankelijk alternatief voor
  de Autodesk MCP-server, die pas vanaf 2027 draait
  (`mcp-versus-custom-tools.md` §4).
- Geen willekeurige code, dus geen `Enum.IsDefined`-toets zoals die op
  2026-08-28 via `/execute_code/` liep (`rebar-api-parameters.md` §0).
