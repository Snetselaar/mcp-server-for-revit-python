# Externe bronnen 17-11-2026: GitHub-ronde en VIKTOR

Zoekronde van 17-11-2026. Alleen gelezen: GitHub-metadata en README's via `gh api`
(sterren, licentie, laatste push, releases, mappenboom) en publieke webpagina's.
Niets gedownload, geïnstalleerd of gedraaid. "Werkt" betekent hier dus nergens
"door ons getest"; het is wat de README of release-notes beweren.
Sterren en datums zijn de stand van 17-11-2026.

Niet opnieuw aangedragen (al in de wiki): IfcOpenShell/ifctester/ifcdiff, buildingSMART
IDS, revit-ifc, TSOpenAPIExamples, tempalg1n/tekla-mcp-server, PyTekla, Demolinator,
bimwright/rvt-mcp, horizun-revit-mcp, sharafutdinovdi/revit-model-mcp, Autodesk Revit
Public MCP, PyRebar, DimensionAuto, NLRS_ModelChecker, revit-model-health-checker,
PyNetLibrary, AlejoDuarte23/pyrevit-structural-analysis-extension, SAF-gitbook, rvt-rs
en verwanten.

## Samenvatting

1. **Belangrijkste vondst is geen losse repo maar pyRevit zelf:** pyRevit 7.0.0 (06-10-2026) heeft een ingebouwde *Agent Runtime (MCP)*: code loopt via een ExternalEvent op de hoofdthread, transport is een named pipe (geen TCP-poort), met modi query / dry_run / modify en goedkeuring Keep/Discard ín Revit. Dat is precies het thread-probleem van onze Routes-koppeling, en het team zit al op minimum pyRevit 7.1.0.
2. **IFC in de browser:** `ifc-lite` (MPL-2.0, 474 sterren, dagelijks actief) heeft IDS, BCF, clash→BCF, diff en hoeveelheden als losse npm-pakketten; bruikbaar als tegentoets voor de eigen IDS/clash in de SCI-Viewer.
3. **PDF:** `pdf-lib` van Hopding is sinds juli 2024 stil; de fork `@cantoo/pdf-lib` (MIT) is actief en kan incrementeel opslaan. Twee kleine Bluebeam-repo's tonen hoe Revu-reviewstatus en Revu-kolommen in de PDF zitten.
4. **Rekentools:** `Blueprints` (MIT, Nederlandse makers) heeft Eurocode-formules mét Nederlandse nationale bijlage (EC2, EC3 incl. NB-kipformules, EC5, NEN 9997, CUR 228) en SAF-resultaten; `structuralcodes` (fib, Apache-2.0) is alleen beton.
5. **Sonderingen:** `pygef` (MIT) leest GEF én BRO-XML; VIKTOR heeft een MIT-pakketje `bro` om CPT's uit de BRO-API te halen. De viewer leest GEF al; BRO-XML/BRO-ophalen is de nieuwe stap.
6. **VIKTOR** is een Rotterdams cloudplatform (AWS) waar ingenieurs Python-webapps bouwen, met workers die lokale SCIA/Revit/Dynamo/Excel aansturen, een AI App Builder en sinds november 2026 een MCP-koppeling (beta) zodat Claude VIKTOR-apps kan draaien. Prijzen staan niet online ("Contact us").
7. **Wat te leren van VIKTOR:** hun werkwijze rond rekentools (test- en productieversie, review door een collega met een bekende testcase, versiehistorie), "apps als deterministische tools voor een agent", en een eigen Revit-koppeling via precies dezelfde pyRevit Agent Runtime. Het platform zelf is pas interessant als rekentools breed gedeeld en beheerd moeten worden buiten de eigen pc's; voor wat er nu staat (viewer + pyRevit + Claude) voegt het vooral kosten en afhankelijkheid toe.

## 1. GitHub-kandidaten

Oordeel: **proberen** = binnen enkele weken een korte meting of leesronde waard;
**later** = noteren, oppakken als het onderwerp speelt; **afvallen** = niet doen.

| # | Naam | Link | Wat | Waarom nuttig voor ons | Licentie | Laatste activiteit / sterren | Oordeel |
|---|---|---|---|---|---|---|---|
| 1 | pyRevit Agent Runtime (in pyRevit 7.0+) | [release 7.0.0](https://github.com/pyrevitlabs/pyRevit/releases/tag/v7.0.0.26278%2B2233), [docs](https://docs.pyrevitlabs.io/agent-runtime/) | Opt-in MCP-host in pyRevit: agent stuurt Python-programma's; tools o.a. `get_context`, `inspect_elements`, `lookup_revit_api`, `capture_view`, `run_query`, `run_modify`; 9 meegeleverde markdown-skills | Lost op papier het Routes-probleem op: elke run in één ExternalEvent op de hoofdthread, named pipe `\\.\pipe\pyrevit-agent-<pid>` alleen voor de eigen Windows-gebruiker, `ask`-policy = Keep/Discard in Revit als één undo-stap `Agent: <titel>`. Dezelfde ontwerpkeuzes als onze Lees-MCP (dry_run, schrijven alleen na akkoord), maar dan door pyRevit onderhouden. Raakt `routes-thread-veiligheid.md`, `lees-mcp-koppeling.md`, memory `reload-crash-routes-thread` | GPL-3.0 (pyRevit) | 7.0.0 06-10-2026, 7.1.0 15-11-2026; repo 2.048 sterren | **proberen** |
| 2 | ifc-lite | [LTplus-AG/ifc-lite](https://github.com/LTplus-AG/ifc-lite) | Rust→WASM IFC-parser + WebGPU-viewer, TypeScript-SDK en CLI; pakketten `ids`, `bcf`, `clash`, `diff`, `query` (ook SQL via DuckDB-WASM), `mutations`, `export`, `drawing-2d`; IFC2X3/IFC4/IFC4X3/IFC5 | Tegentoets voor de eigen IDS-check, clash en hoeveelheden in de SCI-Viewer (`ifc-lite clash model.ifc --bcf clashes.bcfzip`), en voor Model vergelijken (pakket `diff`). Three.js-integratie bestaat, dus delen zijn los in te passen | MPL-2.0 (bestandsgebonden copyleft: gewijzigde bestanden blijven MPL) | push 17-11-2026, release v12.3.0 16-11-2026; 474 sterren | **proberen** (als referentie/tegentoets, niet als vervanging) |
| 3 | That Open engine_components | [ThatOpen/engine_components](https://github.com/ThatOpen/engine_components) | Componentenbibliotheek bovenop web-ifc + three.js; mappen `openbim/BCFTopics`, `openbim/IDSSpecifications`, meetgereedschap (lengte/hoek/oppervlak/volume) | Zelfde stack als de viewer (web-ifc + three.js); bruikbaar om BCF-/IDS-afhandeling naast de eigen code te leggen. Geen clash-module gezien in de mappenboom | MIT (engine_web-ifc zelf: MPL-2.0) | v3.6.0 22-10-2026; 744 sterren | **later** |
| 4 | @cantoo/pdf-lib | [cantoo-scribe/pdf-lib](https://github.com/cantoo-scribe/pdf-lib) | Actief onderhouden fork van pdf-lib, zelfde API; o.a. incrementele updates (`forIncrementalUpdate`, `commit()`), PDF-header behouden, herstel van afgekapte PDF's | De viewer draait op pdf-lib 1.17.1 (`outputs/2026-11-17-sci-viewer-audit-pdf-3.62.md`); upstream [Hopding/pdf-lib](https://github.com/Hopding/pdf-lib) is sinds 17-07-2024 niet meer gepusht. Incrementeel opslaan laat Revu-historie en handtekeningen staan. Let op: met pypdf ging incrementeel schrijven mis bij herhaling (`bluebeam-sets-revisies-automatisch.md`); dus eerst dezelfde drie-keer-schrijven-toets | MIT | push 11-09-2026; 361 sterren | **proberen** |
| 5 | bluebeam-set-status | [wyuebei-cloud/bluebeam-set-status](https://github.com/wyuebei-cloud/bluebeam-set-status) | Klein PyMuPDF-script: zet Revu-reviewstatus (Accepted/Rejected/Completed/…) via een verborgen antwoord-annotatie met `/IRT`, `/StateModel /Review`, `/State`, `/F 30` | Patroon voor de SCI-Viewer: markup-status zo wegschrijven dat de Markups List van Revu hem herkent, zonder `/BSIStatus`. [ONBEVESTIGD] dat Revu 21 dit zo toont; README-claim, niet getest | MIT | push 15-07-2026; 1 ster | **proberen** (alleen het patroon, 1 regel per markup) |
| 6 | pymkup | [psolin/pymkup](https://github.com/psolin/pymkup) | Python-lezer voor Revu-markuplijsten, Spaces en kolommen uit de PDF (reverse-engineered) | Referentie voor Revu-eigen velden (kolommen, Spaces) als de viewer markuplijsten moet exporteren zoals Revu. Licentie onduidelijk: GitHub-API zegt MIT, README-badge zegt GPL | MIT volgens API [ONBEVESTIGD] | push 16-02-2026; 50 sterren | **later** |
| 7 | EmbedPDF | [embedpdf/embed-pdf-viewer](https://github.com/embedpdf/embed-pdf-viewer) | PDF-viewer op PDFium als WebAssembly: lezen, annoteren, formulieren, ondertekenen, redigeren; headless-variant | Alternatieve PDF-motor als pdf.js + pdf-lib vastloopt op appearance streams of formulieren. Geen reden om nu te wisselen | Apache-2.0, behalve `cloudpdf/server` (FCL-1.0) | push 16-11-2026; 4.652 sterren | **later** |
| 8 | Blueprints | [Blueprints-org/blueprints](https://github.com/Blueprints-org/blueprints), [docs](https://blueprints.readthedocs.io) | Python-bibliotheek met Eurocode-formules per artikel/tabel: EN 1992-1-1, EN 1993-1-1 (2005 en 2022), 1993-1-8/-1-9/-5, EN 1995-1-1, EN 338, NEN 9997-1, CUR 228; Nederlandse NB voor EC2 (dekking, 8.14) en EC3 (NB-kipmoment); staal-checks (buiging, druk, afschuiving, trek, Von Mises); `saf/results` | Controle naast de Ontwerptools-staalrekentool van een collega (memory `ontwerptools-rekentool`) en bouwstenen voor kleine rekenknoppen; artikelnummers in de code maken toetsen per formule mogelijk. Zelfde mensen werken met VIKTOR (`viktor-platform/blueprints-steel-profiles`, `blueprints-nominal-cover`) | MIT | v0.8.0 24-10-2026, push 15-11-2026; 141 sterren. Nog pre-1.0 | **proberen** (leesronde: welke formules kloppen met de Ontwerptools) |
| 9 | structuralcodes | [fib-international/structuralcodes](https://github.com/fib-international/structuralcodes) | fib-bibliotheek: EC2 2004 en 2023, MC2010/MC2020, betonmaterialen, doorsneden (balk en schaal) met integratoren | Alleen beton; nuttig voor M-N-interactie en scheurwijdte als die ooit een eigen knop of viewer-functie wordt. Geen staal of hout | Apache-2.0 | v0.7.3 29-10-2026; 311 sterren | **later** |
| 10 | pygef + VIKTOR `bro` | [cemsbv/pygef](https://github.com/cemsbv/pygef), [viktor-platform/bro](https://github.com/viktor-platform/bro) | pygef: parser voor GEF én BRO-XML (CPT en boringen), Polars-dataframe. `bro`: CPT's ophalen uit de BRO-REST-API binnen een gebied | De viewer leest al 4.142 GEF-sonderingen van P: (`outputs/2026-11-16-lezers-ronde4-viewer-3.52-3.55.md` §3.54). Nieuw zou zijn: BRO-XML lezen en sonderingen rond een projectlocatie ophalen. pygef als referentie voor randgevallen | beide MIT | pygef push 16-11-2026 (laatste release 0.14.0, 14-11-2025), 35 sterren; `bro` push 16-08-2024, 7 sterren | **later** |
| 11 | aec-model-bridge | [Sam-AEC/aec-model-bridge](https://github.com/Sam-AEC/aec-model-bridge) | Revit-MCP (Python-server + C#-add-in, 2024-2027): schrijven pas na een goedgekeurd plan | Hetzelfde "plan → akkoord → schrijven"-patroon als in `vyssuals-datavisualisatie.md`. Maar: pre-release ("dev branch, not yet released"), alleen leestoetsen in 2024 live gevalideerd, GPL-3.0 + commercieel. pyRevit Agent Runtime (#1) dekt hetzelfde idee binnen onze eigen stack | GPL-3.0 | push 16-11-2026; 125 sterren | **afvallen** |
| 12 | revit-viktor-local-mcp / pyrevit-viktor-integration | [revit-viktor-local-mcp](https://github.com/viktor-platform/revit-viktor-local-mcp), [pyrevit-viktor-integration](https://github.com/viktor-platform/pyrevit-viktor-integration) | VIKTOR-voorbeelden: chat-agent → VIKTOR Desktop-worker → .NET-MCP → Revit; resp. VIKTOR → `pyrevit agent run` met `--mode=query/dry_run/modify` | Laat zien hoe een externe partij de pyRevit Agent Runtime aanroept (`pyrevit agent status`, `job.json` → `output.json`); bruikbaar als voorbeeld voor #1, ook zonder VIKTOR | geen licentie | push 01-11 en 03-11-2026; 0 sterren | **later** (alleen lezen bij #1) |
| 13 | SAF-voorbeelden | [StructuralAnalysisFormat-Examples](https://github.com/StructuralAnalysisFormat/StructuralAnalysisFormat-Examples), [-Doc](https://github.com/StructuralAnalysisFormat/StructuralAnalysisFormat-Doc) | Voorbeeld-SAF-bestanden en de documentatiebron van saf.guide | Testbestanden als de viewer of een knop ooit SAF moet lezen; voorbeelden zijn wel oud | geen licentie | Examples 04-04-2023, Doc 02-07-2026 | **later** |
| 14 | teknovizier/tekla_mcp_server | [repo](https://github.com/teknovizier/tekla_mcp_server) | Tekla-MCP, groter dan de in oktober genoteerde tempalg1n-variant | Alleen relevant als Tekla terugkomt; niets wezenlijk nieuws voor de vakwerkbemating | GPL-3.0 | push 11-11-2026; 66 sterren | **afvallen** |
| 15 | KanzonasPDF, butter-paper | [KanzonasPDF](https://github.com/keithlyding/KanzonasPDF), [butter-paper](https://github.com/apotenza92/butter-paper) | Desktop-PDF-editors die zich als gratis Bluebeam-alternatief presenteren | Desktop, geen browserbibliotheek; KanzonasPDF AGPL-3.0, aangemaakt 07-10-2026. Hooguit UI-inspiratie | AGPL-3.0 / MIT | beide push 17-11-2026; 9 / 3 sterren | **afvallen** |
| 16 | pyrevit-structural-toolkit | [anthony80188/pyrevit-structural-toolkit](https://github.com/anthony80188/pyrevit-structural-toolkit) | "150+ structural tools"-lint | Geen licentie, 0 sterren, installatie overschrijft `pyRevit_config.ini` en `extensions.json`, wachtwoord in README. Niet kopiëren, niet installeren | geen | push 01-09-2026 | **afvallen** |

Niet gevonden: een open-source lezer voor `.bax`/`.btx`/`.bex` op GitHub. `.bax` is
XML volgens een gebruikersforum en de [bFX-gids](https://support.bluebeam.com/revu/resources/bfx-guide.html);
een op het [uChapter2-forum](https://uchapter2.com/brainery/tips-tricks/forum/topic/tool-for-decoding-bluebeam-configuration-and-markup-files/)
aangekondigde HTML-tool voor `.btx`/`.bax` is [ONBEVESTIGD] nooit op GitHub verschenen.
Geen nieuwe pyRevit-repo's voor constructieve maatvoering, tags of plotten gevonden die
verder gaan dan wat in `externe-patronen-revit-repos.md` staat. Python-repo's voor
Eurocode 3 buiten Blueprints zijn klein of oud (bv. `PedroBiel/EN_1993`, geen licentie,
laatste push 24-10-2024).

## 2. VIKTOR

### Wat het is

- Rotterdams bedrijf; oprichtingsjaar wisselt per bron (2012 volgens
  [CB Insights](https://www.cbinsights.com/company/viktor), 2017 volgens
  [YES!Delft](https://yesdelft.com/startups/viktor/)) [ONBEVESTIGD welke klopt].
  Let op de naamgenoot viktor.com, een Slack-agent die niets met viktor.ai te maken heeft
  ([saascrmreview](https://saascrmreview.com/viktor-review/)).
- **Platform:** ingenieurs schrijven met een Python-SDK webapps (invoervelden →
  berekening → views/rapport); draait in de VIKTOR-cloud op AWS, met ISO 27001 en
  9001 volgens eigen zeggen ([blog 213](https://www.viktor.ai/blog/213/automating-engineering-tasks-with-viktor-a-guide-to-safe-high-quality-innovation)).
  Regio van hosting niet gevonden.
- **Workers / VIKTOR Desktop:** lokale software (SCIA, Revit, Dynamo, ETABS, STAAD,
  Plaxis, Excel e.a.) wordt aangestuurd via een worker op een Windows-pc die uitgaand
  naar de cloud verbindt; sinds juli 2026 beheerd vanuit VIKTOR Desktop met
  "one click"-installatie per integratie ([blog 251](https://www.viktor.ai/blog/251/solving-engineering-problems-will-get-a-lot-easier-with-viktor-desktop);
  [Revit-integratie](https://docs.viktor.ai/docs/create-apps/software-integrations/revit/),
  [SCIA-integratie](https://docs.viktor.ai/docs/create-apps/software-integrations/scia/)).
  SCIA-eis volgens de docs-samenvatting: materialen moeten in het ESA-template bestaan en
  de SCIA-versie van template en worker moet gelijk zijn [docs zelf gaven 403, via zoekmachine].
- **AI:**
  - App Builder (sinds 2025): genereert een VIKTOR-app uit een prompt, code inzichtelijk
    ([AEC Magazine](https://aecmag.com/automation/viktor-to-simplify-engineering-automation-with-ai-builder/)).
  - Juni 2026: leest `.xlsm` en Mathcad en vertaalt die naar een Python-app
    ([juni 2026](https://www.viktor.ai/blog/247/whats-new-in-viktor-june-2026)).
  - April 2026: "self-hosted LLM" in apps, zonder tokens; waar die draait staat er
    niet ([april 2026](https://www.viktor.ai/blog/238/whats-new-in-viktor-april-2026)).
  - November 2026 (beta): VIKTOR-apps aanroepen vanuit Claude, ChatGPT of Gemini via MCP;
    de agent ziet alleen de app-logica, "cannot read or write project data"
    ([november 2026](https://www.viktor.ai/blog/271/what-s-new-in-viktor-november-2026)).
  - Agent die apps als deterministische tools aan elkaar knoopt (wind, geometrie,
    analyse); in januari 2026 nog wachtlijst ([blog 225](https://www.viktor.ai/blog/225/How-to-automate-engineering-workflows-with-AI-agents)).
- **Prijs:** [plans-pagina](https://www.viktor.ai/plans): Free (1 gebruiker, alleen
  publieke apps), Individual (1 Power Builder, 100 credits/maand, privé-apps, integraties,
  Git/lokaal ontwikkelen), Small Business (2 Power Builders + 5 Builders), Business
  (5 + 30, audit trail, SSO optioneel), Enterprise (vanaf 20 + 100). Geen bedragen: alles
  boven Free is "Contact us". [ONBEVESTIGD] bedrag per stoel; Capterra en TrustRadius
  noemen ook geen prijs.
- **Publieke GitHub:** [viktor-platform](https://github.com/viktor-platform), 86 publieke
  repo's, vooral voorbeeldapps zonder licentie; enkele MIT (`bro`, `bro-app`,
  `aps-automation-sdk`, `pyrevit-plugin`). Relevant voor ons: `cpt-interpreter` (GEF →
  grondopbouw met Robertson), `sample-compare-cpt`, `sample-pile-foundations`
  (D-Foundations + SCIA), `scia-bridge`, `sample-scia-model`, `ifc-viewer`,
  `pyrevit-viktor-integration` en `revit-viktor-local-mcp` (zie tabel #12),
  `blueprints-*` (Eurocode-apps op Blueprints).
- **Nederlandse cases:** Arcadis (D-Foundations, Excel en SCIA gekoppeld), Heijmans
  (Excel-rekenbladen aan SCIA), Heembouw met WSP (staal-app: inloggen vanuit Revit,
  parameters invullen, profielen terug in het Revit-model)
  ([case Heembouw](https://www.viktor.ai/customer-cases/55/parametric-design-for-sustainable-construction-at-heembouw),
  [SCIA-cases](https://www.viktor.ai/customer-cases/category/all/discipline/all/integration/SCIA/1),
  [blog 112](https://viktor.ai/blog/112/streamlining-structural-engineering-viktor-for-building-and-construction)).
  Geen case gevonden van een middelgroot constructiebureau met Revit + Technosoft.

### Wat het bureau van VIKTOR kan leren of overnemen

1. **Release-discipline voor rekentools.** VIKTOR scheidt test- en productieversie per
   app, een collega reviewt code en draait een case met bekende uitkomst (capaciteit,
   unity check, pass/fail, rapport) vóór vrijgave, en elke versie heeft tag, maker en
   datum ([blog 269](https://www.viktor.ai/blog/269/how-to-scale-ai-in-your-engineering-organization-generate-results-you-can-trust),
   [november 2026](https://www.viktor.ai/blog/271/what-s-new-in-viktor-november-2026)).
   Het lint heeft dat al als 03_R&D → 02_Beta → 01_SCI; voor de Ontwerptools en
   rekenfuncties in de SCI-Viewer bestaat zoiets nog niet. Over te nemen: per rekentool
   een vaste testcase met bekende uitkomst die bij elke versie meedraait.
2. **Apps als deterministische tools voor een agent.** Hun MCP stelt alleen de
   app-logica bloot, niet de projectdata. Zelfde gedachte voor ons: Claude laat
   rekenwerk over aan getoetste functies (Blueprints-achtig, Ontwerptools) in plaats
   van zelf te rekenen.
3. **De Revit-koppeling via pyRevit Agent Runtime.** VIKTOR bouwt hun nieuwste
   Revit-voorbeeld op `pyrevit agent run` met query/dry_run/modify. Dat bevestigt #1 uit
   de tabel als richting voor onze eigen MCP.
4. **UI-patroon rekentool:** links invoer (velden, dynamische tabellen met een rij per
   regel), rechts views (3D, grafiek, tabel, rapport-PDF), elk resultaat herleidbaar tot
   de invoer. [ONBEVESTIGD] in detail; afgeleid uit de README's van `beam-analysis` en
   `pyrevit-viktor-integration`, de SDK-docs zelf gaven 403.
5. **Legacy-rekenbladen omzetten.** Hun App Builder vertaalt `.xlsm`/Mathcad naar
   Python. Dat kan Claude ook zonder platform, en dezelfde controle hoort erbij: oude
   en nieuwe uitkomst naast elkaar op dezelfde cases.

### Wanneer het platform zelf zin heeft

- **Wel interessant als:** rekentools door veel collega's (of opdrachtgevers) via een
  browser gebruikt moeten worden zonder installatie, met accountbeheer, audit trail en
  versiebeheer die niemand intern wil onderhouden; of als SCIA/Plaxis/D-Foundations
  vanuit een webapp in batch moeten draaien.
- **Niet nu, omdat:**
  - de kernstukken al lokaal en zonder licentiekosten draaien: SCI-Viewer als één
    HTML-bestand, pyRevit-lint, Claude met eigen MCP;
  - Technosoft, het hoofdrekenpakket, geen VIKTOR-integratie heeft (niet gevonden);
  - alles boven Free een stoelabonnement op aanvraag is, met credits voor rekentijd;
  - code en apps in hun cloud draaien (AWS), dus projectdata het huis verlaat, en
    apps gebonden zijn aan hun SDK: overstappen betekent herschrijven;
  - de Free-laag alleen publieke apps toestaat, dus niet bruikbaar voor projectwerk.
- **Goedkope tussenweg:** een gratis account alleen om de App Builder en de
  Blueprints-apps te bekijken. Geen projectdata uploaden. (Account aanmaken alleen
  door de gebruiker zelf.)

## 3. Voorgestelde volgende stappen (max 5)

1. **pyRevit Agent Runtime proeven op één pc (Albert, pyRevit 7.1.0):** aanzetten in
   pyRevit → Settings → Agent Runtime (MCP), policy `readonly` of `ask`, in een
   testmodel (nooit productie, memory `mcp-tests-sluiten-open-model`). Meten: crasht het
   bij model-toegang zoals Routes, blijft reload werken, wat doet `revit_busy` bij een
   open dialoog. Daarna besluiten of Lees-MCP/Routes erop overgaan. Release-notes en
   [docs](https://docs.pyrevitlabs.io/agent-runtime/) eerst lezen. Let op: run-records
   staan 14 dagen leesbaar in `%APPDATA%\pyRevit\agent`.
2. **Blueprints-leesronde tegen de Ontwerptools:** 5-10 staalchecks (EC3 6.2, NB-kip)
   uit Blueprints naast de Ontwerptools-uitkomst leggen voor dezelfde profielen; alleen
   lezen, geen code overnemen zonder bronvermelding (MIT).
3. **`@cantoo/pdf-lib` als vervanger van pdf-lib 1.17.1 toetsen** in de viewer-testopzet
   (Node, t.pdf/t2.pdf zoals in de PDF-audit van 17-11): zelfde uitvoer, en daarna drie
   keer incrementeel opslaan op dezelfde PDF en openen in Revu.
4. **Revu-reviewstatus als markup-functie:** het `/IRT`+`/StateModel`-patroon uit
   `bluebeam-set-status` op één testmarkup in de viewer, controleren in Revu 21 of de
   Markups List de status toont.
5. **ifc-lite als tegentoets:** één IFC (bv. de S-9464-export) met dezelfde IDS door de
   viewer én door `@ifc-lite/ids` (en clash naar BCF), verschillen noteren. Vraagt een
   npm-installatie: alleen met akkoord.
