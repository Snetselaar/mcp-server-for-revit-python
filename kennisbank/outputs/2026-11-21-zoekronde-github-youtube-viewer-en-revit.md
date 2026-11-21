---
titel: Zoekronde GitHub en YouTube, november 2026 — SCI-Viewer en Revit-workflow
datum: 2026-11-21
vraag: "Zoek GitHub en YouTube af naar relevante dingen voor mijn workflow met Revit en voor de SCI-Viewer (SCIA, Revit, AutoCAD, Technosoft, pyRevit, Tekla, Trimble, BIMcollab, Solibri; HTML, PDF, Bluebeam-achtig). Meld alleen wat relevant is en vat het samen voor Claude Code op maandag."
bronnen:
  - "zoekronde van 2026-11-21 in een cloudsessie; per vondst staat erbij of de README is gelezen of dat het alleen een zoekresultaat is"
  - "getoetst tegen: outputs/2026-11-10-sci-viewer-audit-3.23(-opvolging).md, outputs/2026-11-16-lezers-ronde4-viewer-3.52-3.55.md, wiki/externe-repos-kandidaten-en-afgevallen.md, wiki/externe-bronnen-ronde-okt2026.md"
---

# Zoekronde november 2026

## Hoe dit te lezen

- Uitgangspunt is de viewer zoals vastgelegd t/m 3.55 (16-11). Wat daarna is gebouwd,
  is hier niet meegewogen.
- Wat de rondes van september en oktober al noemden of afschreven, staat er niet
  opnieuw in, behalve waar er iets veranderd is.
- **Geen enkele repo is gekloond of uitgevoerd.** "README gelezen" betekent: de
  GitHub-pagina op 21-11 opgehaald. "Zoekresultaat" betekent: alleen titel en
  samenvatting gezien. Prestatieclaims zijn die van de makers zelf.
- Licentie staat er steeds bij, want de viewer wordt als één bestand verspreid.

## Opdracht voor maandag (plakken in Claude Code)

> Lees `kennisbank/outputs/2026-11-21-zoekronde-github-youtube-viewer-en-revit.md`.
> Werk de punten A1 t/m A4 af in die volgorde. Per punt: eerst de repo lezen
> (licentie vóór inhoud, commit en pad noteren), dan rapporteren wat bruikbaar is
> voor de viewer, en pas na mijn akkoord iets inbouwen. Niets van punt B
> installeren op een werk-pc zonder dat ik het vraag.

## A. Voor de SCI-Viewer

### A1. rvt-rs is van 0.19 naar 0.25.0 gegaan (15-11-2026) — README gelezen
`github.com/DrunkOnJava/rvt-rs`, Apache-2.0. De viewer is getoetst tegen
`rvt-dump` van 0.19. Volgens de README leest 0.25:

- elementen met naam, type, **verdieping**, materiaal en id;
- opgeslagen parameters voor 2023–2027 (experimenteel 2015–2022; ingebouwde
  parameters hebben geen naam);
- gemeten geometrie voor projecten 2023–2025, veel elementen nog als omhullende doos;
- export naar IFC4 (met een bestand dat benaderingen en weglatingen opsomt), glTF,
  plattegrond-SVG en CSV-staten; er is een `rvt-sheet`-CLI zonder verdere uitleg.

Raakt de open punten van 3.55: levels, elementenlijst, sheets. Stramienen worden in
de README niet genoemd. Te doen: `CHANGELOG.md` 0.19 → 0.25 lezen ("Upgrading from
0.24"), dan beslissen of de wasm-module in de viewer omhoog gaat. Let op: de
bladindeling-patch van 3.55 is eigen werk; nagaan of upstream hetzelfde nu zelf doet.

### A2. Open PDF Studio (OpenAEC Foundation) — README gelezen
`github.com/OpenAEC-Foundation/open-pdf-studio`, LGPL-3.0-or-later, release
v2026.47.0, circa 1.400 sterren. Een open PDF-editor "voor mensen die met
tekeningen werken", ook als webversie (PDF.js + pdf-lib, dezelfde bibliotheken als
de viewer; desktop gebruikt PDFium).

Wat de viewer er mogelijk van kan leren, in volgorde van nut:

1. **Meten met snappen op de vectoren van de tekening**, en schaal uit de PDF zelf
   lezen als die erin staat (DWG-plots) in plaats van kalibreren.
2. **XFDF in- en uitvoer** van markups. Dat is een gedocumenteerd formaat dat Revu
   ook leest; mogelijk een veiliger uitwisselroute dan het herschrijven van
   Bluebeam-annotaties (auditpunt 4, nog steeds nooit in Revu teruggelezen).
3. Hoeveelhedenstaat uit metingen, BCF 2.1 vanuit de PDF, meerdere markups
   tegelijk selecteren en uitlijnen (auditpunt 18, bewust gelaten).

De README noemt Bluebeam nergens; verwacht dus geen kennis van `BSIColumnData` of
toolsets. LGPL: ideeën en formaatkennis overnemen mag, code overnemen in het ene
HTML-bestand vraagt een bewuste keuze.

### A3. Grote IFC's: geheugen (auditpunt 5, 2,7 GB op S-9254)
Twee kandidaten; beide vragen een ingreep in het hart van de viewer, dus eerst
meten op S-9254 in een losse proefpagina.

| Bron | Wat | Status |
|---|---|---|
| `github.com/LTplus-AG/ifc-lite` (ook `louistrue/ifc-lite`), MPL-2.0 | IFC-lezer in Rust/wasm met WebGPU-weergave; losse pakketten voor o.a. `ids`, `bcf`, `diff`, `clash`, `export`, `drawing-2d`; er is een three.js-sjabloon. Makers melden 60–70 % lager piekgeheugen door buffers zonder kopie van wasm naar de videokaart | README gelezen; geheugenclaim alleen uit een zoekresultaat, geen vergelijking met web-ifc op de pagina |
| `github.com/ThatOpen/engine_fragment`, MIT | Fragments: binair formaat (FlatBuffers) plus three.js-weergave, met `IfcImporter` die in de browser draait. Opvolger van de route web-ifc → three-meshes | README gelezen; geen geheugencijfers |

Kleinere stap binnen de huidige opzet: `BatchedMesh` met `three-mesh-bvh` of
`agargaro/batched-mesh-extensions` (minder tekenopdrachten, snellere straal en
afkapping; geen geheugenwinst aangetoond). Zoekresultaat.

Twee waarschuwingen voor de eigen code: de staallijst steunt op het tekengedrag
van web-ifc 0.0.77 (`profielFactor`, zelftest sinds 3.24). Een andere lezer maakt
die correctie ongeldig; de zelftest moet dat dan vangen.

### A4. IDS-toets in de browser
Er bestaat een open "IFC model checker" die IfcOpenShell en IfcTester via Pyodide
(wasm) volledig in de browser draait, in een web worker
(`opensource.construction/projects/ifc-model-checker`). Zoekresultaat; repo en
licentie nog opzoeken. Daarmee kan de IDS-toets uit de oktoberronde (staalgewicht,
verboden tekens) in de viewer zelf, zonder Python op de pc. Alternatief zonder
Pyodide: het `ids`-pakket van ifc-lite. Nadeel van Pyodide: tientallen MB extra
download, dus alleen op verzoek laden.

### A5. Kleiner, alleen ter kennisname
- **DWG-layouts (auditpunt 21):** `github.com/mlightcad/cad-viewer` (MIT; het
  LibreDWG-deel GPL-3.0) heeft paper space en viewports op de routekaart staan,
  status onduidelijk. Bruikbaar als naslag voor gedraaide viewports zodra ze het
  hebben. README gelezen.
- **BCF:** `@parametricos/bcf-js` (MPL-2.0) leest en schrijft BCF 2.1 én 3.0;
  `thebimsider.github.io/bcfsleuth` is een BCF-inspectie in puur HTML. Alleen
  relevant als de viewer BCF 3.0 moet gaan schrijven. Zoekresultaat.
- **EmbedPDF** (`github.com/embedpdf/embed-pdf-viewer`, Apache-2.0): PDFium als
  wasm in een worker, met annotaties en meten. Alleen interessant als PDF.js bij
  zware sets blijft haperen (auditpunt 19). README gelezen.
- **Bluebeam:** geen openbare beschrijving van `BSIColumnData` gevonden; een
  pypdf-discussie stelt dezelfde vraag zonder antwoord. De Studio API (BAX-export,
  markuplijst als JSON) vraagt Studio Prime en een goedgekeurde app. Zoekresultaat.
  Conclusie: auditpunt 4 blijft handwerk in Revu.
- **Solibri:** REST API met OpenAPI-specificatie (BCF ophalen, Autorun); vraagt
  Solibri Office. Releasenotes juni 2026 noemen een vernieuwde IDS-regel (#244).
  Zoekresultaat. Nuttig voor auditpunt 14 als iemand Solibri heeft.
- **Trimble Connect:** Workspace API (`trimble-connect-workspace-api` op npm) om de
  Connect-3D-viewer in te bedden of een eigen zijpaneel te maken, met `topicId` voor
  BCF. Alleen relevant als een project in Connect leeft. Zoekresultaat.

## B. Voor de Revit-/pyRevit-workflow en deze repo

### B1. pyRevit 7 heeft een eigen agent-runtime (MCP) — releasepagina gelezen
`github.com/pyrevitlabs/pyRevit/releases`: 7.0.0 op 6 oktober, 7.1.0 op 15 november.

- **Agent runtime:** een MCP-geschikte agent stuurt Python-programma's naar het
  live model; goedkeuring gebeurt standaard in Revit. 7.1 begrenst invoer, uitvoer
  en logboek en controleert terugdraaien tegen het model. Opt-in, in te schakelen
  via de pyRevit-CLI. Een communitygids noemt het nog experimenteel.
- Dit raakt deze repo rechtstreeks: de Routes-koppeling crashte bij modeltoegang,
  `/execute_code/` is op 07-09 verwijderd en de Lees-MCP is eigen werk. De officiële
  runtime doet precies wat `/execute_code/` deed, maar met goedkeuring in Revit.
  **Vraag om te beslissen:** naast de Lees-MCP proberen op een testmodel, of laten.
- **Overig in 7.x:** uitvoervenster op WebView2 met donkere modus; herladen volgens
  de makers van 23 s naar 3 s; diepe recursie in IronPython geeft een fout in plaats
  van een crash; de CPython-engine liet de landinstelling van het proces veranderd
  achter, wat valse "file is corrupt"-meldingen bij Sync gaf (opgelost in 7.1).
- **Voor het SCI-lint:** kwalificatie van 7.1 dekt Revit 2023–2027 en IronPython
  2.7.12, dus de 2024–2027-eis blijft gedekt. Risico's om vóór een upgrade te
  toetsen: het WebView2-uitvoervenster (alles wat `output.print_html` of eigen HTML
  gebruikt), en inline metadata in scripts (sinds 6.5 "deprecated, opt-in", blijft
  volgens 7.0 minstens tot v8). Niet gelezen: de documentatiepagina zelf
  (`docs.pyrevitlabs.io/agent-runtime/` is in deze sessie niet bereikbaar).

Bijbehorend: `github.com/fulviofb/revit-claude-mcp` (stappenplan als Claude-skill,
getest op Revit 2027.3 met pyRevit 7.0.0; noemt als valkuilen tekens met accenten
in IronPython, PATH, en dat een nieuwe sessie nodig is), de forumdraad "pyRevit
Agent MCP [pyRevit 7]" op discourse.pyrevitlabs.io, en de enige relevante
YouTube-vondst: "pyRevit 7 - Agent Runtime MCP"
(`youtube.com/watch?v=5nK5bzT3nU0`, niet bekeken).

### B2. Tekla
`github.com/teknovizier/tekla_mcp_server` (GPL-3.0, Python/FastMCP, getest met Tekla
2022 en 2026): toolsets voor selectie, views, eigenschappen, componenten en
tekeningen, met een alleen-lezen-stand. Tweede Tekla-MCP naast `tempalg1n` uit de
oktoberronde. Wat de tekening-tools precies doen staat niet in de README. Alleen
relevant voor de geplande vakwerkbemating.

### B3. AutoCAD
Meerdere MCP-servers (`puran-water/autocad-mcp` met ezdxf zonder AutoCAD of via
bestandsuitwisseling voor AutoCAD LT; `best-cad-mcp` en `autocad-mcp-pro` via COM
op een draaiend AutoCAD). Zoekresultaat. Er is geen lopende SCI-vraag die dit
raakt; genoteerd zodat er niet opnieuw naar gezocht hoeft te worden.

## C. Niets gevonden

- **Technosoft:** opnieuw niets publieks. De eigen lezers blijven de enige bron.
- **SCIA:** niets nieuws boven SAF en de ADM-API met pythonnet uit oktober. Geen
  open lezer voor `.esa`.
- **BIMcollab:** geen openbare API-documentatie of MCP in de zoekresultaten.
- **YouTube:** buiten de pyRevit 7-video niets dat een open punt raakt. Zoeken op
  bemating, wapening en staalverbindingen met pyRevit gaf alleen cursussen en
  Autodesk University-lessen. Video's zelf zijn niet bekeken.

## D. Niet bereikbaar in deze sessie

`forums.autodesk.com` (draad "Revit API + Agentic AI: Sessions & Resources from
DevCon 2026"), `docs.pyrevitlabs.io` en `skills.sh` (de OpenAEC-skillpakketten voor
three.js, ThatOpen en IfcOpenShell). Maandag vanaf de eigen pc alsnog te openen;
de DevCon-draad is de meest kansrijke van de drie.
