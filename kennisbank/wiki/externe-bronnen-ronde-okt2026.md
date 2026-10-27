---
titel: Externe bronnen, ronde oktober 2026 — Tekla, IFC/IDS, SAF en Revit-MCP's
status: concept
laatst-bijgewerkt: 2026-10-27
bronnen:
  - "raw/2026-10-27-externe-bronnen-revit-ifc-scia-tekla.md §B-§E en 'Voorgestelde volgorde' (zoekrondes 21-27 okt 2026; sterren, licentie, laatste commit en werking niet gecontroleerd)"
  - https://www.autodesk.com/blogs/aec/2026/06/17/revit-public-mcp-server/
  - https://www.bimpure.com/blog/pyrevit-mcp-claude-code-tutorial
  - https://gitbook.saf.guide
  - https://marketplace.autodesk.com/apps/586f7e37-09c5-4f1e-bfbd-41c79d63c409
verwant:
  - externe-repos-kandidaten-en-afgevallen.md
  - externe-patronen-revit-repos.md
  - revit-2027-runtime-en-api-wijzigingen.md
  - mcp-versus-custom-tools.md
  - model-vergelijken-fase0-ifc-rvt-link.md
  - ifc-export-staalgewicht.md
  - ifc-import-verboden-tekens-in-namen.md
  - vyssuals-datavisualisatie.md
  - lees-mcp-koppeling.md
skill: sci-bim-context
---

# Externe bronnen, ronde oktober 2026

Tweede zoekronde na die van 13/14-09-2026 (`externe-patronen-revit-repos.md`,
`externe-repos-kandidaten-en-afgevallen.md`). Deze ronde zocht op GitHub en daarna
op forums, YouTube en LinkedIn. **Niets hieronder is in de repo zelf gelezen**; elke
regel is een zoekresultaat en staat daarom als kandidaat, niet als patroon. Het
compatibiliteitsdeel van dezelfde bron staat apart in
`revit-2027-runtime-en-api-wijzigingen.md`.

De zoekpaden die de eerste ronde al had afgesloten (BIM basis ILS, Revit-Excel-tools,
staal-specifieke repo's, SCIA-koppeling, model-diff-platforms) zijn niet opnieuw
doorzocht.

## 1. Tekla

| Bron | Wat | Helpt bij |
|---|---|---|
| `tempalg1n/tekla-mcp-server` (v0.7.0) | MCP voor Tekla met Drawing API: object marks, level marks, maatlijnen, views plaatsen, PDF-export, C#-escape hatch. Drawing-laag experimenteel; releases voor Tekla 2021-2026 | hoe maatlijnen en marks in papier-mm en een stateful tekening gemodelleerd worden |
| PyTekla (`efdiloreto.github.io/PyTekla`) | Python-wrapper om de Tekla Open API via Python.NET | alleen CPython; niet voor IronPython-knoppen |
| `TSOpenAPIExamples`, `Drawings/Applications/DimensionCreator` | officieel voorbeeld, vijf soorten maatvoering | referentie voor de truss-maatvoering |

`TSOpenAPIExamples` stond al als Prio-2-kandidaat in
`externe-repos-kandidaten-en-afgevallen.md` §2; deze ronde wijst er het concrete
pad in aan. De Tekla-route voor modeldata loopt via IFC-export, niet via het
`.db1`-bestand (memory `tekla-db1-niet-leesbaar`, besluit 15-10-2026).

## 2. IFC en IDS

- **`ifcdiff`** (IfcOpenShell): vergelijkt twee IFC's op geometrie, relaties en
  properties, ook tussen schema's, en schrijft een JSON-diff. CPython,
  `python -m ifcdiff old.ifc new.ifc`. Raakt de knop Model vergelijken
  (`model-vergelijken-fase0-ifc-rvt-link.md`): die vergelijkt nu binnen Revit op
  IfcGUID. Open vraag: externe aanroep vanuit de knop, of alleen het JSON-formaat als
  referentie.
- **IfcTester** (IDS): valideert een IFC tegen een IDS, rapport als console, HTML,
  JSON of BCF. `python -m ifctester x.ids x.ifc -r Html -o rapport.html`. Stond al als
  Prio-3-kandidaat.
- **IDS in Revit zelf**, commercieel, alleen om te zien hoe het gedaan is: BIMGuard
  IDS Inspector (toetst het live model aan IDS 1.0 zonder export, Revit 2022-2027) en
  het IDS-palet van BIMcollab BCF Manager (alleen bekijken).
- [ONBEVESTIGD] Volgens LINEAR ondersteunt Revit IDS niet native, en passen
  Revit-categorieën niet 1-op-1 op IFC-klassen; een IDS moet dus op maat voor Revit.

De bron trekt voor de SCI-datastandaard de conclusie: één IDS-bestand als bron,
toetsen met IfcTester op de export, en de parameter-naar-property-mapping expliciet
vastleggen. Dat sluit aan op twee bestaande gevallen waarin de export slaagt maar de
ontvanger er niets aan heeft: het ontbrekende staalgewicht
(`ifc-export-staalgewicht.md`) en de verboden tekens in Project Information
(`ifc-import-verboden-tekens-in-namen.md`). Een IDS-toets op de export zou beide
vangen, mits de IDS die eisen bevat.

[ONBEVESTIGD] Analytisch model in IFC: oudere Autodesk-forumdraden zeggen dat de
standaard Revit-IFC-export geen bruikbaar analytisch model levert. Dat strookt met
memory `ifc-proxy-wvb-strip-groen` (geen analytisch model in de IFC). Advies van de
bron: de eigen JSON-serialisatie aanhouden, zoals
`AlejoDuarte23/pyrevit-structural-analysis-extension` (Prio-2-kandidaat).

## 3. SCIA, Technosoft en het rekenmodel

SCIA-integratie staat geparkeerd; alleen oppakken als Albert erom vraagt.

- **SAF** (Structural Analysis Format, Nemetschek/SCIA): open formaat op basis van
  Excel; docs op `gitbook.saf.guide` (met `llms.txt`), .NET-SDK `StructuralAnalysisFormat`
  op NuGet. [ONBEVESTIGD] Een SAF-xlsx is zonder SCIA uit te lezen en dus bruikbaar als
  vergelijkingsbron voor profielen en posities.
- **SCIA OpenAPI/ADM** met Python via pythonnet levert SAF op; staat in de SCIA-FAQ.
- **SCIA 25-handleiding** "Advanced Training integration with BIM Workflows" heeft
  hoofdstukken Revit↔SCIA en Tekla↔SCIA (PDF op `downloads.scia.net`).
- **FEM-Design StruXML-add-in** als ontwerppatroon voor Revit ↔ rekenmodel: ID uit
  een instance-parameter, mappingtabellen voor materiaal en profiel, en een
  rapportpagina met waarschuwingen.
- **Technosoft**: niets publieks over de XML-koppeling. Alleen interne kennis
  (de Rekenmodel-viewer, memory `rww-viewer-technosoft`, leest `.rww`/`.grw` al).
- Bentley heeft MCP-servers voor STAAD.Pro en MicroStation; voor SCIA en Technosoft
  niets gevonden.

## 4. Revit-MCP's

| Bron | Wat | Helpt bij |
|---|---|---|
| Autodesk Revit Public MCP Server | officieel, technical preview, alleen 2027; volgens HMK een aparte add-on, alleen-lezen, 7 tools | niet bruikbaar als basis door de 2024+-eis; kan naast een eigen MCP draaien |
| `sharafutdinovdi/revit-model-mcp` (v0.3.0) | standaard alleen-lezen, 2027-build, MSI-installers | hoe schrijven apart wordt vrijgegeven |
| `Demolinator/revit-mcp-server` | 48 tools via pyRevit Routes, IronPython, 2024-2027 | de centrale ElementId-helpers |
| BIM Pure, blog "pyRevit MCP + Claude Code" | eerst via MCP verkennen, bruikbare code daarna in vaste knoppen | werkwijze; de masterclass is betaald en niet nodig |
| HMK Pilot, BIMwright `rvt-mcp`, t3lab | vooral marketing; `rvt-mcp`: 2022-2027, één transaction per actie | alleen code bekijken |

De beschrijving van de Autodesk-server wijkt af van `mcp-versus-custom-tools.md` §4,
dat hem "ingebouwd" noemt met "veel elementen niet bewerkbaar". Beide bronnen
zijn tweedehands; [ONBEVESTIGD] welke klopt tot de Autodesk-blog gelezen is.

Twee patronen sluiten aan op wat er al staat. Het read-only-standaard-met-aparte-
schrijfvrijgave van `revit-model-mcp` is hetzelfde ontwerp als de Lees-MCP
(`lees-mcp-koppeling.md`: schrijven alleen in stand "Lezen en schrijven", altijd
eerst `dry_run`). En het Vyssuals-patroon uit een Gemini-samenvatting (voorstel
indienen, BIM-manager accepteert, dan pas schrijven; zie `vyssuals-datavisualisatie.md`)
is de volgende stap daarop voor een veilige schrijf-MCP.

YouTube, alleen titels gezien: "TUTORIAL: Connecting Claude Desktop and Revit 2027
with an MCP bridge" en "AI in Revit: Claude + MCP pyRevit 100% free".

## 5. Vervolg volgens de bron

1. Scan op .NET 10, add-in-pad en BoundaryConditions (alleen lezen, tabel per knop,
   resultaat als `03_R&D`-notitie). Deels gedaan bij deze verwerking, zie
   `revit-2027-runtime-en-api-wijzigingen.md` §2-§3.
2. Per bron in §1, §2 en §4 de genoemde onderdelen lezen, maximaal twaalf patronen
   met veld "Helpt bij", in de opzet van `externe-patronen-revit-repos.md`.
3. Niet doen: SCIA-koppeling uitwerken, Technosoft op GitHub zoeken, betaalde tools
   aanschaffen.
