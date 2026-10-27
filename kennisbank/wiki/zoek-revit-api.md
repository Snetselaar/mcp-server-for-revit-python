---
titel: zoek_revit_api — Revit API-signaturen opzoeken via de MCP
status: concept
laatst-bijgewerkt: 2026-10-08
bronnen:
  - "bouwplan 'zoek_revit_api in de MCP' (Albert, 07-10-2026): https://claude.ai/artifact/9BwUNs2mYjKRq7LZ2jL3eX, met de tab 'Rapport fase 0 en 1'"
  - "W:\\4 - Tijdelijk en verwijderen\\AWO\\Extensions\\03_R&D\\RnD.extension\\mcp_lezen\\api_opzoeken.py (versie 1.0, 08-10-2026)"
  - "hetzelfde pad, mcp_lezen\\revit_lezen_server.py (versie 2.4, 08-10-2026), functies zoek_revit_api en _standaard_versie"
  - "hetzelfde pad, tools\\ApiSnapshot.cs en tools\\api_snapshot.ps1 (08-10-2026)"
  - "hetzelfde pad, Tools.panel\\Lees_MCP.pushbutton\\script.py (knop 2.4): _maak_luisterlus en _behandel_client, gelezen 08-10-2026"
  - "tests: tools\\test_zoek_revit_api.py 38/38 en tools\\test_mcp_server_nep_revit.py 61/61, gedraaid 08-10-2026"
  - "metingen op de werkplek, 08-10-2026: RevitAPI.dll 24.3.60.12, 25.4.60.9, 26.5.0.55, 27.2.0.39"
  - "Snetselaar_BIM commits 77ebdaa (server), 1752216 (CLAUDE.md), de285bd (skills)"
verwant:
  - lees-mcp-koppeling.md
  - peil-0-en-hoogtes-meten.md
  - model-vergelijken-fase0-ifc-rvt-link.md
  - externe-patronen-revit-repos.md
  - revit-2027-runtime-en-api-wijzigingen.md
skill: revit-api-docs
---

# zoek_revit_api

`zoek_revit_api` is een tool van de MCP-server `revit-lezen` (server 2.4, sinds
08-10-2026). De tool geeft signaturen, Obsolete-meldingen en IronPython-hints van
de publieke Revit API, per versie en build. Hij leest momentopnames van de
geïnstalleerde `RevitAPI.dll` en `RevitAPIUI.dll` en raakt Revit niet. Revit hoeft
dus niet te draaien en de MCP-knop mag op Uit staan.

Het idee komt uit de agent-runtime van pyRevit 7.0 (`lookup_revit_api`, uitgebracht
6 oktober 2026). Alleen het idee is overgenomen, niet de code. De tool hangt niet
af van pyRevit 7.0 (bouwplan §0).

## 1. Waarom buiten Revit (route C)

Het bouwplan ging uit van reflectie binnen Revit, op de luisterthread van de
MCP-knop (optie A). Fase 0 vond twee redenen om dat niet te doen:

- **De luisterthread is serieel.** `_maak_luisterlus` roept `_behandel_client`
  synchroon aan, en die wacht in `WaitOne` tot een modeltool klaar is (tot 300 s).
  Een opzoeking op die thread wacht dus op elke modeltool die vóór hem
  binnenkwam. Omgekeerd houdt een zware opzoeking de modeltools vast. Zie
  `lees-mcp-koppeling.md` §10.
- **Offline is snel genoeg.** `System.Reflection.Metadata` zit in PowerShell 7 zelf.
  Een volledige dump van vier versies duurde 8,4 s. Ook de tekst van het
  `[Obsolete]`-attribuut is uit de metadata te lezen.

Albert koos op 08-10-2026 voor route C. Fase 2 van het bouwplan
(`vergelijk_revit_api`) is geschrapt, want `versie="2024,2027"` geeft het
verschil per versie al.

## 2. Opbouw

Alle paden onder `W:\4 - Tijdelijk en verwijderen\AWO\Extensions\03_R&D\RnD.extension`.

| Bestand | Rol |
|---|---|
| `tools\ApiSnapshot.cs` | leest de twee DLL's met `MetadataReader`; laadt niets en roept niets aan |
| `tools\api_snapshot.ps1` | schrijft per versie `revit_api_<jaar>_<build>.json.gz`; standaard alle versies vanaf 2024 |
| `mcp_lezen\api_snapshots\` | de momentopnames: ~300 KB per versie, 2.581 (2024) tot 2.713 (2027) types, 0 onleesbaar |
| `mcp_lezen\api_opzoeken.py` | de drie modi; alleen standaardbibliotheek, los te testen |
| `mcp_lezen\revit_lezen_server.py` | de tool zelf, roept `api_opzoeken` aan via `asyncio.to_thread` |

De build komt uit de bestandsversie van `RevitAPI.dll`. Ontbreekt de momentopname
van de geïnstalleerde build, bijvoorbeeld na een Revit-update, dan maakt de server
hem zelf. Gemeten: 0,9 s. Oude momentopnames blijven staan. Voor een jaar dat niet
geïnstalleerd is, pakt de server de nieuwste momentopname van dat jaar.

## 3. Gebruik

| Parameter | Standaard | Betekenis |
|---|---|---|
| `naam` | verplicht | `Wall`, `Autodesk.Revit.DB.Wall`, `Creation.Document`, of `Type.Lid` (`ElementId.Value`); bij de zoekmodi een zoekterm |
| `modus` | `details` | `details`, `zoek_type` of `zoek_lid` |
| `lid` | leeg | filter op lid- of enumnaam, deel mag; doorzoekt ook geërfde leden |
| `geerfd` | `false` | zonder filter ook de geërfde leden tonen |
| `max` | 100 | regels per categorie, hooguit 300 |
| `versie` | leeg | leeg = versie van de actieve MCP-sessie, anders de nieuwste geïnstalleerde; `2025`, `2024,2027` of `alle` |

De standaardversie komt uit de sessiebestanden in `%LOCALAPPDATA%\SCI_RevitLeesMCP`,
zonder ping. Een ping zou op een bezette luisterthread wachten.

Elk lid staat op één regel. Voorbeelden uit 2025:

```text
ElementId(Int32 id) [OBSOLETE: This constructor is deprecated in Revit 2024 ...]
IntegerValue: Int32 {lezen} [OBSOLETE: This property is deprecated in Revit 2024 ...]
TryParse(String idStr, out ElementId id) -> Boolean [statisch]
```

Daarnaast geeft `details` de import-regel en de basistypes. Ook de aanmaakroutes
staan erbij: statische methodes die het type teruggeven, en methodes van
`doc.Create`, `doc.FamilyCreate` en `app.Create`. Per out-parameter volgt een
IronPython-hint ("laat out ElementId id weg; je krijgt een tuple"). Per
ref-parameter staat erbij dat `clr.Reference[T]()` nodig is. Een onbekende naam
geeft status `niet_gevonden` met suggesties. Het antwoord blijft onder 40.000
tekens; daarboven wordt het afgekapt, met tellingen en de hint om `lid` te
gebruiken.

## 4. Wat het bewijst en wat niet

Een uitkomst bewijst dat een lid met die signatuur in de DLL staat, voor de build
in het veld `revit`. Gedrag bewijst hij niet: of een methode een transactie vraagt
of iets ongedaan maakt, staat niet in de metadata. Daarvoor blijft de skill
`revit-api-docs`. Zo staat het sinds 08-10-2026 ook in regel 3 van die skill.

De tool leest het bestand op schijf, niet de assembly die in een draaiend Revit
geladen is. Dat is hetzelfde bestand. Alleen na een Revit-update terwijl Revit
openstaat lopen ze uiteen; de tool geeft dan al de nieuwe build.

[ONBEVESTIGD] Of reflectie op metadata alle leden ziet die IronPython in Revit
ziet. Extension methods en leden die pas bij het laden worden toegevoegd zijn niet
getoetst. De 15 acceptatietests van het bouwplan raakten zo'n geval niet.

## 5. Gevonden verschillen 2024–2027

Gemeten op 08-10-2026, builds 24.3.60.12 / 25.4.60.9 / 26.5.0.55 / 27.2.0.39.

| Lid | 2024 | 2025 | 2026 | 2027 |
|---|---|---|---|---|
| `ElementId.Value` | aanwezig | aanwezig | aanwezig | aanwezig |
| `ElementId.IntegerValue` | obsolete | obsolete | ontbreekt | ontbreekt |
| ctor `ElementId(Int32)` | obsolete | obsolete | ontbreekt | ontbreekt |
| `Curve.Intersect(Curve)` en `(Curve, out IntersectionResultArray)` | aanwezig | aanwezig | obsolete | ontbreekt |
| `Curve.Intersect(Curve, CurveIntersectResultOption)` | ontbreekt | ontbreekt | aanwezig | aanwezig |

De `ElementId`-rijen komen overeen met `pyrevit-codestijl` §5. Daar staat
"aanwezig" waar de tool "obsolete" meldt; dat is geen tegenspraak, want het
attribuut stond in die tabel niet. Code die op 2024 t/m 2027 `Curve.Intersect`
gebruikt, moet op versie vertakken: de nieuwe overload bestaat niet in 2024/2025.
Bijgeschreven in `sci-bim-context`, `technische-issues.md` §A.4.

Op 27-10-2026 kwam er een rij bij uit dezelfde momentopnames:
`Creation.Document.New*BoundaryConditions` is in 2027 deprecated, met
`BoundaryConditions.Create*BoundaryConditions` als nieuwe static methodes die alleen
in 2027 bestaan. Uitgewerkt in `revit-2027-runtime-en-api-wijzigingen.md` §3. Dat
was een claim uit een zoekronde die hier binnen een minuut te toetsen was, en te
sterk bleek ("vervangen" in plaats van deprecated).

## 6. Verificatie

- `tools\test_zoek_revit_api.py`: 38 toetsen, alle groen. Daarin de
  acceptatietests 1–8, 12 en 15 van het bouwplan, en de verwachte tabel uit §5.
  200 opzoekingen kostten 2,6 s.
- `tools\test_mcp_server_nep_revit.py`: 61 toetsen, alle groen. De tool is
  geregistreerd, de standaardversie volgt de MCP-sessie, en er gaat **geen**
  verzoek naar Revit.
- Acceptatietests 9–11 en 13 vervielen met route C. Ze gingen over het
  Revit-proces (open model, Revit bezet, geheugen, reload).

## 7. Aandachtspunten

- De tool verschijnt pas in een Claude-sessie die de MCP-server opnieuw start.
  Dat kan met een nieuwe sessie of met reconnect in `/mcp`.
- De regel "API-namen eerst opzoeken met `zoek_revit_api`" staat sinds
  08-10-2026 in `RnD.extension\CLAUDE.md` en in `pyrevit-codestijl` §9 punt 11.
- Is de tool niet beschikbaar, dan doen `tools\check_api.ps1` (losse leden) en
  `tools\api_diff.ps1` (volledige diff) hetzelfde vanaf de opdrachtregel.
- Een bijvangst van de bouw: `test_mcp_server_nep_revit.py` faalde al sinds
  server 2.3. De pid-filter sloeg de nep-sessie met een verzonnen pid over. Nu
  gebruikt de test de pid van het testproces zelf.
