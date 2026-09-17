# Opdracht: kennisextractie uit externe Revit-repo's

Je leest een aantal publieke GitHub-repo's uit, haalt daar de patronen uit die voor
SCI bruikbaar zijn, en schrijft die weg als één reference-bestand in de bestaande
skill-structuur. Dit is **statisch leeswerk** — je start geen Revit, je draait geen
script uit een van deze repo's.

## De lens: waarvoor deze kennis dient

Dit is geen inventarisatie. Het doel is dat er na afloop gerichte SCI-knoppen
gebouwd kunnen worden, dus elke bevinding wordt beoordeeld op de vraag welk
openstaand script er concreet verder komt:

| Openstaand bij SCI | Waar de externe repo's op raken |
|---|---|
| **2D-wapening taggen op sheet** | het "lees de bestaande tags eerst"-patroon (`revit-auto-tag`); rebar-selectie op parameter en per bar mark (`PyRebar`) |
| **ModelCheck** — registry van read-only checks | de checkdefinities uit `PyRebar/Audit`: dubbele staven via afgeronde bounding box, staaflengte onder/boven grens. Kant-en-klare kandidaten voor de registry, mits ze in ons result-contract passen. Plus de 42 NLRS-naamgevingschecks (`NLRS_ModelChecker`) en het testbaarheidspatroon (`revit-model-health-checker`) |
| **Checks buiten Revit kunnen testen** | regelmodule zonder Revit-imports, pure functies, `unittest` in CI (`revit-model-health-checker`) — dit dicht het gat dat de testmatrix nu handmatig vult |
| **Bematingsscript uitbreiden** | zone-registratie tegen stapelende maatlijnen, collision-avoidance, failure-afhandeling zonder dialoog (`DimensionAuto`) |
| **IFC-data stroomlijnen** | welke property sets de exporter zelf al wegschrijft (`revit-ifc`); of onze datastandaard in IDS uit te drukken is (`buildingSMART/IDS`, `ifctester`) |
| **Data in het model opslaan** (ProjectNotitie en opvolgers) | declaratieve schema's + transactie-context voor Extensible Storage (`extensible-storage-pyrevit`) |
| **Rekenmodel tegen het Revit-model controleren** | de JSON-exportstructuur van het analytische model en de heuristiek die analytische leden aan fysieke elementen koppelt (`pyrevit-structural-analysis-extension`) |
| **Sneller schrijven én versieverschillen hard vaststellen** | API-stubs met klassenindex, per Revit-versie zelf te genereren en te diffen (`PyNetLibrary`) — dit vervangt het per geval nalopen van de documentatie |
| **Tekla-vakwerkbemating** (gepland) | de officiële Open API-voorbeelden (`TSOpenAPIExamples`) — maar eerst de stackvraag beslechten, zie de tabel |
| **Elke nieuwe knop** | het `hasattr(eid, "Value")`-patroon als enkelvoudige codebase voor 2024–2027 (`PyRebar`) |

Een patroon dat geen van deze vijf verder helpt, hoort niet in §1. Zet het in §2 of
laat het staan.

## Definition of done

Eén nieuw bestand: `pyrevit-codestijl/references/externe-patronen.md`, plus één
regel in de index van `pyrevit-codestijl/SKILL.md` die ernaar verwijst. Niets
anders aangeraakt. Aan het eind een korte samenvatting in de chat: welke patronen
zijn opgenomen, welke repo's afgevallen zijn en waarom.

Plafond: **maximaal twaalf patronen in §1.** Zit je daaraan voordat de lijst uit is,
dan stop je en meld je welke repo's nog openstaan. Een bestand met vijftig patronen
wordt niet meer gelezen en gaat bij de eerstvolgende pruning alsnog om.

Dit is een terugkerende ronde, geen eenmalige klus. Bij een volgende keer vergelijk
je de commit-hashes uit §3 met de huidige `HEAD` en werk je alleen de repo's bij die
sindsdien veranderd zijn.

## Harde grenzen

1. **Licentie vóór inhoud.** Lees per repo eerst `LICENSE`. MIT/BSD/Apache →
   patroon mag overgenomen worden, met bronvermelding in de scriptkop.
   GPL/LGPL/AGPL of geen licentiebestand → **niets overnemen**, alleen beschrijven
   wat het doet en waarom de aanpak interessant is. Bij twijfel: niet overnemen en
   dat expliciet opschrijven.
   *Uitzondering voor `NLRS_ModelChecker` (GPL v3):* vastleggen **wélke** checks de
   standaard definieert is feitelijke informatie over een gepubliceerde norm en mag
   in ons bestand. De XML zelf en de filterdefinities worden niet gekopieerd en niet
   regel-voor-regel overgezet — wij implementeren zelf, op onze eigen manier.
2. **Nooit "geverifieerd" zeggen zonder bron.** Elke API-aanroep die je in het
   reference-bestand noemt, check je eerst via de skill `revit-api-docs` tegen de
   documentatie van 2024 én 2027. Staat het er niet in, dan noteer je "niet
   geverifieerd" — je gokt niet en je leidt niets af uit de README van de repo.
3. **README's zijn geen bewijs.** "Tested with 2027, should work with earlier
   versions as well" is een aanname van de auteur. Stel versiegeldigheid vast door
   in de code te zoeken op de bekende breekpunten (§Stap 3), niet door de README
   te citeren.
4. **Geen generieke Revit-API-kennis opschrijven.** Conform de halfjaarlijkse
   pruning-regel: alleen niet-triviale patronen en SCI-relevante conclusies. Als
   een toekomstig model het zelf zou bedenken, hoort het er niet in.
5. **Niet in `W:` klonen** en niets naar `Snetselaar_BIM` committen. Werkmap is
   `%TEMP%\revit-repos\`; die is wegwerpbaar.
6. **Elke bevinding traceerbaar:** repo, commit-hash (kort), bestandspad,
   regelnummer. Zonder die vier hoort een bevinding niet in het bestand.

## Stap 0 — nulmeting

Lees eerst de skills `pyrevit-codestijl` en `sci-bim-context`, inclusief hun
references. Alles wat daar al staat is geen vondst meer. Zonder deze stap loopt §1
vol met patronen die wij al toepassen — de `.Value`-migratie, de transactie-opzet,
de inline XAML-dialoog — en dan is het bestand ruis in plaats van kennis.

Noteer voor jezelf één regel per onderwerp dat bij ons al is opgelost. Kom je
tijdens de extractie iets tegen dat daaronder valt, dan sla je het over, tenzij het
aantoonbaar beter is dan het onze; dan geldt stap 4b.

## Stap 1 — werkmap en clone

```bat
mkdir "%TEMP%\revit-repos" & cd /d "%TEMP%\revit-repos"
git clone --depth 1 https://github.com/<repo>.git
cd <repo> & git rev-parse --short HEAD
```

Faalt de clone op een certificaatfout, dan is dat de corporate SSL-inspectie:
`git config --global http.sslBackend schannel`.

Klonen mag ook overgeslagen worden voor de grote C#-repo's (`revit-ifc`,
`buildingSMART/IDS`) — daar is gericht `raw.githubusercontent.com` ophalen van de
paar bestanden die je nodig hebt sneller.

## Stap 2 — repo-lijst met wat je er zoekt

Werk in deze volgorde en stop bij een repo zodra de kolom "zoeken naar" is
afgehandeld. Budget: maximaal ~15 minuten per repo, dan afronden met wat je hebt.

| Prio | Repo | Zoeken naar |
|---|---|---|
| 1 | `m-wolin/PyRebar` | Het cross-version patroon voor `ElementId` (`hasattr(eid, "Value")`). Verder: de dubbeldetectie in `Query.panel/Audit.pushbutton/audit_script.py` (afgeronde bounding boxes, tolerantie ±1 mm) — beoordeel elke check daar apart op de vraag of hij als ModelCheck-check te formuleren is binnen ons result-contract. Ook: de eenheidsconversie in `lib/conversion.py` en de opzet van `Settings.pushbutton` met `lib/pyrebar_settings.py`. Let op: deze repo gebruikt een `lib/`-map, SCI werkt standalone — beschrijf het patroon, niet de mapstructuur. |
| 1 | `aiamkovoi/DimensionAuto` (`auto_dims_v5.py`, 1181 regels) | Vier dingen: (a) de zone-registratie die maatlijnen niet op elkaar laat stapelen, (b) collision-avoidance rond wanden/kolommen in het maatlijnpad, (c) de symbol→instance reference-conversie voor kolommen, (d) hoe "not parallel"-failures zonder dialoog worden afgevangen. Dit bestand gebruikt 13× `.IntegerValue` en breekt dus op 2026+ — noteer dat bij elk patroon dat je overneemt. |
| 1 | `RevitStandards/NLRS_ModelChecker` | Eén XML van 207 KB: **42 checks, 10 secties, 678 filters**, genummerd naar de NLRS-kapittels (3.1.0, 3.2.2, 3.2.3 …), met aparte checks voor onder meer Structural Foundations, Profiles, Tags en In-Place Families. Haal hieruit: wélke naamgevingschecks het normgremium per categorie nodig vindt, en welke filtercondities ze daarvoor gebruiken. **GPL v3** — zie de uitzondering bij grens 1. Bedoeld voor de Autodesk Interoperability Tools, niet voor pyRevit; de waarde zit in de checklijst, niet in het bestand. |
| 1 | `AnastasiiaBezruk/revit-model-health-checker` | Eén patroon, en dat is het belangrijkste van deze hele lijst: `lib/model_health/rules.py` bevat **geen enkele Revit-import**, alleen pure functies op `(id, value)`-paren, en wordt met `unittest` getest in GitHub Actions. Het verzamelen uit het model gebeurt in het pushbutton-script. Beschrijf hoe die scheiding precies loopt en wat dat betekent voor onze ModelCheck-registry en de testmatrix. Let op: `duplicate_groups` gebruikt bewust `lower()` in plaats van `casefold()` voor IronPython 2.7. |
| 1 | `khorn06/extensible-storage-pyrevit` | Declaratieve schema-klassen (`schema_builder.py`, `field_builder.py`) plus een context manager op de entity die de transactie zelf opent. Gebruikt `.format()`, dus IronPython-veilig. Relevant voor ProjectNotitie en elke volgende knop die data in het model moet vastleggen. Het is een `.lib`-extensie, wat tegen onze standalone-conventie in gaat — beschrijf het schemapatroon, niet de distributievorm. |
| 3 | `RevitStandards/NLRS_Revit_Settings` | Alleen registreren dat het bestaat: Revit-settingbestanden inclusief Assembly Codes en Keynotes. Raakt de SCI-template, niet de scripts. Geen extractie nodig. |
| 1 | `RAEN-DT/PyNetLibrary` (MIT, actief) | **De belangrijkste vondst voor het bouwtempo.** Stubcorpus van 15,3 MB: 8.788 klassen over 106 namespaces (`Autodesk.Revit.DB` 1.312, `Autodesk.Revit.DB.Structure` 237), met `_index/CLASSES.tsv` die per klasse namespace, bestand, regelbereik, basisklasse en aantal members geeft. En — dit is de kern — `01_Scripts/00_utils/GenerateStubs.py` plus `IndexStubs.py`, waarmee je het corpus **zelf per Revit-versie genereert**. Werk uit: (a) hoe je de stubs in de editor aanhaakt voor autocomplete en typecheck, (b) hoe je 2024, 2025, 2026 en 2027 los genereert en de `CLASSES.tsv`-diff gebruikt als geverifieerde breaking-change-lijst. Beide zijn **beschrijvingen, geen uitvoering**: `GenerateStubs.py` heeft een draaiende Autodesk-host met pythonnet nodig en valt daarmee buiten deze opdracht. Je legt de procedure vast, je genereert hier niets. Drie caveats die je verplicht overneemt: het meegeleverde corpus noemt **nergens** een Revit-versie, dus zelf genereren vóór je er iets op baseert; PyNET draait op pythonnet/CPython 3.10, dus de 113 meegeleverde referentiescripts zijn **niet** IronPython-compatibel — neem de stubs en de index, niet de scripts; en 163 klassenamen komen in meer dan één namespace voor, dus altijd op de namespace-kolom matchen. |
| 2 | `TrimbleSolutionsCorporation/TSOpenAPIExamples` + `TSOpenAPISelfLearning` | Officieel Trimble-materiaal voor de Tekla Open API, actief onderhouden. Voor de geplande vakwerkbematingstool. **Doe hier eerst één ding: stel vast dat de Open API .NET/C# is en geen Python-engine zoals pyRevit heeft.** Zolang niet besloten is of die tool een C#-plugin wordt of vanuit een andere route wordt aangestuurd, is diepere extractie zinloos. Noteer die keuze als openstaande vraag in §2. |
| 2 | `ADN-DevTech/revit-api-chms` + `DTDucas/chm-converter` | Samen sluiten ze een gat in grens 2. De eerste bevat alle `RevitAPI.chm`-bestanden vanaf 2012, de tweede zet die om naar Markdown met `file_index.json` en `id_lookup.json`. Daarmee wordt het verifiëren van een signatuur **offline en versie-exact** per 2024/2025/2026/2027, in plaats van afhankelijk van wat er online staat. Dit is de tegenhanger van `PyNetLibrary`: de stubs geven de signatuur, de CHM geeft het gedocumenteerde gedrag en de remarks. Werk uit hoe je die twee naast elkaar gebruikt en wat dat betekent voor de skill `revit-api-docs`. |
| 2 | `Autodesk/revit-ifc` | Alleen het exportergedrag dat onze datastandaard raakt: welke property sets standaard worden weggeschreven, hoe classificatie en `IFCExportConfiguration` samenhangen, en welke jaarversies nog fixes krijgen. Geen C#-architectuur uitpluizen. |
| 2 | `buildingSMART/IDS` + `buildingSMART/IDS-Audit-tool` | De facet-typen van de IDS-XSD en één werkend voorbeeldbestand. Doel is te kunnen beoordelen of onze datastandaard hierin uit te drukken is — nog geen IDS schrijven. |
| 3 | `dambinhtu-nhuy/revit-auto-tag` | Alleen het patroon "lees de al geplaatste tags in de view uit vóór je plaatst", en het verschil tussen `IndependentTag.Create` en `NewRoomTag`. Relevant voor de geplande 2D-wapeningstagger. |
| 2 | `AlejoDuarte23/pyrevit-structural-analysis-extension` | De enige vondst in vier rondes die de rekenmodelcontrole raakt. 986 regels over negen modules, geen f-strings. Twee dingen halen: (a) het exportschema van `AnalyticalMember` naar JSON — knopen, eindpunten, lokale assen, sectie (familie, type, vorm, numerieke eigenschappen), materiaal, scharnieren per uiteinde, constructieve rol, doorsnederotatie en de koppeling naar het fysieke element; dat is in de kern het uitwisselformaat dat je nodig hebt om tegen Technosoft/SCIA te vergelijken. (b) `host_match.py`: de heuristiek die een analytisch lid aan zijn fysieke drager koppelt — hoek ≤10°, middelpunt binnen 3× tolerantie, score ≤6× tolerantie. Beoordeel of die drempels voor onze modellen realistisch zijn. **Geen licentiebestand aanwezig**, dus conform grens 1 alleen beschrijven, niets overnemen. Let verder op: drie modules gebruiken `.IntegerValue`, en de Revit-imports zijn afgevangen met `try/except → object` zodat de module buiten Revit laadt. Vergelijk dat laatste expliciet met de aanpak van `revit-model-health-checker`, die de regellogica helemaal vrij van Revit houdt — noteer welke van de twee wij willen. |
| 3 | `Bouwtekening24/PyRevit-IFC-Parameter-Mapping` | Nederlandse pyRevit-tool die de IFC-parameter-mappingtabel bewerkt en de in-session exportconfiguratie bijwerkt. Raakt direct het stroomlijnen van de IFC-data. **Ik heb deze niet kunnen inzien** — geen README, repo niet op te halen binnen de tijd, en de licentie is niet vastgesteld. Doe dus eerst dat: licentie en inhoud vaststellen, en pas daarna beoordelen. Levert het niets op, dan afvoeren naar §3. |
| 3 | `IfcOpenShell/IfcOpenShell` | Uitsluitend `ifctester`: hoe je een IFC tegen een IDS valideert. Dit is CPython, dus het draait naast Revit en niet erin — noteer dat als randvoorwaarde. |
| 3 | `burnished-edge/pyRevit-AutoDismiss` | Klein, maar het legt een onderscheid bloot dat wij scherp moeten hebben: dit werkt via een `startup.py`-hook op `DialogBoxShowingEventArgs`, wat een **andere route** is dan de `IFailuresPreprocessor` die `DimensionAuto` gebruikt. Beschrijf wanneer welke van de twee hoort: dialogen onderscheppen versus failures binnen een transactie afhandelen. Ook bruikbaar: de aan/uit-toggle via `script.get_config()` met een pushbutton die de state flipt. Noteer expliciet het risico — een globale hook die dialogen wegklikt onderdrukt ook meldingen die je had willen zien, dus dit hoort in de testmatrix een hoog risicoprofiel te krijgen. |
| 3 | `OriAshkenazi/ai-pyrevit-developer-template` | Alleen de werkwijze, geen code: hoe een ander team een AI-ondersteunde pyRevit-ontwikkelstroom inricht met `AGENTS.md`, een plan-naar-taken-workflow en PowerShell-checks in CI die stale docs en ontbrekende statusupdates tegenhouden. Vergelijk met onze `CLAUDE.md`-opzet en de promotiepijplijn, en noteer alleen wat wij missen. |
| 3 | `QuanZ827/zexus` | Alleen het guardrail-concept: hoe een in-process Revit-agent begrenst wat er uitgevoerd mag worden. Relevant voor onze MCP-koppeling. C#, dus geen code overnemen — alleen het begrenzingsmodel beschrijven. |

Repo's die je **niet** hoeft te openen, en waarom (neem dit één-op-één over in §3
van het bestand): `Tereami/RebarSketch` en `RevitAreaReinforcement` zijn door de
auteur zelf op `zzz_OBSOLETE` gezet; `branch-danya-dev/revit-rebar-autodim` is
closed-source demo op .NET 8 en alleen 2025; `kristiangl/RevitSheetExporter` en de
Autodesk-Forge PDF-samples zijn C#/cloud en lopen achter op onze eigen PrintSheets;
op SCIA-koppeling is niets bruikbaars te vinden (`Koala` is Rhino/Grasshopper in
VB.NET uit 2022, de rest zijn losse eenmalige scripts) — de Technosoft-route blijft
dus voorlopig eigen werk. Verder zoekwerk zonder opbrengst, ook vastleggen zodat het
niet opnieuw gedaan wordt: Revit↔Excel-parameterrondgang (de Autodesk Design
Automation-samples zijn deprecated en cloud-only), staalspecifieke repo's (alles C#,
eenmalig of leeg), waarschuwingsbeheer buiten `AutoDismiss` om, en het overhalen van
raam- en deuropeningen uit een gekoppeld model — daar staat niets op GitHub, dus die
knop blijft eigen werk. Buiten `PyNetLibrary` bestaat er ook geen ander
stubbenproject voor de Revit API.

Ook onderzocht en bewust niet opgenomen: `pyrevitlabs/telemetry-server` is de
officiële telemetrieroute, maar die vraagt een serverdeployment en vervángt onze
JSONL-toollog in plaats van hem aan te vullen — pas relevant als we ooit centraal
willen verzamelen. Er zijn inmiddels meerdere alternatieve MCP-implementaties voor
Revit 2023–2027 (`horizun-revit-mcp`, `BIM-Bot`); onze koppeling werkt, dus die
worden pas interessant als we ergens op vastlopen. Voor BIM basis ILS bestaat geen
bruikbare repo: `Teun1/...Nederlandse-BIM-standaarden` is een ZIP-blob uit 2019 onder
een niet-commerciële licentie, en `Root-bv/Solibri-ruleset-BIM-basisILS` is een
Solibri-ruleset uit 2023, geen Revit. Modelvergelijking op elementniveau
(`RevitDiff`, Speckle) is een eigen platformkeuze en geen extractiemateriaal.

## Stap 3 — versiegeldigheid vaststellen

Grep per repo op de bekende breekpunten en noteer de uitkomst per patroon:

```bash
grep -rn "IntegerValue" --include=*.py .
grep -rnE 'f"[^"]*\{|f'"'"'[^'"'"']*\{' --include=*.py .   # f-strings: breekt IronPython 2.7
grep -rn "pathlib\|DisplayUnitType\|UnitTypeId\|ForgeTypeId" --include=*.py .
grep -rn "HOST_APP\|VersionNumber" --include=*.py .          # bestaande versie-guards
```

Conclusie per patroon in één van drie vormen: **werkt 2024–2027 ongewijzigd**,
**werkt na aanpassing X**, of **niet bruikbaar omdat Y**. Geen vierde categorie.

## Stap 4 — wegschrijven

Nieuw bestand `pyrevit-codestijl/references/externe-patronen.md`, in het
Nederlands, met deze drie secties:

**§1 Patronen (het inhoudelijke deel).** Per patroon:

```
### <korte naam>
- **Bron:** <repo>@<commit> — <pad>:<regel>
- **Licentie:** <licentie> → overnemen mag / alleen beschrijven
- **Probleem:** <wat het oplost, in één regel>
- **Helpt bij:** <welke SCI-knop uit de lens hier verder komt — verplicht veld>
- **Patroon:** <max 15 regels code, herschreven in SCI-stijl, geen copy-paste>
- **Geldig op:** 2024 / 2025 / 2026 / 2027 — <hoe vastgesteld>
- **Advies:** overnemen / aanpassen / links laten liggen — <waarom>
```

Kun je het veld **Helpt bij** niet invullen, dan is het patroon interessant maar
niet nuttig. Dat hoort in §2, niet in §1.

**§2 Openstaande vragen.** Alles wat je niet hebt kunnen verifiëren, met de
concrete vraag erbij. Dit is de werklijst voor de volgende ronde, geen vergaarbak.

**§3 Repo-register.** Eén tabel: repo, laatste commit die je zag, licentie, en een
oordeel in één regel over blijvende relevantie. Hierop wordt bij de volgende
pruning besloten of een repo eruit mag.

**Stap 4b — een patroon dat beter is dan het onze.** Dit is de waardevolste uitkomst
van de hele opdracht en hij gaat verloren zodra je hem als gewoon patroon opschrijft.
Werkt een externe aanpak beter dan wat er nu in `01_SCI` staat, dan noteer je erbij:
welk bestand en welke functie het bij ons nu doet, wat er concreet beter is, en wat de
omzetting ongeveer kost. Eén harde beperking: zo'n notitie is een voorstel, geen
wijziging. Het landt als kandidaat in `03_R&D` en loopt daarna de normale
promotiepijplijn. `01_SCI` raak je in deze opdracht niet aan.

Tot slot één regel toevoegen aan de index van `pyrevit-codestijl/SKILL.md` die naar
het nieuwe bestand verwijst, in dezelfde stijl als de bestaande verwijzingen.

## Wat er expliciet níét in het bestand komt

- Geen patronen die de SCI-conventies tegenspreken (standalone-scripts, inline
  helpers, `__version__` + `Versie:`-regel). Wijkt een externe repo daarvan af, dan
  is dat een observatie voor §2, geen advies om onze conventie te wijzigen.
- Niets in `sci-bim-context` — dat is voor hoe SCI het zelf doet, niet voor externe
  bronnen.
- Geen vakinhoudelijke uitspraken over wapening, bematingsregels of
  categorie-indeling. Die liggen bij SCI vast en zijn hier niet in scope.
