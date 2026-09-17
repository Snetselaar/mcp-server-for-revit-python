---
titel: Externe Revit-repo's — kandidaten voor een volgende ronde en afgevallen zoekpaden
status: concept
laatst-bijgewerkt: 2026-09-17
bronnen:
  - "raw/2026-09-17-kennisextractie-externe-revit-repos.md (opdracht van 2026-09-14, tabel Stap 2 en de alinea's eronder)"
  - "skill bimtools-logging, SKILL.md r. 12-15 (logstromen)"
verwant:
  - externe-patronen-revit-repos.md
  - mcp-versus-custom-tools.md
  - routes-thread-veiligheid.md
  - ifc-export-staalgewicht.md
  - nlrs-en-bim-standaarden.md
  - rebar-api-parameters.md
  - ai-brain-kennisorganisatie-pyrevit.md
skill: pyrevit-codestijl
---

# Externe Revit-repo's: kandidaten en afgevallen zoekpaden

`externe-patronen-revit-repos.md` legt vast wat de Prio-1-ronde van 14-09-2026
opleverde: zes repo's, gelezen en licentie-gefilterd. Dit artikel bewaart de rest
van de opdracht die aan die ronde voorafging: de repo's die nog niet geopend zijn,
en de zoekpaden die de opdrachtgever al had afgesloten.

**Alles hieronder is de beschrijving uit de opdracht, niet een eigen lezing.**
Geen van deze repo's is in de ronde van 14-09 geopend, geen licentie is
vastgesteld en geen aantal is nageteld. Behandel elke regel als
[ONBEVESTIGD] tot een volgende ronde hem bevestigt.

## 1. De lens: welke SCI-knop er verder mee komt

De opdracht beoordeelt elke repo op één vraag: welk openstaand script komt er
concreet verder? Die lijst is zelf informatie over wat SCI in september 2026 wil
bouwen:

| Openstaand bij SCI | Raakt vooral |
|---|---|
| 2D-wapening taggen op sheet | `revit-auto-tag`, `PyRebar` |
| ModelCheck (registry van read-only checks) | `PyRebar`, `NLRS_ModelChecker`, `revit-model-health-checker` |
| Checks buiten Revit testen | `revit-model-health-checker` |
| Bematingsscript uitbreiden | `DimensionAuto` |
| IFC-data stroomlijnen | `revit-ifc`, `buildingSMART/IDS`, `ifctester` |
| Data in het model opslaan | `extensible-storage-pyrevit` |
| Rekenmodel tegen het Revit-model controleren | `pyrevit-structural-analysis-extension` |
| Sneller schrijven, versieverschillen vaststellen | `PyNetLibrary` |
| Tekla-vakwerkbemating (gepland) | `TSOpenAPIExamples` |

De regels voor een ronde, ook voor de volgende: licentie vóór inhoud, maximaal
twaalf patronen, elke bevinding met repo, commit, pad en regelnummer, en bij een
herhaling alleen de repo's bijwerken waarvan de `HEAD` veranderd is.

## 2. Nog niet geopend — kandidaten

| Prio | Repo | Wat de opdracht erin zoekt | Voor |
|---|---|---|---|
| 2 | `AlejoDuarte23/pyrevit-structural-analysis-extension` | exportschema van `AnalyticalMember` naar JSON (knopen, lokale assen, sectie, materiaal, scharnieren, koppeling naar het fysieke element) en `host_match.py` | rekenmodelcontrole |
| 2 | `ADN-DevTech/revit-api-chms` + `DTDucas/chm-converter` | alle `RevitAPI.chm`-bestanden vanaf 2012, omgezet naar Markdown met `file_index.json` en `id_lookup.json` | API-verificatie offline en per versie |
| 2 | `Autodesk/revit-ifc` | welke property sets de exporter standaard schrijft, hoe classificatie en `IFCExportConfiguration` samenhangen | IFC-data |
| 2 | `buildingSMART/IDS` + `IDS-Audit-tool` | de facet-typen van de IDS-XSD en een voorbeeldbestand | IFC-data |
| 2 | `TrimbleSolutionsCorporation/TSOpenAPIExamples` + `TSOpenAPISelfLearning` | eerst alleen vaststellen dat de Tekla Open API .NET/C# is | Tekla-vakwerkbemating |
| 3 | `dambinhtu-nhuy/revit-auto-tag` | "lees de al geplaatste tags uit vóór je plaatst"; `IndependentTag.Create` versus `NewRoomTag` | 2D-wapeningstagger |
| 3 | `Bouwtekening24/PyRevit-IFC-Parameter-Mapping` | Nederlandse pyRevit-tool die de IFC-mappingtabel en de exportconfiguratie in de sessie bijwerkt. Door de opdrachtgever zelf niet kunnen inzien; licentie onbekend | IFC-data |
| 3 | `IfcOpenShell/IfcOpenShell` (alleen `ifctester`) | een IFC tegen een IDS valideren; CPython, dus naast Revit | IFC-data |
| 3 | `burnished-edge/pyRevit-AutoDismiss` | dialogen wegklikken via een `startup.py`-hook, en een aan/uit-toggle via `script.get_config()` | afbakening met de failure-preprocessor |
| 3 | `OriAshkenazi/ai-pyrevit-developer-template` | `AGENTS.md`, plan-naar-taken-workflow, CI-checks tegen verouderde docs | werkwijze |
| 3 | `QuanZ827/zexus` | hoe een in-process Revit-agent begrenst wat er uitgevoerd mag worden (C#) | MCP-koppeling |
| 3 | `RevitStandards/NLRS_Revit_Settings` | alleen registreren: settingbestanden met Assembly Codes en Keynotes | SCI-template |

### Wat het meest oplevert, en waarom

**Rekenmodelcontrole.** Volgens de opdracht de enige vondst in vier zoekrondes
die dit raakt. De heuristiek in `host_match.py` koppelt een analytisch lid aan
zijn fysieke drager bij een hoek van hooguit 10°, een middelpunt binnen 3× de
tolerantie en een score van hooguit 6× de tolerantie. Of die drempels op
SCI-modellen kloppen, is de vraag die de opdracht stelt. Volgens de opdracht is
er geen licentiebestand, dus alleen beschrijven. De module vangt Revit-imports af
met `try/except → object`; dat is het alternatief dat
`externe-patronen-revit-repos.md` bij Openstaande vragen, vraag 1 tegenover de
Revit-vrije regelmodule zet.

**Offline API-documentatie.** De CHM-bestanden plus de converter zouden
signatuurverificatie per versie mogelijk maken zonder online bron. Dat raakt een
open punt: de 2024/2027-spotcheck van de wapeningsparameters in
`rebar-api-parameters.md` §6 kan sinds eind augustus niet meer live, en vraagt nu
een documentatiepagina. De opdracht noemt dit de tegenhanger van `PyNetLibrary`:
stubs geven de signatuur, de CHM het gedocumenteerde gedrag.

**IFC.** Vier kandidaten raken de twee IFC-gaten die de kennisbank sinds 15 en 16
september kent: staalgewicht dat niet in de export komt
(`ifc-export-staalgewicht.md`) en placeholders die de import breken
(`ifc-import-verboden-tekens-in-namen.md`). Een IDS-validatie met `ifctester` zou
precies dat soort fout vóór verzending vangen, iets wat de exportknoppen nu niet
doen.

**Begrenzing van een agent.** `zexus` wordt gezocht voor het guardrail-concept.
Sinds 09-09-2026 is dat geen theoretische vraag meer: de Routes-koppeling crasht
bij model-toegang (`routes-thread-veiligheid.md`), en de risico's van AI in een
live model staan in `mcp-versus-custom-tools.md` §2.

**AutoDismiss.** Het onderscheid met de failure-preprocessor staat al in
`externe-patronen-revit-repos.md` §5. De opdracht voegt toe dat een globale hook
die dialogen wegklikt in de testmatrix een hoog risicoprofiel hoort te krijgen.

**Werkwijze.** De AI-ontwikkelstroom met `AGENTS.md` en CI-checks tegen
verouderde documentatie is dezelfde soort vergelijking als
`ai-brain-kennisorganisatie-pyrevit.md` maakt met Erik Frits' opzet. De opdracht
vraagt alleen te noteren wat SCI mist.

## 3. Afgevallen — niet opnieuw zoeken

Volgens de opdrachtgever onderzocht en zonder bruikbare opbrengst. Vastgelegd als
negatieve kennis, met de reden:

| Repo of zoekpad | Waarom afgevallen |
|---|---|
| `Tereami/RebarSketch`, `RevitAreaReinforcement` | door de auteur zelf op `zzz_OBSOLETE` gezet |
| `branch-danya-dev/revit-rebar-autodim` | closed-source demo, .NET 8, alleen Revit 2025 |
| `kristiangl/RevitSheetExporter`, Autodesk-Forge PDF-samples | C#/cloud, lopen achter op de eigen PrintSheets |
| SCIA-koppeling (`Koala` e.a.) | `Koala` is Rhino/Grasshopper in VB.NET uit 2022, de rest losse scripts; de Technosoft-route blijft eigen werk |
| Revit↔Excel-parameterrondgang | de Autodesk Design Automation-samples zijn deprecated en cloud-only |
| staalspecifieke repo's | allemaal C#, eenmalig of leeg |
| waarschuwingsbeheer buiten AutoDismiss | niets gevonden |
| raam- en deuropeningen uit een gekoppeld model overnemen | niets op GitHub; blijft eigen werk |
| andere stubprojecten dan `PyNetLibrary` | bestaan niet |
| `pyrevitlabs/telemetry-server` | vraagt een serverdeployment en vervangt de eigen logging in plaats van hem aan te vullen; pas relevant bij centraal verzamelen |
| alternatieve Revit-MCP's (`horizun-revit-mcp`, `BIM-Bot`, Revit 2023–2027) | "onze koppeling werkt"; pas interessant als we vastlopen |
| BIM basis ILS | `Teun1/...Nederlandse-BIM-standaarden` is een ZIP uit 2019 onder een niet-commerciële licentie; `Root-bv/Solibri-ruleset-BIM-basisILS` is een Solibri-ruleset uit 2023, geen Revit |
| modelvergelijking op elementniveau (`RevitDiff`, Speckle) | platformkeuze, geen extractiemateriaal |

Twee kanttekeningen bij deze tabel:

- **De MCP-afweging is achterhaald.** Toen de opdracht werd geschreven (14-09),
  gold "onze koppeling werkt". Sinds 09-09 staat in `KNOWN_ISSUES.md` dat de
  Routes-koppeling bij model-toegang crasht, en dezelfde dag als de opdracht is
  de eigen Lees-MCP gebouwd (`lees-mcp-koppeling.md`). De voorwaarde "pas als we
  vastlopen" was dus al vervuld. Of `horizun-revit-mcp` of `BIM-Bot` het
  thread-probleem anders oplossen, is niet bekeken.
- **Logging.** De opdracht spreekt van "onze JSONL-toollog". Volgens de skill
  `bimtools-logging` is de toollog een CSV (`Gebruikslog.csv`); JSONL zijn de
  sheetlog, modeldata en de ModelCheck-runlog. De skill gaat voor. Voor het
  oordeel over `telemetry-server` maakt het niet uit.

## 4. Getallen uit de opdracht die in het patronenartikel ontbreken

Aanvullingen op de Prio-1-repo's die de ronde van 14-09 niet overnam. Niet
nageteld.

- `NLRS_ModelChecker`: één XML van 207 KB met 678 filters, naast de 42 checks in
  10 secties die `externe-patronen-revit-repos.md` §8 noemt.
- `PyNetLibrary`: stubcorpus van 15,3 MB over 106 namespaces, waarvan
  `Autodesk.Revit.DB` 1.312 klassen en `Autodesk.Revit.DB.Structure` 237;
  draait op pythonnet met CPython 3.10.
- `PyRebar`: ook `lib/conversion.py` (eenheden) en `Settings.pushbutton` met
  `lib/pyrebar_settings.py`, en het `hasattr(eid, "Value")`-patroon voor 2024–2027.
  Dat laatste lost hetzelfde op als de drietrapsval in
  `externe-patronen-revit-repos.md` §1.
- `DimensionAuto`: naast de zonelogica ook collision-avoidance rond wanden en
  kolommen in het maatlijnpad, en een symbol→instance-conversie van references
  voor kolommen. Beide niet uitgewerkt in de ronde.

## 5. Bestemming: wiki in plaats van skill

De opdracht mikte op één bestand `pyrevit-codestijl/references/externe-patronen.md`
met een regel in de skill-index. Op 14-09 is bewust gekozen voor een wiki-concept,
omdat skill-references pas werken na een handmatige upload en omdat externe
research eerst het promotiepad `raw → wiki → skill` hoort te lopen
(`memory.md`, regel 2026-09-14). Die keuze staat nog; een promotie via
`/kb-promoveer` is pas aan de orde als patronen stabiel blijken.
