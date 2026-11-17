---
titel: Externe bronnen, ronde november 2026 — pyRevit Agent Runtime, IFC in de browser, PDF en rekenbibliotheken
status: concept
laatst-bijgewerkt: 2026-11-17
bronnen:
  - "raw/2026-11-17-externe-bronnen-github-en-viktor.md §Samenvatting, §1 en §3 (zoekronde 17-11-2026; alleen GitHub-metadata, README's en webpagina's gelezen, niets gedraaid)"
  - https://github.com/pyrevitlabs/pyRevit/releases/tag/v7.0.0.26278%2B2233
  - https://docs.pyrevitlabs.io/agent-runtime/
  - https://github.com/LTplus-AG/ifc-lite
  - https://github.com/cantoo-scribe/pdf-lib
  - https://github.com/wyuebei-cloud/bluebeam-set-status
  - https://github.com/Blueprints-org/blueprints
  - https://github.com/cemsbv/pygef
  - "outputs/2026-11-16-lint-toets-pyrevit-7.1.0.md (team naar minimum pyRevit 7.1.0)"
verwant:
  - externe-bronnen-ronde-okt2026.md
  - externe-repos-kandidaten-en-afgevallen.md
  - viktor-rekenplatform.md
  - routes-thread-veiligheid.md
  - lees-mcp-koppeling.md
  - mcp-revit-koppeling.md
  - vyssuals-datavisualisatie.md
  - mcp-versus-custom-tools.md
  - bluebeam-sets-revisies-automatisch.md
  - model-vergelijken-fase0-ifc-rvt-link.md
skill: sci-bim-context
---

# Externe bronnen, ronde november 2026

Zoekronde van 17-11-2026, aangeleverd als `raw/2026-11-17-externe-bronnen-github-en-viktor.md`.
Gelezen zijn alleen GitHub-metadata, README's en publieke pagina's. Niets is
gedownload of gedraaid. "Werkt" betekent hier wat de README of de release-notes
beweren, niet wat wij gemeten hebben. Sterren en datums zijn de stand van
17-11-2026.

Deze ronde volgt op `externe-bronnen-ronde-okt2026.md`. Wat daar al stond
(IfcOpenShell, buildingSMART IDS, de Tekla-MCP van tempalg1n, de Revit-MCP's,
rvt-rs) is niet opnieuw aangedragen. VIKTOR, dat in dezelfde ronde is bekeken,
staat in `viktor-rekenplatform.md`.

## 1. pyRevit Agent Runtime

De belangrijkste vondst is geen losse repo maar een onderdeel van pyRevit zelf.
pyRevit 7.0.0 (06-10-2026) heeft een ingebouwde, opt-in **Agent Runtime (MCP)**
([release 7.0.0](https://github.com/pyrevitlabs/pyRevit/releases/tag/v7.0.0.26278%2B2233),
[docs](https://docs.pyrevitlabs.io/agent-runtime/)). Volgens de release-notes en
docs:

- elke run gaat via één `ExternalEvent` op de hoofdthread van Revit;
- het transport is een named pipe `\\.\pipe\pyrevit-agent-<pid>`, alleen voor de
  eigen Windows-gebruiker, geen TCP-poort;
- er zijn drie modi: `query`, `dry_run` en `modify`;
- met de policy `ask` kiest de gebruiker in Revit Keep of Discard, en een run
  wordt één undo-stap `Agent: <titel>`;
- tools zijn onder meer `get_context`, `inspect_elements`, `lookup_revit_api`,
  `capture_view`, `run_query` en `run_modify`, plus negen markdown-skills;
- run-records blijven 14 dagen leesbaar in `%APPDATA%\pyRevit\agent`.

Dit raakt drie artikelen tegelijk. `routes-thread-veiligheid.md` beschrijft
waarom model-aanrakende Routes-handlers crashen: ze lopen niet op de API-thread.
De Agent Runtime lost precies dat op, met `ExternalEvent`. `lees-mcp-koppeling.md`
beschrijft onze eigen oplossing voor hetzelfde probleem, en die heeft dezelfde
ontwerpkeuzes: een wachtrij naar `ExternalEvent`, `dry_run` als standaard,
schrijven pas na akkoord in Revit. Het verschil is wie het onderhoudt.

Het team zit sinds 16-11-2026 op minimum pyRevit 7.1.0
(`outputs/2026-11-16-lint-toets-pyrevit-7.1.0.md`), dus de Agent Runtime staat al
op elke pc, alleen niet aan.

[ONBEVESTIGD] Of de Agent Runtime in de praktijk stabieler is dan Routes, of
reload overleeft en wat hij doet bij een open dialoog in Revit. Niets daarvan is
gemeten; de bron stelt een proef voor (§4).

### Hetzelfde patroon, vier keer

Vier Revit-MCP-ontwerpen die los van elkaar zijn ontstaan, komen op hetzelfde
schrijfpatroon uit:

| Ontwerp | API-aanroep | Schrijven | Bron |
|---|---|---|---|
| Lees-MCP (eigen, 03_R&D) | wachtrij → `ExternalEvent` | `dry_run=true` standaard, bevestigingsdialoog in Revit | `lees-mcp-koppeling.md` |
| pyRevit Agent Runtime | één `ExternalEvent` per run | modi `dry_run`/`modify`, Keep/Discard in Revit | release 7.0.0 |
| aec-model-bridge | C#-add-in | pas na een goedgekeurd plan | README, tabel §2 #11 |
| Vyssuals | via de pyRevit-MCP-brug | voorstel zichtbaar in het dashboard, pas na goedkeuring naar het model | `vyssuals-datavisualisatie.md` §2-3 |

De gemeenschappelijke les: lees vrij, schrijf alleen na een zichtbaar voorstel en
een akkoord van de mens, en houd elke schrijfactie als één undo-stap. Dat is ook
de regel in de serverinstructie van onze Lees-MCP, en dezelfde conclusie als
`mcp-versus-custom-tools.md` §3 (AI-ondersteuning met een bevestigingsmoment).
Wie een nieuwe koppeling ontwerpt, hoeft dit niet opnieuw uit te vinden.

## 2. De kandidaten

Oordeel volgens de bron: **proberen** = binnen enkele weken een korte meting of
leesronde waard; **later** = oppakken als het onderwerp speelt; **afvallen** =
niet doen.

| # | Naam | Wat | Waarom voor ons | Licentie | Oordeel |
|---|---|---|---|---|---|
| 1 | pyRevit Agent Runtime | MCP-host in pyRevit 7.0+ | zie §1 | GPL-3.0 | proberen |
| 2 | [ifc-lite](https://github.com/LTplus-AG/ifc-lite) | Rust→WASM IFC-parser met losse pakketten `ids`, `bcf`, `clash`, `diff`, `query` | tegentoets voor IDS, clash en hoeveelheden in de SCI-Viewer, en `diff` voor Model vergelijken | MPL-2.0 | proberen, als tegentoets |
| 3 | [That Open engine_components](https://github.com/ThatOpen/engine_components) | componenten op web-ifc + three.js, met BCF- en IDS-mappen | zelfde stack als de viewer; geen clash-module gezien | MIT | later |
| 4 | [@cantoo/pdf-lib](https://github.com/cantoo-scribe/pdf-lib) | actieve fork van pdf-lib, kan incrementeel opslaan | de viewer draait pdf-lib 1.17.1, upstream sinds 17-07-2024 stil | MIT | proberen |
| 5 | [bluebeam-set-status](https://github.com/wyuebei-cloud/bluebeam-set-status) | Revu-reviewstatus via een verborgen antwoord-annotatie | patroon voor markup-status in de viewer | MIT | proberen, alleen het patroon |
| 6 | [pymkup](https://github.com/psolin/pymkup) | lezer voor Revu-markuplijsten en -kolommen | referentie voor Revu-eigen velden | onduidelijk (API: MIT, badge: GPL) | later |
| 7 | [EmbedPDF](https://github.com/embedpdf/embed-pdf-viewer) | PDFium als WebAssembly | alternatieve PDF-motor; geen reden om nu te wisselen | Apache-2.0 | later |
| 8 | [Blueprints](https://github.com/Blueprints-org/blueprints) | Eurocode-formules per artikel, met Nederlandse NB (EC2, EC3-kip), NEN 9997, CUR 228 | controle naast de Ontwerptools-staalrekentool | MIT, pre-1.0 | proberen, leesronde |
| 9 | [structuralcodes](https://github.com/fib-international/structuralcodes) | fib: EC2 2004/2023, MC2010/2020 | alleen beton | Apache-2.0 | later |
| 10 | [pygef](https://github.com/cemsbv/pygef) + [VIKTOR `bro`](https://github.com/viktor-platform/bro) | GEF én BRO-XML lezen; CPT's ophalen uit de BRO-API | de viewer leest al GEF; BRO-XML is de nieuwe stap | MIT | later |
| 11 | [aec-model-bridge](https://github.com/Sam-AEC/aec-model-bridge) | Revit-MCP, schrijven na goedgekeurd plan | pre-release, alleen leestoetsen in 2024 gevalideerd; #1 dekt hetzelfde | GPL-3.0 | afvallen |
| 12 | [revit-viktor-local-mcp](https://github.com/viktor-platform/revit-viktor-local-mcp), [pyrevit-viktor-integration](https://github.com/viktor-platform/pyrevit-viktor-integration) | VIKTOR-voorbeelden die `pyrevit agent run` aanroepen | voorbeeld van een externe aanroep van #1 | geen | later, alleen lezen bij #1 |
| 13 | [SAF-voorbeelden](https://github.com/StructuralAnalysisFormat/StructuralAnalysisFormat-Examples) | voorbeeld-SAF-bestanden | testbestanden als SAF ooit gelezen moet worden; voorbeelden uit 2023 | geen | later |
| 14 | [teknovizier/tekla_mcp_server](https://github.com/teknovizier/tekla_mcp_server) | Tekla-MCP | alleen als Tekla terugkomt | GPL-3.0 | afvallen |
| 15 | KanzonasPDF, butter-paper | desktop-PDF-editors als Bluebeam-alternatief | desktop, geen browserbibliotheek | AGPL-3.0 / MIT | afvallen |
| 16 | pyrevit-structural-toolkit | "150+ structural tools"-lint | geen licentie; installatie overschrijft `pyRevit_config.ini`; wachtwoord in de README | geen | afvallen, niet installeren |

De viewer-feiten in deze tabel (pdf-lib 1.17.1, 4.142 GEF-sonderingen) komen uit
`outputs/2026-11-17-sci-viewer-audit-pdf-3.62.md` en
`outputs/2026-11-16-lezers-ronde4-viewer-3.52-3.55.md`, zoals de bron ze noemt.

### Raakvlak met Bluebeam-sets

`bluebeam-sets-revisies-automatisch.md` §4 schrijft PDF's bewust volledig opnieuw
weg: met pypdf 6.18.1 ging de tweede of derde incrementele update mis
(objectnummers hergebruikt, gemeten 2026-09-18). `@cantoo/pdf-lib` (#4) kan
incrementeel opslaan, maar dezelfde toets hoort er eerst op: drie keer schrijven
op dezelfde PDF. Een incrementele update laat de Revu-historie en handtekeningen
staan, wat een volledige herschrijving niet garandeert.

[ONBEVESTIGD] Dat Revu 21 de reviewstatus uit #5 in de Markups List toont. Het
is een README-claim, niet getest.

### Wat niet gevonden is

- Een open-source lezer voor `.bax`, `.btx` of `.bex`. `.bax` is XML volgens een
  forum en de [bFX-gids](https://support.bluebeam.com/revu/resources/bfx-guide.html).
  Dat `.bex` XML is, was al gemeten (`bluebeam-sets-revisies-automatisch.md` §1).
- Nieuwe pyRevit-repo's voor constructieve maatvoering, tags of plotten die
  verder gaan dan `externe-patronen-revit-repos.md`.
- Eurocode 3-bibliotheken buiten Blueprints die groot of actief genoeg zijn.

## 3. Afgevallen zoekpaden

#11, #14, #15 en #16 hoeven niet opnieuw bekeken te worden. Ze vullen de lijst
in `externe-repos-kandidaten-en-afgevallen.md` §3 aan. #16 valt niet af om de
inhoud maar om de installatie: hij overschrijft `pyRevit_config.ini`, terwijl het
team de pyRevit-versie centraal bewaakt met een versiecheck in `startup.py`
(`modeless-venster-persistente-engine.md` §De persistent-vlag per pyRevit-versie).

## 4. Vervolg volgens de bron

De bron stelt vijf stappen voor, geen daarvan is gedaan (stand 17-11-2026):

1. **Agent Runtime proeven** op één pc, in een testmodel en nooit in productie
   (de bron verwijst naar memory `mcp-tests-sluiten-open-model`). Meten:
   crasht hij bij modeltoegang zoals Routes, overleeft hij reload, wat doet
   `revit_busy` bij een open dialoog. Daarna besluiten of Lees-MCP of Routes
   erop overgaan.
2. **Blueprints naast de Ontwerptools**: 5-10 staalchecks (EC3 6.2, NB-kip) voor
   dezelfde profielen vergelijken. Alleen lezen.
3. **`@cantoo/pdf-lib` toetsen** in de viewer-testopzet, met de drie-keer-schrijven-toets.
4. **Revu-reviewstatus** uit #5 op één testmarkup, controleren in Revu 21.
5. **ifc-lite als tegentoets**: één IFC (bijvoorbeeld de S-9464-export) met dezelfde
   IDS door de viewer en door `@ifc-lite/ids`. Vraagt een npm-installatie, dus
   alleen met akkoord.
