---
titel: Bruikbare patronen uit externe Revit-repo's (Prio-1-ronde)
status: concept
laatst-bijgewerkt: 2026-09-17
bronnen:
  - "C:\\Users\\S-WOU1A\\Downloads\\kennisextractie-externe-revit-repos.md (opdracht, 2026-09-14; nog niet in raw/, zie Bronnen en notities)"
  - "github.com/m-wolin/PyRebar@3e77de8 (GPL v3)"
  - "github.com/aiamkovoi/DimensionAuto@f038f8f (MIT)"
  - "github.com/RevitStandards/NLRS_ModelChecker@b8d738e (GPL v3)"
  - "github.com/AnastasiiaBezruk/revit-model-health-checker@f007888 (MIT)"
  - "github.com/khorn06/extensible-storage-pyrevit@1ddeff0 (geen licentie)"
  - "github.com/RAEN-DT/PyNetLibrary@ebad0d5 (MIT)"
  - "raw/2026-08-31-uitgebreide-transcriptie-ai-bim-revit-automation-.md §1, deel Ethiek en licenties (Gavin Nicholls)"
  - "revitapidocs.com 2024 en 2027 (failure-API, SchemaBuilder, Rebar.DoesBarExistAtPosition — GUID-truc, 2026-09-14)"
verwant:
  - rebar-api-parameters.md
  - nlrs-en-bim-standaarden.md
skill: pyrevit-codestijl
---

# Bruikbare patronen uit externe Revit-repo's (Prio-1-ronde)

Statische leesronde langs zes publieke repo's, met als lens: welke openstaande
SCI-knop komt hier concreet verder. Dit is bewust een wiki-concept, geen
skill-tekst. Externe research met deels onzekere bronnen hoort in het promotiepad
(`raw → wiki → skill`), niet direct in een distributie-artefact — pas als een
patroon stabiel blijkt en tweemaal is opgekomen, gaat het via `/kb-promoveer` naar
`pyrevit-codestijl`. De oorspronkelijke opdracht mikte op een skill-references-
bestand; dat is hier bewust omgezet.

Alle codevoorbeelden zijn herschreven in SCI-stijl, geen copy-paste. Bij
GPL-repo's en repo's zonder licentie wordt alleen het idee beschreven, conform de
grens "licentie vóór inhoud".

Die grens bewaakt de mens, niet de AI. Gavin Nicholls stelt dat AI zich weinig
aantrekt van licenties, ook als de licentietekst in de aangeleverde code staat,
en Nick (BIM Pure) beschrijft het gangbare "plak een GitHub-link in Claude Code
en laat het herbouwen" (`raw/2026-08-31-uitgebreide-transcriptie-ai-bim-revit-automation-.md` §1). Daarom is de licentie hier per repo
vóór het lezen vastgesteld (zie Repo-register), en niet aan het model overgelaten.

### Bronnen en notities

- Namen in backticks zonder `.md`, zoals `align-lock-overconstraint` of
  `revit-api-verifieren-lokaal`, verwijzen naar notities in het werkgeheugen van
  Claude, buiten deze kennisbank. Ze zijn context, geen bron in de zin van
  `kennisbank/CLAUDE.md` §6.
- De opdracht waaruit deze ronde ontstond staat nog in de Downloads-map, niet in
  `raw/`. Zolang hij daar staat, kan hij verdwijnen en daarmee de herkomst van de
  prioritering.

## Verificatiestatus (2026-09-14)

De dragende API-aanroepen zijn met de GUID-truc opgezocht in exact 2024 en 2027
(zelfde GUID-bestandsnaam laadt in beide jaren = signatuur ongewijzigd). Geen van
de gecontroleerde aanroepen is tussen 2024 en 2027 gewijzigd — negatieve kennis,
maar het betekent dat de failure- en Extensible-Storage-patronen versiebreed
bruikbaar zijn zonder guard.

**Geverifieerd — met opgehaalde documentatiepagina (2024 én 2027):**

| Aanroep | Signatuur | Bron (2024/2027, wissel het jaartal) |
|---|---|---|
| `IFailuresPreprocessor.PreprocessFailures(FailuresAccessor)` | → `FailureProcessingResult` | `revitapidocs.com/2024/053c6262-d958-b1b6-44b7-35d0d83b5a43.htm` |
| `FailuresAccessor` | `GetFailureMessages`, `DeleteWarning`, `DeleteElements`, `ResolveFailure` aanwezig | `.../dea68b06-a061-fc05-d814-db741f2e7f14.htm` |
| `FailureHandlingOptions.SetFailuresPreprocessor(IFailuresPreprocessor)` | → `FailureHandlingOptions` | `.../0647c18e-c1ad-60b8-d993-cb464b7b676e.htm` |
| `Transaction.SetFailureHandlingOptions(FailureHandlingOptions)` | → `void` | `.../1e913cca-f75b-8dfb-b172-5a04f3732b85.htm` |
| `SchemaBuilder` | `SetSchemaName`, `SetReadAccessLevel`, `SetWriteAccessLevel`, `SetVendorId`, `AddSimpleField`, `AddArrayField`, `AddMapField`, `Finish` aanwezig | `.../089b1bd6-ea63-f98e-c3c6-3ef1277d0497.htm` |
| `Rebar.DoesBarExistAtPosition(int)` | → `bool`, index 0..`NumberOfBarPositions`-1 | `.../f223b762-1ef9-bf37-29e3-202dd570edb8.htm` |

Eén ES-toevoeging (geen breuk): `AddSimpleField` accepteert sinds 2024 ook
`System.Int64`, passend bij de 64-bit `ElementId` (`revitapidocs.com/2024/news`).

**Aangenomen — niet in deze ronde opgezocht:** `FilteredElementCollector`,
`Dimension.References`, `Reference.ElementId`, `Element.get_BoundingBox`,
`Rebar.GetHostId`, `Element.IsHidden` (standaard en stabiel, maar niet met een
URL bevestigd); de pyRevit-helpers `output.linkify`/`print_table` (geen Revit-API);
en `ExtensibleStorage.Schema.Lookup`/`Entity`/`DataStorage.Create` (de namespace
bestaat in 2024–2027, de losse members zijn niet apart opgehaald). Het breekpunt
`ElementId.IntegerValue` → `.Value` (2026) ligt al vast in `pyrevit-codestijl` en
`revit-api-verifieren-lokaal`.

## 1. Revit-vrije regelmodule met unittest in CI

- **Bron:** revit-model-health-checker@f007888 — `ModelHealth.extension/lib/model_health/rules.py`, `tests/test_rules.py`, `.github/workflows/tests.yml`
- **Licentie:** MIT → overnemen mag
- **Helpt bij:** ModelCheck-registry én de testmatrix — dit dicht het gat dat de matrix nu handmatig vult.
- **Probleem:** checklogica die Revit importeert is buiten Revit niet te testen.

De regelmodule bevat geen enkele Revit-import, alleen pure functies op
`(id, waarde)`-paren. Het pushbutton-script verzamelt uit het model en roept de
regelmodule aan; de regels weten niets van de Revit API. Daardoor draait
`python -m unittest` in GitHub Actions op CPython 3.8 en 3.12, zonder Revit.

```python
# IronPython 2.7-veilig: geen imports, lower() i.p.v. casefold()
def dubbele_groepen(paren, hoofdlettergevoelig=False):
    """paren = iterable van (id, waarde). Geeft {toonwaarde: [id, ...]}
    voor waarden die minstens tweemaal voorkomen."""
    verzameld = {}
    toon = {}
    for identifier, waarde in paren:
        w = (waarde or "").strip()
        if not w:
            continue
        sleutel = w if hoofdlettergevoelig else w.lower()
        verzameld.setdefault(sleutel, []).append(identifier)
        toon.setdefault(sleutel, w)
    return dict((toon[k], ids) for k, ids in verzameld.items() if len(ids) > 1)
```

- **Geldig op:** 2024–2027 ongewijzigd. De module raakt de API niet; `lower()` is
  bewust gekozen boven `casefold()` voor IronPython 2.7.
- **Advies:** overnemen. Dit is het waardevolste patroon van de ronde. Onze
  ModelCheck-checks (memory `modelcheck-tool`) kunnen langs deze lijn gesplitst
  worden in een verzamelaar (Revit) en een toetser (puur), waarna de toetser in CI
  test. Zie de vergelijking met de tegenovergestelde aanpak in Openstaande vragen, vraag 1.

> **Bijvangst: element-link zonder versie-guard.** Dezelfde repo lost de `.Value`/
> `.IntegerValue`-splitsing praktisch op met een drietrapsval:
> `output.linkify(id)` → bij fout `str(id.Value)` → bij fout `str(id.IntegerValue)`.
> Klein, maar het maakt één helper die op 2024–2027 werkt zonder versie-guard.

## 2. Dubbeldetectie via afgeronde bounding-box-signatuur

- **Bron:** PyRebar@3e77de8 — `pyRebar.tab/Query.panel/Audit.pushbutton/audit_script.py:100-117`
- **Licentie:** GPL v3 → alleen beschrijven, niets overgenomen.
- **Helpt bij:** ModelCheck — kandidaat-check voor per ongeluk gekopieerde/gearrayde elementen.
- **Probleem:** exact op elkaar liggende duplicaten zijn visueel onzichtbaar.

De audit bouwt per staaf een signatuur en groepeert gelijke signaturen. De
signatuur is `(host-id, diameter, aantal barposities, afgeronde bbox-min,
afgeronde bbox-max)`, met de bbox-coördinaten afgerond op een tolerantie (in de
bron ±1 mm). Twee elementen met dezelfde signatuur zijn vermoedelijk een
dubbel. De aanpak is categorieneutraal: dezelfde signatuur (zonder de
rebar-specifieke velden) werkt voor kolommen, balken of funderingen.

- **Geldig op:** het idee is versieneutraal. De bron gebruikt de bounding box van
  het element (`Element.get_BoundingBox`). [ONBEVESTIGD] Of die bij een
  geroteerde family-instance asgericht in modelcoördinaten staat; niet opgezocht.
  Wie in plaats daarvan `Solid.GetBoundingBox` gebruikt, krijgt een box in het
  assenstelsel van de solid, niet in projectcoördinaten (memory
  `solid-boundingbox-transform`).
- **Advies:** overnemen als *idee* (GPL blokkeert de code). Past in het
  result-contract van ModelCheck: per groep een lijst element-id's + één
  toonwaarde.

## 3. Overige PyRebar-audit-checks als ModelCheck-kandidaten

- **Bron:** PyRebar@3e77de8 — `audit_script.py:132-162`
- **Licentie:** GPL v3 → alleen beschrijven.
- **Helpt bij:** ModelCheck-registry.

Vier read-only checks die één-op-één als registry-check te formuleren zijn:
staaf korter dan een ondergrens, staaf langer dan een bovengrens, "Keep
Straight" met een shape die niet recht is, en verborgen staaf in de actieve view
(`IsHidden(view)`). Elke check levert een lijst `(id, bar-nummer, partition)`.

- **Geldig op:** 2024–2027 geverifieerd. `Rebar.DoesBarExistAtPosition(int) → bool`
  (index 0..`NumberOfBarPositions`-1) laadt identiek in 2024 en 2027 — zie
  Verificatiestatus en `rebar-api-parameters`. `IsHidden`/`GetHostId` aangenomen,
  niet apart opgehaald.
- **Advies:** overwegen. De lengtegrenzen zijn projectafhankelijk en horen
  configureerbaar, niet hardgecodeerd zoals in de bron.

## 4. Zone-registratie en AABB-collision-avoidance voor maatlijnen

- **Bron:** DimensionAuto@f038f8f — `auto_dims_v5.py:774-833`
- **Licentie:** MIT → overnemen mag.
- **Helpt bij:** AutoDim Sectie Y en elke bematingsuitbreiding — voorkomt dat maatlijnen op elkaar stapelen.
- **Probleem:** meerdere maatketens op dezelfde perpendiculaire positie overlappen.

Elke geplaatste maatlijn wordt geregistreerd als een rechthoek
`(lo_x, lo_y, hi_x, hi_y)` in een lijst `bezet`. Vóór plaatsing schuift de
perpendiculaire positie met een vaste stap tot de nieuwe rechthoek geen enkele
bezette rechthoek meer raakt (axis-aligned overlaptest).

```python
# IronPython 2.7. bezet = lijst van (lo_x, lo_y, hi_x, hi_y)
def overlapt(rechthoek, bezet):
    for b in bezet:
        if rechthoek[2] <= b[0] or b[2] <= rechthoek[0]:
            continue
        if rechthoek[3] <= b[1] or b[3] <= rechthoek[1]:
            continue
        return True
    return False
```

- **Geldig op:** de zonelogica is puur rekenwerk, 2024–2027 ongewijzigd. **Let op:**
  het omringende script telt 13× `.IntegerValue` (o.a. `auto_dims_v5.py:848,866`)
  en breekt daardoor op 2026+. Neem de zonelogica over, niet de collector-code
  eromheen.
- **Advies:** overnemen. Sluit aan op de rijraster-aanpak van AutoDim Sectie Y
  (`autodim-sectie-y-layout`): daar ligt het 120 mm-raster vast, hier komt de
  botsingsuitwijking bovenop.

## 5. Failures binnen een transactie afvangen zonder dialoog

- **Bron:** DimensionAuto@f038f8f — `auto_dims_v5.py:41-69`
- **Licentie:** MIT → overnemen mag.
- **Helpt bij:** elke modelbewerkende knop die anders op een blokkerende Revit-melding vastloopt.
- **Probleem:** een "not parallel"-fout bij `Dimension.Create` opent een dialoog en breekt een batch af.

Een `IFailuresPreprocessor` op de `FailureHandlingOptions` van de transactie
vangt de melding af: bij een error de veroorzakende elementen verwijderen of de
failure oplossen, bij een warning `DeleteWarning`. Retourneer
`FailureProcessingResult.Continue`. De preprocessor wordt vóór de commit gekoppeld:

```python
# IronPython 2.7. Geverifieerde keten, zie Verificatiestatus.
class MaatlijnFailureSwallower(IFailuresPreprocessor):
    def PreprocessFailures(self, fa):
        for f in fa.GetFailureMessages():
            if f.GetSeverity() == FailureSeverity.Warning:
                fa.DeleteWarning(f)          # alleen deze whitelisten
        return FailureProcessingResult.Continue

t = Transaction(doc, "Bemating")
t.Start()
opts = t.GetFailureHandlingOptions()
opts.SetFailuresPreprocessor(MaatlijnFailureSwallower())
t.SetFailureHandlingOptions(opts)
# ... plaats maatlijnen ...
t.Commit()
```

Dit is een andere route dan een globale `startup.py`-dialooghook
(`DialogBoxShowingEventArgs`, à la pyRevit-AutoDismiss): de preprocessor werkt
binnen de transactie en alleen op wat die transactie veroorzaakt. Een globale
hook onderdrukt óók meldingen die je had willen zien — dat botst met de
SCI-afspraak dat constraint-waarschuwingen nooit blind weggeklikt worden
(`align-lock-overconstraint`). Voorkeur dus: preprocessor binnen de transactie,
geen globale dialooghook.

- **Geldig op:** 2024–2027 geverifieerd. De hele keten (`PreprocessFailures`,
  `FailuresAccessor.GetFailureMessages`/`DeleteWarning`/`DeleteElements`/
  `ResolveFailure`, `SetFailuresPreprocessor`, `SetFailureHandlingOptions`) laadt
  identiek in 2024 en 2027 — zie Verificatiestatus. Geen breaking change.
- **Advies:** overnemen, mét een expliciete whitelist van welke failures
  weggenomen mogen worden. Nooit alle errors blind verwijderen — dat botst met
  `align-lock-overconstraint` (constraint-waarschuwingen nooit blind wegklikken).

## 6. Idempotente plaatsing: lees bestaande elementen eerst

- **Bron:** DimensionAuto@f038f8f — `auto_dims_v5.py:840-868` (`_grid_chain_exists`)
- **Licentie:** MIT → overnemen mag.
- **Helpt bij:** bematingsscript én de geplande 2D-wapeningstagger.
- **Probleem:** herhaald draaien plaatst dubbele maatlijnen of tags.

Vóór plaatsing verzamelt het script alle `Dimension`s in de view en vergelijkt
per maatlijn de verzameling gerefereerde element-id's met de gewenste set. Bestaat
er al een keten tussen dezelfde stramienen, dan wordt niet opnieuw geplaatst. Dit
is hetzelfde "lees eerst wat er staat"-patroon dat de 2D-wapeningstagger nodig
heeft: eerst de reeds geplaatste tags in de view uitlezen, dan pas plaatsen.

- **Geldig op:** de collector gebruikt `.IntegerValue` (2026-breekpunt); vervang
  door `.Value`-veilige uitlezing. Logica zelf versieneutraal.
- **Advies:** overnemen als vast voorportaal van elke plaatsingsknop.

## 7. Declaratief Extensible-Storage-schema met transactie-context-manager

- **Bron:** extensible-storage-pyrevit@1ddeff0 — `extensible_storage.lib/extensible_storage/{schema.py,__init__.py:100-135}`
- **Licentie:** geen licentiebestand → alleen beschrijven, niets overgenomen.
- **Helpt bij:** ProjectNotitie en elke knop die data in het model vastlegt.
- **Probleem:** Extensible Storage met de kale API is veel boilerplate en foutgevoelig rond transacties.

Een schema wordt declaratief gedefinieerd als een klasse met velden als
descriptors; een metaclass (`__metaclass__ = SchemaMeta`, de Py2-vorm, dus
IronPython-veilig) leest de GUID en bouwt het `Schema`-object lui op. De entity is
een context manager: `with MijnSchema(element) as entity:` opent bij `__exit__`
zelf een `revit.Transaction` en schrijft de entity weg. Gebruikt `.format()`, geen
f-strings.

- **Geldig op:** `SchemaBuilder` is 2024–2027 geverifieerd, inclusief de verplichte
  aanroepvolgorde (`SetSchemaName` + `SetReadAccessLevel` + `SetWriteAccessLevel`
  vóór `Finish`) — zie Verificatiestatus. `AddSimpleField` accepteert sinds 2024 ook
  `Int64`. De losse members `Schema.Lookup`/`Entity`/`DataStorage.Create` zijn niet
  apart opgehaald (namespace bestaat wel in 2024–2027). [ONBEVESTIGD] blijft: of de
  metaclass + descriptor-combinatie ongewijzigd draait op onze IronPython 2.7 — dat
  is runtime-gedrag, geen doc-signatuur, en moet op de werkplek getest worden.
- **Advies:** het schema-idee overnemen (zelf implementeren, geen licentie om te
  kopiëren), de metaclass-laag met terughoudendheid — die botst met de
  standalone-conventie en voegt magie toe die bij één schema niet loont. Voor
  ProjectNotitie kan de transactie-context-manager los nuttig zijn.

## 8. NLRS-naamgevingschecklijst als registry-blauwdruk

- **Bron:** NLRS_ModelChecker@b8d738e — `NLRS_RevitModelChecker.xml`
- **Licentie:** GPL v3 → de checklijst is feitelijke informatie over een
  gepubliceerde norm en mag; de XML en de filterdefinities worden niet gekopieerd.
- **Helpt bij:** ModelCheck-registry — welke naamgevingschecks het normgremium per categorie nodig vindt.
- **Probleem:** wij bepalen ad hoc welke categorieën een naamcontrole krijgen.

De standaard definieert 42 checks over 10 secties, genummerd naar de
NLRS-kapittels. Hoofdstuk 3 (Naming Conventions) splitst per categorie, met eigen
checks voor onder meer Loadable Families, System Families, In-Place Families,
Structural Foundations, Profiles, Detail Components, Area Schemes, Assemblies,
Railings, Stairs, en apart Annotation Symbols, Tags, Symbols, Title Blocks, Fill
Patterns, Line Styles, Text/Dimension Styles. Verder: Materials (H4), Assembly
Codes (H5), Object Styles (H6), Project Coordinates (H7), Shared Parameters (H8).

- **Geldig op:** dit is een norm, geen API — versieneutraal. De structuur is
  bedoeld voor de Autodesk Interoperability Tools, niet voor pyRevit; de waarde zit
  in de checklijst, niet in het bestand.
- **Advies:** de voor SCI relevante checks overnemen als registry-regels, met onze
  eigen NLRS/SCI-naamconventie als toetssteen (`nlrs-code-als-classificatie`). De
  filtercondities zelf implementeren wij, niet overzetten.

## 9. Per-versie API-stubs en CLASSES.tsv-diff als breaking-change-lijst

- **Bron:** PyNetLibrary@ebad0d5 — `02_PyNet Stubs/_index/CLASSES.tsv` (8788 klassen), `01_Scripts/00_utils/{GenerateStubs.py,IndexStubs.py}`
- **Licentie:** MIT → overnemen mag; hier alleen de procedure beschreven, want genereren vergt een draaiende Autodesk-host.
- **Helpt bij:** sneller schrijven met autocomplete, én versieverschillen hard vaststellen in plaats van per geval de docs nalopen.
- **Probleem:** breaking changes tussen 2024–2027 worden nu handmatig ontdekt.

`GenerateStubs.py` leest via reflectie de geladen Revit-assemblies uit en schrijft
`.py`-stubs per namespace; `IndexStubs.py` bouwt daarvan `CLASSES.tsv` met per
klasse namespace, bestand, regelbereik, basisklasse en aantal members. Genereer je
2024, 2025, 2026 en 2027 los, dan is de diff van de vier `CLASSES.tsv`-bestanden
een geverifieerde lijst van verdwenen/gewijzigde klassen. De stubs haak je in de
editor aan voor autocomplete en typecheck.

Drie verplichte caveats, in de bron bevestigd:
- Het meegeleverde corpus noemt nergens een Revit-versie (grep leeg) — zelf
  genereren vóór je er iets op baseert.
- De generator draait op pythonnet/CPython (`import pathlib`,
  `Application.VersionNumber`), niet IronPython. Neem de stubs en de index, niet de
  113 meegeleverde scripts.
- 163 klassenamen komen in meer dan één namespace voor — altijd op de
  namespace-kolom matchen.

- **Geldig op:** procedure, geen runtime-code voor ons lint. De diff-uitkomst is
  per definitie versie-exact.
- **Advies:** links laten liggen als runtime, overnemen als werkwijze. Dit is
  de tegenhanger van onze `tools/check_versies.py` (MetadataLoadContext op de vier
  RevitAPI.dll's, `revit-api-verifieren-lokaal`): die doet in feite al een
  vergelijkbare diff zonder draaiende host. Beoordeel of de TSV-vorm iets toevoegt
  boven wat `check_versies.py` nu meet — zo niet, dan is dit een dood spoor. Zie Openstaande vragen, vraag 3.

## Openstaande vragen

1. **Regelmodule-scheiding vs. onze ModelCheck.** Patroon 1 houdt de regellogica
   volledig Revit-vrij; het alternatief (structural-analysis-extensie, niet in
   deze ronde geopend) vangt de imports af met `try/except → object` zodat de
   module buiten Revit laadt maar de logica wél API-types kent. Welke van de twee
   past op onze ModelCheck-registry (memory `modelcheck-tool`)? Vereist een blik op wat 03_R&D nu doet.
   Kandidaat voor stap-4b (verbetering t.o.v. bestaand), niet in deze ronde te
   beslissen zonder 01_SCI/03_R&D te lezen.
2. **API-verificatie grotendeels gedaan (2026-09-14).** De failure-keten,
   `SchemaBuilder` (met aanroepvolgorde) en `Rebar.DoesBarExistAtPosition` zijn in
   2024 én 2027 opgezocht — zie Verificatiestatus. Rest voor een volgende ronde:
   de losse ES-members (`Schema.Lookup`, `Entity`, `DataStorage.Create`,
   `Element.GetEntity`/`SetEntity`) en de collector-/geometrie-aanroepen die nu op
   "aangenomen" staan. Runtime-open: de metaclass-laag van patroon 7 op onze
   IronPython 2.7.
3. **PyNetLibrary vs. `check_versies.py`.** Voegt de stub/TSV-diff iets toe boven
   onze bestaande MetadataLoadContext-check? Zonder antwoord blijft patroon 9 een
   beschrijving, geen actie.
4. **Nog niet geopend uit de opdracht.** De Prio-2/3-repo's (revit-ifc, IDS,
   revit-auto-tag, structural-analysis-extensie, TSOpenAPIExamples, CHM-converters,
   AutoDismiss, IfcOpenShell/ifctester, zexus) zijn deze ronde overgeslagen — de
   keuze was Prio-1 + wiki. Structural-analysis (rekenmodelcontrole) en
   revit-auto-tag (2D-wapeningstagger) zijn de sterkste openstaande kandidaten.

## Repo-register

| Repo | Gezien commit | Licentie | Oordeel |
|---|---|---|---|
| m-wolin/PyRebar | 3e77de8 | GPL v3 | Blijvend relevant voor ModelCheck-checks (dubbeldetectie, lengte, verborgen). GPL: alleen ideeën, geen code. |
| aiamkovoi/DimensionAuto | f038f8f | MIT | Meest bruikbaar voor bemating: zonelogica, failure-preprocessor, idempotentie. Breekt zelf op 2026 (`.IntegerValue`). |
| RevitStandards/NLRS_ModelChecker | b8d738e | GPL v3 | Checklijst is de waarde, niet de XML. Norm-referentie, verandert traag. |
| AnastasiiaBezruk/revit-model-health-checker | f007888 | MIT | Belangrijkste patroon (Revit-vrije regels + CI). Klein, stabiel, herbruikbaar. |
| khorn06/extensible-storage-pyrevit | 1ddeff0 | geen | Idee bruikbaar voor ProjectNotitie; geen licentie, dus niets kopiëren. Metaclass botst met standalone-conventie. |
| RAEN-DT/PyNetLibrary | ebad0d5 | MIT | Werkwijze (per-versie stubs + TSV-diff), geen runtime. Overlapt mogelijk met `check_versies.py`. |

De werkmap `%TEMP%\revit-repos` is wegwerpbaar. Volgende ronde: vergelijk deze
commit-hashes met de dan-actuele `HEAD` en werk alleen gewijzigde repo's bij.
