# Externe bronnen: Revit, IFC, SCIA, Tekla (stand 21-27 okt 2026)

Bedoeld voor Claude Code. Resultaat van twee zoekrondes (GitHub, daarna forums/YouTube/LinkedIn).
Alles hieronder komt uit zoekresultaten. **Niets is in de repo zelf geverifieerd** (sterren, laatste commit, licentie, werking). Eerst controleren, dan pas overnemen.

## Context

- Gebruiker: Albert, BIM-modelleur/AI engineer bij SCI (Snetselaar). Werktaal Nederlands.
- Harde eis: alles werkt op Revit 2024 t/m 2027, pyRevit, IronPython 2.7 (geen f-strings, geen pathlib, geen pip-packages binnen Revit).
- Nieuwe code gaat naar `03_R&D`, nooit direct naar `01_SCI`. Lees eerst de skills `pyrevit-codestijl`, `sci-bim-context`, `revit-api-docs`, `bimtools-logging`.
- Eerdere GitHub-ronde (13 sept) staat al in `kennisextractie-externe-revit-repos.md`. Afgevinkt als niet de moeite: BIM basis ILS, Revit-Excel-tools, staal-specifieke repos, SCIA-koppeling, model-diff-platforms. Deze lijst niet opnieuw doorzoeken.

## A. Compatibiliteit 2024-2027 (hoogste prioriteit)

### A1. .NET 10
- Revit 2027 draait op .NET 10. Add-ins moeten tegen de .NET 10 SDK gebouwd worden.
- Autodesk plant ook Revit 2025 en 2026 naar .NET 10 te migreren (call for preview testing). Microsoft stopt .NET 8-support op 10 nov 2026.
- Voorbeeld van breuk: AVAIL verliest drag-and-drop zodra de .NET 10-versies van 2025/2026 uitkomen.
- Actie: grep in `01_SCI`, `02_Beta`, `03_R&D` op `clr.`, `AddReference`, eigen DLL's, `System.Windows.Forms`/WPF-gebruik die van .NET-versie afhangt. Rapporteer in een tabel per knop.
- Bronnen: https://blog.autodesk.io/revit-2027-sdk-net-10-api-changes-and-additions/ , https://blog.autodesk.io/tag/net-10/

### A2. Map voor all-users add-ins verplaatst (2027)
- Oud: `C:\ProgramData\Autodesk\Revit\Addins\20XX`, nieuw: `C:\Program Files\Autodesk\Revit\Addins\20XX`. `Application.AllUsersAddinsLocation` verandert mee.
- Actie: zoek hardcoded paden in scripts en installatiedocs. pyRevit 6.4.0 heeft de manifest-fix al; controleer welke pyRevit-versie op de SCI-pc's staat.

### A3. Revit 2027 API: BoundaryConditions
- `Creation.Document.NewPointBoundaryConditions` / `NewLineBoundaryConditions` / `NewAreaBoundaryConditions` zijn vervangen door `BoundaryConditions.CreatePointBoundaryConditions` / `CreateLineBoundaryConditions` / `CreateAreaBoundaryConditions`.
- Actie: grep op `NewPointBoundaryConditions` e.d. Zo ja: versie-switch met `hasattr`, niet op versienummer. Verifieer eerst via skill `revit-api-docs` (rvtdocs.com/2027/whats-new).
- Zelfde pagina noemt ook IFC-API-, Rebar- en Energy-wijzigingen en "Extended Properties" (externe data aan elementen hangen). Doorlezen op relevantie.

### A4. pyRevit-versie
- Laatst geziene releases: 6.4.0 (Revit 2027 manifest-fix), 6.5.0 (Revit 2027-compat), 6.5.3.
- **pyRevit 7.0 niet bevestigd.** De claims uit de Gemini-samenvatting (ingebouwde MCP, WebView2, snellere laadtijd) kon ik niet vinden op de releasepagina. Niet op bouwen zonder bron: https://github.com/pyrevitlabs/pyRevit/releases
- Open discussie (pyRevit issue #2124) over IronPython deprecaten ten gunste van CPython. Geen besluit; alleen volgen.

## B. Tekla (past bij `areas/tekla-truss-dimensioning`)

| Bron | Wat | Opmerking |
|---|---|---|
| github.com/tempalg1n/tekla-mcp-server (v0.7.0) | MCP voor Tekla met Drawing API: object marks, level marks, maatlijnen, views auto-plaatsen, PDF-export, C#-scripting escape hatch | Drawing-laag experimenteel; releases voor Tekla 2021-2026 |
| PyTekla (efdiloreto.github.io/PyTekla) | Pythonic wrapper om Tekla Open API via Python.NET | CPython, dus niet voor IronPython-knoppen |
| Tekla TSOpenAPIExamples, `Drawings/Applications/DimensionCreator` | Vijf soorten maatvoering aanmaken | Officieel voorbeeld, goed als referentie |

Actie: lees hoe `tekla-mcp-server` maatlijnen en marks modelleert (papier-millimeters, stateful drawing). Haal alleen patronen eruit voor de truss-maatvoering.

## C. IFC en IDS (past bij `areas/model-vergelijken`, `areas/sci-datastandaard`)

- **IfcOpenShell `ifcdiff`**: CLI en library, vergelijkt twee IFC's (geometrie, relaties, properties), schrijft JSON-diff, werkt ook tussen IFC-schema's. `python -m ifcdiff old.ifc new.ifc`. Draait onder CPython, niet in Revit. Actie: bepaal of een externe aanroep vanuit de knop kan, of dat alleen het JSON-formaat als referentie dient.
- **IfcTester (IDS)**: valideert IFC tegen IDS, rapporten als console/Html/JSON/BCF. CLI: `python -m ifctester x.ids x.ifc -r Html -o rapport.html`.
- **IDS in Revit zelf** (commercieel, alleen kijken hoe het gedaan is):
  - BIMGuard IDS Inspector: toetst het live Revit-model aan IDS 1.0 zonder IFC-export. Revit 2022-2027, 30 dagen proef. https://marketplace.autodesk.com/apps/586f7e37-09c5-4f1e-bfbd-41c79d63c409
  - BIMcollab BCF Manager voor Revit heeft een IDS-palette (alleen bekijken).
  - LINEAR: Revit ondersteunt IDS niet native en Revit-categorieën passen niet 1-op-1 op IFC-klassen. Gevolg: IDS moet op maat voor Revit.
- Conclusie voor de SCI-datastandaard: één IDS-bestand als bron, toetsen met IfcTester op de export, en parameter-naar-property-mapping expliciet vastleggen.
- **Analytisch model naar IFC**: volgens oudere Autodesk-forumdraden levert de standaard Revit IFC-export geen bruikbaar analytisch model. Houd de eigen JSON-serialisatie aan (zie `AlejoDuarte23/pyrevit-structural-analysis-extension` uit de vorige ronde).

## D. SCIA, Technosoft, rekenmodel (past bij `areas/rekenmodel-controle`; SCIA-integratie staat geparkeerd, alleen oppakken als Albert erom vraagt)

- **SAF (Structural Analysis Format)**: open Excel-gebaseerd formaat van Nemetschek/SCIA. Docs: https://gitbook.saf.guide (er is `llms.txt`), .NET-SDK op NuGet (`StructuralAnalysisFormat`). Idee, niet getest: een xlsx is zonder SCIA uit te lezen, dus bruikbaar als vergelijkingsbron voor profielen en posities.
- **SCIA OpenAPI/ADM met Python**: via pythonnet, levert SAF op. Staat in de SCIA-FAQ, niet op GitHub.
- **SCIA 25 handleiding** "Advanced Training integration with BIM Workflows": hoofdstukken Revit↔SCIA en Tekla↔SCIA. https://downloads.scia.net/support/sciaengineer/manuals/25/MAN%20%5BEng%5D%20SCIA25.0%20-%20Advanced%20Training%20integration%20with%20BIM%20Workflows.pdf
- **Ontwerppatroon van FEM-Design StruXML Revit-add-in**: exporteert analytische members/panels met geometrie, optioneel ID uit een instance-parameter, mappingtabellen voor materiaal en profiel, en een rapportpagina met waarschuwingen. Gebruik als sjabloon voor de vergelijking Revit ↔ rekenmodel (ID-parameter, mapping, rapport).
- **Technosoft**: niets publieks gevonden over de XML-koppeling. Alleen de bestaande interne kennis gebruiken.
- Bentley heeft MCP-servers voor STAAD.Pro en MicroStation. Voor SCIA of Technosoft niets gevonden.

## E. Revit-MCP (past bij `areas/revit-mcp`, `areas/annotatie-autopilot`)

- **Autodesk Revit Public MCP Server**: officieel, technical preview, alleen Revit 2027, aparte add-on, volgens HMK alleen-lezen met 7 tools. Kan naast eigen MCP draaien. Niet bruikbaar als basis door de 2024+-eis. https://www.autodesk.com/blogs/aec/2026/06/17/revit-public-mcp-server/
- **sharafutdinovdi/revit-model-mcp** (v0.3.0): alleen-lezen standaard, Revit 2027-build, MSI-installers. Kijk naar het read-only-patroon en hoe schrijven apart wordt vrijgegeven.
- **Demolinator/revit-mcp-server**: 48 tools via pyRevit Routes, IronPython, 2024-2027, centrale ElementId-helpers. Bekend uit juli; opnieuw bekijken voor de ElementId-helpers.
- **BIM Pure (Nicolas Catellier)**, blog "pyRevit MCP + Claude Code": werkwijze = eerst via MCP verkennen, bruikbare code daarna omzetten in vaste knoppen. Gratis blog: https://www.bimpure.com/blog/pyrevit-mcp-claude-code-tutorial . De masterclass is betaald, niet nodig.
- Andere (vooral marketing, alleen code bekijken): HMK Pilot (commercieel, 340+ acties, chat-paneel), BIMwright `rvt-mcp` (2022-2027, één transactie per actie, zelflerende tools), t3lab (pyRevit-extensie met MCP-functie).
- Vyssuals-patroon uit de Gemini-samenvatting (voorstel indienen, BIM-manager accepteert, dan pas naar Revit schrijven) past bij een veilige schrijf-MCP.
- YouTube (alleen titels gezien, niet bekeken): "TUTORIAL: Connecting Claude Desktop and Revit 2027 with an MCP bridge", "AI in Revit: Claude + MCP pyRevit 100% free".

## F. WebView2 in Revit

- Autodesk-blog: ontwikkelversies van Revit bevatten WebView2 en de evergreen-runtime; oudere versies hadden gedoe met cachemap en herstart. https://blog.autodesk.io/webview2-landxml-refplane-and-revision/
- zahmadsaleem/revit-webview2-demo (2021, C#/WPF, Vue): open bugs "zwart scherm in dockpanel" en fatale fout. Alleen als patroon voor JS↔C#-berichten (`postMessage` / `ExecuteScriptAsync`).
- Actie: vóór elk HTML-paneel (ElementNotities, viewer) testen op 2024, 2025, 2026 en 2027 of WebView2 beschikbaar is.

## Voorgestelde volgorde voor Claude Code

1. A1-A3 uitvoeren als scan (alleen lezen), tabel per knop, resultaat in `03_R&D`-notitie. Niets wijzigen in `01_SCI`.
2. Per bron in B, C, E de repo lezen (kort, alleen de genoemde onderdelen) en maximaal 12 patronen noteren met veld "Helpt bij" (zelfde opzet als `kennisextractie-externe-revit-repos.md`).
3. Open vragen aan Albert terugmelden: pyRevit-versie op de SCI-pc's, of WebView2 op alle vier de Revit-versies beschikbaar is, en of `ifcdiff` extern aangeroepen mag worden.
4. Niet doen: SCIA-koppeling uitwerken, Technosoft zoeken op GitHub, betaalde tools aanschaffen.
