---
type: healthcheck
datum: 2026-08-31
omvang: 13 wiki-artikelen
---

# Health check 2026-08-31

**Artikelen:** 13, alle `status: concept` (4 nieuw sinds de vorige check op
2026-08-28).
**Bevindingen:** 2 tegenstrijdigheden (1 wiki-vs-skill, 1 wiki-vs-wiki) · 0
ongemarkeerde claims · 3 gaten (waarvan 1 een gemiste sectie uit de zojuist
verwerkte bron) · 0 verouderd (>90 dagen), maar 1 artikel waarvan de
methodiek is drooggevallen door een wijziging elders · 0 stijlovertredingen ·
6 kapotte kruisverwijzingen (2 zonder tekstuele grond, 4 eenzijdig maar wel
gegrond) · coverage niet volledig (1 sectie gemist).
**Ernstigste punt:** de skillbron `sci-bim-context/references/template-en-mcp.md`
§C noemt `execute_revit_code` nog als bestaande, actieve tool ("twintig
stuks"). Die route is op 2026-08-31 uit de repo verwijderd. Wie in een gesprek
op de skill afgaat, krijgt een tool voorgeschoteld die niet meer bestaat. Dit
is geen wiki-fout — de wiki (`mcp-revit-koppeling.md` §4) documenteert de
verwijdering correct — maar een ontbrekend conflictblok volgens
`CLAUDE.md` §3 regel 2.

Dit is de derde check. Sinds de vorige zijn er vier artikelen bijgekomen uit
één grote bron, en is buiten `/kb-verwerk` om een route uit de repo
verwijderd. Beide gebeurtenissen op dezelfde dag verklaren waarom deze check
meer vindt dan de vorige: nieuw werk onder tijdsdruk laat meer sporen na dan
gestaag onderhoud.

---

## 1. Tegenstrijdigheden

### Tussen wiki en skill — nieuw, niet eerder gemeld

| | |
|---|---|
| Waar | `Snetselaar_BIM/sci-bim-context/references/template-en-mcp.md` §C (regel 55, 76, 80) tegenover `wiki/mcp-revit-koppeling.md` §4 |
| Wat de skill zegt | "Twintig stuks" tools, met `execute_revit_code` — "Willekeurige IronPython in de Revit-context" — als rij in de tabel en als de route waar worksets, warnings, project units en parameterwaarden per element-id doorheen moeten. |
| Wat de wiki zegt | `execute_revit_code` is op 2026-08-31 volledig verwijderd, met een uitgeschreven reden (access violations zonder sandbox/transactie) en een doorgestreepte tabelrij. |
| Welke kant | De wiki heeft hier de nieuwere, geverifieerde bron — een live verwijdering op de eigen werkplek, niet een aanname. De skill moet volgen, niet de wiki. |
| Bronketen | `memory.md`, regel 2026-08-31 (live-debugsessie, PID 19100). |

Volgens `CLAUDE.md` §3 regel 2 hoort hier een `> **Conflict met skill
sci-bim-context:**`-blok in de wiki te staan, net als bij de eerdere
toolnamen-discrepantie in §6 van hetzelfde artikel. Dat blok ontbreekt nu.
Praktisch gevolg: elke sessie die de skill leest (niet alleen de kennisbank)
kan naar een niet-bestaande route verwijzen — groter bereik dan een gewone
wiki-tegenstrijdigheid.

### Tussen wiki-artikelen onderling — nieuw

`mcp-versus-custom-tools.md` §3 schrijft: *"Dit is woordelijk de eerste
SCI-werkafspraak. `sci-bim-context` §1: niet overcompliceren, check eerst of
Revit het native kan..."* Maar in `sci-bim-context/SKILL.md` §1 is dat
werkafspraak **nummer 2** ("Niet overcompliceren"), niet nummer 1 ("Onderbouwd
vóór presenteren"). `revit-bronnen-en-communities.md` §2 citeert dezelfde regel
correct als *"de tweede werkafspraak van SCI"* — de twee wiki-artikelen spreken
elkaar dus letterlijk tegen over hetzelfde feit, en één van de twee (`mcp-versus-custom-tools.md`)
klopt niet met de skill zelf.

**Voorstel:** in `mcp-versus-custom-tools.md` §3 "eerste" vervangen door
"tweede". Klein, ondubbelzinnig, geen inhoudelijke keuze nodig.

### Al bekend, nog steeds terecht gemarkeerd als historisch

De acht-toolnamen-discrepantie in `mcp-revit-koppeling.md` §6 (skill
gecorrigeerd en geüpload op 2026-08-28) blijft correct als afgehandeld
gemarkeerd. Geen actie.

## 2. Claims zonder bron

Geen ongemarkeerde feitelijke bewering aangetroffen in de vier nieuwe
artikelen of de vier bijgewerkte. Elke claim draagt een verwijzing naar het
raw-bestand, een sectie daarin, een levende meting, of een `[ONBEVESTIGD]`.

Twee kanttekeningen bij bestaande markeringen, niet nieuw maar het narekenen
waard:

- `ai-tools-voor-pyrevit-ontwikkeling.md` §1 markeert de houdbaarheid van het
  gratis Ox Alpha-model terecht als tijdelijk, met datum. Dit is een claim die
  **per ontwerp** veroudert — geen actie nodig zolang de datum blijft staan.
- `batch-upgrade-en-conversie-revit-bestanden.md` §1 markeert de
  bestandsnaam-suffix-vraag (`_R23`/`_R24` versus SCI-conventie) als
  `[ONBEVESTIGD]`, terecht: geen van beide kennisbankbronnen bevestigt dit.

**Broncontrole:** alle vijf `raw/`-bestanden die in `memory.md` als verwerkt
staan, bestaan nog. Geen dode raw-verwijzing.

## 3. Gaten

### Nieuw en concreet — uit de bron die vandaag verwerkt is

**Sectie 6 van `raw/2026-08-31-uitgebreide-transcriptie-ai-bim-revit-automation-.md`
is niet in de wiki terechtgekomen.** Die sectie ("Revit + AI Tutorial |
Generate & Extract Area Information") beschrijft een concreet, herbruikbaar
patroon: Claude Code + pyRevit MCP gebruiken om per appartement afstand tot
lift/trap (via de Path of Travel-tool), raamaantal en glasoppervlak, aantal
buren en hoogste plafondhoogte te berekenen en terug te schrijven naar
project-parameters op Area-elementen — inclusief het interactieve
verduidelijkingspatroon (Claude vraagt door bij ambiguïteit als "wat is een
buur") en het omzetten van het eenmalige script naar een blijvende
`Unit Data`-pyRevit-knop plus Excel-reconciliatie. Dit is geen randgeval zoals
de eerder bewust overgeslagen organisatie-analogie (zie de vorige health
check) — het is een concreet werkpatroon dat rechtstreeks aansluit bij hoe SCI
al met de MCP-brug werkt (`mcp-versus-custom-tools.md` §5, dezelfde soort
Claude Code-waarnemingen). Ontbreekt volledig in `ai-tools-voor-pyrevit-ontwikkeling.md`,
`vyssuals-datavisualisatie.md` en elders.

**Voorstel:** een nieuw artikel of een uitbreiding van `mcp-versus-custom-tools.md`
§5 met een vierde waarneming: het patroon "ad-hoc MCP-analyse → interactieve
verduidelijking → vaste pyRevit-knop → Excel-reconciliatie", met de
Path-of-Travel-foutmarge (~45 cm) als bekende beperking.

### Nieuw — een gat dat de verwijdering van vandaag zelf openliet

`execute_revit_code` was de enige weg om ad-hoc IronPython te draaien voor
lezen én schrijven buiten de negentien vaste endpoints (worksets, warnings,
project units, per-element parameters — zie de skillbron hierboven). De route
is verwijderd; `mcp-revit-koppeling.md` §4 legt uit *waarom*, maar niet *wat er
nu voor die leesbehoefte in de plaats komt*. Er bestaat kennelijk een
alternatief — de Nonica-connector wordt elders (buiten deze kennisbank, in een
losse memory-notitie) genoemd als leesroute — maar dat staat nergens in
`wiki/`. Zonder dat is elke toekomstige "hoe lees ik nu de worksets uit"-vraag
een gat.

**Voorstel:** een paragraaf in `mcp-revit-koppeling.md` §4 of §5 die vastlegt
wat de vervangende leesroute is (Nonica-connector of anders), met bron.

### Staande gaten, ongewijzigd

`W:` onbereikbaar vanuit cloudsessies; de semantiek van drie
BuiltInParameters; de 2024/2027-spotcheck voor diezelfde acht namen (zie §4
hieronder — dit gat is dieper geworden, niet alleen blijven staan); geen
vastgelegde SCI-tagfamilie voor wapening; onbekend of de IFC-scripts BIM Basis
ILS volgen; welke Revit-versies SCI in productie draait; pyRevit 6.5.3-bug.

Geen webzoekopdracht uitgevoerd; deze check draaide zonder het argument `web`.

## 4. Veroudering

**Geen enkel artikel ouder dan 90 dagen.** Oudste `laatst-bijgewerkt` is
2026-08-26 (`nlrs-en-bim-standaarden.md`, `rebar-3d-modelleren.md`,
`revit-robot-interoperabiliteit.md`), vijf dagen oud.

**Wel: inhoud die door een externe wijziging is verschoven zonder dat de datum
het laat zien.** `rebar-api-parameters.md` §0 beschrijft `Enum.IsDefined` via
`/execute_code/` als *"een methode die de skill `revit-api-docs` niet noemt"*
en raadt aan die te herhalen voor de nog openstaande 2024/2027-spotcheck (§6).
Met `execute_revit_code` verwijderd is die methode niet meer uitvoerbaar zoals
beschreven — het artikel dateert van 2026-08-28, dus onder de 90-dagengrens,
maar de inhoud is drie dagen later al deels achterhaald. Dit is precies het
geval waar `kb-check.md` §4 voor waarschuwt: "ouderdom alleen is geen
probleem, beoordeel per artikel of de inhoud kan zijn verschoven."

**Voorstel:** een regel toevoegen aan `rebar-api-parameters.md` §0 of §6 die
vermeldt dat de live-`Enum.IsDefined`-methode sinds 2026-08-31 niet meer via
deze repo beschikbaar is, met een verwijzing naar `mcp-revit-koppeling.md` §4.

Verder ongewijzigd: de Autodesk 2027 MCP-server-beschrijving
(`mcp-versus-custom-tools.md` §4) en de pyRevit 6.5.3-bug
(`mcp-revit-koppeling.md` §5 punt 7) blijven kandidaten voor herijking bij de
eerstvolgende gelegenheid, zoals vorige keer al genoemd.

**Alle dertien artikelen staan op `concept`.** Twee zijn dichter bij de
promotiedrempel dan de rest: `rebar-api-parameters.md` (tweede onafhankelijke
bron: de live meting) en, sinds vandaag, `mcp-versus-custom-tools.md` (tweede
en derde onafhankelijke bron: Gavin Nicholls en Vyssuals). Geen van beide is
al op alle vier de promotievoorwaarden uit `CLAUDE.md` §4 getoetst — dat is
geen taak van deze check.

## 5. Stijl

**Geen overtredingen aangetroffen** bij het doorlezen van alle dertien
artikelen tegen `stijlgids.md`. Twee grensgevallen bekeken en niet als fout
beoordeeld:

- "ontgrendelen" in `ai-tools-voor-pyrevit-ontwikkeling.md` §1 — letterlijke
  beschrijving van een OpenRouter-productkenmerk (credits ontgrendelen een
  hoger dagquotum), geen AI-vulwoord in de zin van regel 6.
- "samengevatte" in `ai-brain-kennisorganisatie-pyrevit.md` §3 — technische
  beschrijving van het LLM Wiki-concept zelf, geen vulling.

Eén stijlfout is tijdens het schrijven van vandaag al gevonden en gecorrigeerd
(niet in dit rapport meegeteld als open bevinding): "het is de moeite waard te
weten dat" in `revit-bronnen-en-communities.md` §1, rechtstreeks in strijd met
regel 5/6, hersteld tot een gewone zin.

Regel 11 (echte namen) consequent gevolgd: `S-9464 Apartementen_R25`, poort
48884, model `S-9132_R25`, de exacte GUID `fb011c91-…`. Regel 15 (datum bij
vervalbare feiten) staat bij Ox Alpha, de Autodesk 2027-beta en de
pyRevit-versiebug.

## 6. Kapotte kruisverwijzingen

Script uit `kb-check.md` §6 kon niet draaien (geen Python op dit systeem);
handmatig nagelopen op basis van elk `verwant:`-blok. **0 ontbrekende
doelwitten, 0 weesartikelen, 6 eenzijdige links** — alle zes ontstaan uit het
werk van vandaag.

| Van → naar | Tekstuele grond? | Voorstel |
|---|---|---|
| `ai-brain-kennisorganisatie-pyrevit.md` → `mcp-versus-custom-tools.md` | **Nee** — komt in de body niet voor | Link verwijderen uit de frontmatter |
| `ai-brain-kennisorganisatie-pyrevit.md` → `mcp-eigen-tools-toevoegen.md` | **Nee** — komt in de body niet voor | Link verwijderen uit de frontmatter |
| `ai-tools-voor-pyrevit-ontwikkeling.md` → `mcp-versus-custom-tools.md` | Ja, §1 citeert de kostenkolom | `ai-tools-voor-pyrevit-ontwikkeling.md` toevoegen aan `mcp-versus-custom-tools.md` |
| `revit-bronnen-en-communities.md` → `ai-tools-voor-pyrevit-ontwikkeling.md` | Ja, §2 noemt het artikel met naam | `revit-bronnen-en-communities.md` toevoegen aan `ai-tools-voor-pyrevit-ontwikkeling.md` |
| `revit-bronnen-en-communities.md` → `batch-upgrade-en-conversie-revit-bestanden.md` | Ja, §4 noemt het artikel met naam | `revit-bronnen-en-communities.md` toevoegen aan `batch-upgrade-en-conversie-revit-bestanden.md` |
| `batch-upgrade-en-conversie-revit-bestanden.md` → `rebar-api-parameters.md` | Zwak — alleen de gedeelde 2024-versiegrens, geen directe inhoudelijke overlap | Bewuste keuze bij het schrijven om niet te reciproceren; ter beoordeling of de link zelf de moeite waard is |

De eerste twee zijn vermoedelijk een kopieerfout: het `verwant:`-blok van
`ai-brain-kennisorganisatie-pyrevit.md` bevat twee bestanden die nergens in de
lopende tekst worden aangehaald. De overige vier zijn gegronde links die bij
het schrijven eenzijdig zijn blijven staan — precies de fout die `CLAUDE.md`
§7 stap 4 beoogt te vangen.

In-tekst §-verwijzingen gecontroleerd voor alle vier de nieuwe en vier
bijgewerkte artikelen: alle wijzen naar secties die ook echt bestaan onder die
naam (o.a. `mcp-versus-custom-tools.md` §1/§3/§5, `vyssuals-datavisualisatie.md`
§3, `rebar-api-parameters.md` §4, `ai-tools-voor-pyrevit-ontwikkeling.md` §1/§2).

## 7. Coverage — is elk raw-bestand écht verwerkt?

| Raw-bestand | Secties | Terug te vinden in |
|---|---|---|
| `2026-08-25 samenvatting-bronnen.md` | §1–§5 | Ongewijzigd sinds 2026-08-28: volledig (zie vorige check). |
| `2026-08-25-samenvatting-revit-structure-rebar.md` | §1–§5 | Ongewijzigd sinds 2026-08-28: volledig. |
| `2026-08-25 zelfverbeterende-kennisbank-claude.md` | — | Bewust geen wiki-artikel, zoals gelogd. Ongewijzigd. |
| `2026-08-27_revit_mcp_bronnen_transcripties.md` | §1–§8 | Ongewijzigd sinds 2026-08-28: volledig op twee bewuste omissies na. |
| `2026-08-31-uitgebreide-transcriptie-ai-bim-revit-automation-.md` | §1–§7 | §1 → `mcp-versus-custom-tools.md` §3, `revit-bronnen-en-communities.md`. §2 → `batch-upgrade-en-conversie-revit-bestanden.md`. §3, §4 → `ai-tools-voor-pyrevit-ontwikkeling.md`. §5 → `ai-brain-kennisorganisatie-pyrevit.md`. **§6 → nergens (zie §3 hierboven).** §7 → `vyssuals-datavisualisatie.md`. |

**Omgekeerde controle:** geen bestand in `raw/` dat buiten `memory.md` valt.
`README.md` overgeslagen zoals voorgeschreven.

Dit is de eerste keer dat deze controle een écht gemiste sectie vindt, niet
een bewuste omissie. Het bevestigt de eigen waarschuwing in `kb-check.md` §7:
een grote dump in één keer verwerken is precies waar dit gebeurt.

---

## Actieplan

Op volgorde van belang.

1. **[Claude] Voeg het conflictblok toe aan `mcp-revit-koppeling.md`** dat de
   skillbron `sci-bim-context/references/template-en-mcp.md` §C nog
   `execute_revit_code` als bestaande tool noemt, analoog aan het bestaande
   §6-patroon. Dit is de kern van bevinding 1.
2. **[gebruiker] Werk de skillbron bij en upload opnieuw.** In
   `Snetselaar_BIM/sci-bim-context/references/template-en-mcp.md` §C:
   `execute_revit_code`-rij verwijderen, "Twintig stuks" naar "Negentien
   stuks", en de zin over worksets/warnings/parameters herschrijven nu er geen
   ontsnappingsklep meer is. Daarna opnieuw inpakken en uploaden
   (`pack_skill.ps1`, `skill_uploads.ps1 -Mark`), zoals op 2026-08-28.
3. **[Claude, op verzoek] Schrijf sectie 6 van de 2026-08-31-bron alsnog uit**
   — het Area Information-patroon — als uitbreiding van `mcp-versus-custom-tools.md`
   §5 of als nieuw artikel. Middelgroot werk, geen bronprobleem: de sectie
   staat compleet in `raw/`.
4. **[Claude, klein] Corrigeer "eerste" naar "tweede" SCI-werkafspraak** in
   `mcp-versus-custom-tools.md` §3.
5. **[Claude, klein] Repareer de zes kruisverwijzingen** uit §6 hierboven: twee
   ongegronde links verwijderen uit `ai-brain-kennisorganisatie-pyrevit.md`,
   drie gegronde reciproceren, één ter beoordeling voorleggen.
6. **[Claude, klein] Vul het gat over de vervangende leesroute** na het
   verwijderen van `execute_revit_code` in `mcp-revit-koppeling.md` §4/§5 —
   eerst navragen wat die route precies is (Nonica-connector?) voor dit met
   een bron kan.
7. **[Claude, klein] Voeg een regel toe aan `rebar-api-parameters.md`** dat de
   live-`Enum.IsDefined`-methode sinds 2026-08-31 niet meer via deze repo
   beschikbaar is.

Punten 1, 3–7 zijn door Claude uit te voeren zodra de gebruiker akkoord geeft;
punt 2 is een handeling buiten de kennisbank (skill bewerken + uploaden).

`index.md` is bijgewerkt met de twee nieuwe concrete gaten (punt 3 en 6
hierboven) en de tegenstrijdigheid van bevinding 1. De wiki-artikelen zelf
zijn door deze check **niet** gewijzigd.

---

## Herhaalde run (2026-08-31, zelfde dag, na uitvoering van het actieplan)

Het actieplan hierboven is dezelfde dag uitgevoerd: alle zeven punten, inclusief
de skill-upload (de gebruiker deed de upload zelf; `-Mark` is nadien gedraaid,
sha256 `97ec9542…`, commit `921994f`) en een nieuw artikel
(`wiki/appartementdata-genereren-met-ai.md`) voor de gemiste sectie 6. Op
verzoek is de kennisbank opnieuw volledig doorgelicht om te controleren of die
uitvoering zelf nieuwe schade heeft achtergelaten — dat is precies waar snel,
gejaagd reparatiewerk om vraagt.

**Artikelen:** 14, alle `status: concept`.
**Bevindingen:** alle zeven punten uit het vorige actieplan zijn correct
afgehandeld, **maar het repareren zelf liet vier nieuwe, kleine
inconsistenties achter** — steeds hetzelfde patroon: een feit op één plek
gecorrigeerd, een andere plek die naar hetzelfde feit verwijst overgeslagen.
0 nieuwe stijlovertredingen, 0 nieuwe kapotte kruisverwijzingen (het
kruisverwijzingenscript — nu handmatig via `awk`, `Get-NetTCPConnection`-achtig
maar dan voor `verwant:`-blokken, want er is geen Python op dit systeem — geeft
een schone lei: alle 14 artikelen volledig wederzijds gelinkt, geen ontbrekend
doelwit, geen weesartikel). Coverage: volledig, sectie 6 is nu wél terug te
vinden.

### Tegenstrijdigheden — vier nieuwe, alle vier "reparatie niet doorgezet"

1. **`mcp-versus-custom-tools.md` spreekt zichzelf tegen.** De inleiding (regel
   25) zegt nog *"valt vrijwel samen met de eerste SCI-werkafspraak"*; §3
   (regel 75) is bij de vorige reparatie wél gecorrigeerd naar *"de tweede
   SCI-werkafspraak"*. Twee plekken in hetzelfde artikel over hetzelfde feit,
   met een tegengestelde waarde. De fix van vandaag greep alleen de
   `###`-subsectie, niet de intro-alinea waar het probleem het eerst werd
   gevonden.
2. **`mcp-revit-koppeling.md` §4 heet nog "De 20 tools en hun endpoints".**
   Diezelfde sectie documenteert een paar regels verderop de verwijdering van
   `execute_revit_code` en noemt het resterende aantal expliciet "de andere
   negentien" — de kop zelf is niet meegenomen.
3. **`mcp-revit-koppeling.md` §7 ("Waar dit niet over gaat") verwijst twee keer
   naar `execute_revit_code` alsof die route nog bestaat:** *"Het schrijven van
   IronPython voor `execute_revit_code`: skill `pyrevit-codestijl`"* en
   *"Concrete parameters uitlezen: ... Dat gaat in de praktijk via
   `execute_revit_code`"*. Beide zinnen stonden er al vóór de verwijdering en
   zijn bij het schrijven van §4/§6 niet meegenomen. Ze horen nu naar de
   Nonica-connector te wijzen (zie punt 4 hieronder) of geschrapt te worden.
4. **`rebar-api-parameters.md` §0 en §6 zeggen nog dat er geen vervangende
   leesroute is,** terwijl die route (de Nonica-connector) dezelfde dag ná het
   schrijven van deze twee zinnen alsnog is vastgelegd in
   `mcp-revit-koppeling.md` §4. Twee exacte citaten die dat rechtzetten:
   *"Een vervangende leesroute is op dit moment niet vastgelegd in deze
   kennisbank"* (§0) en *"De spotcheck vraagt nu óf een vervangende leesroute,
   óf een opgehaalde documentatiepagina"* (§6).

Geen van deze vier is een nieuwe feitelijke fout — het onderliggende feit
(tweede werkafspraak, negentien tools, Nonica-connector) staat inmiddels
correct ergens in de kennisbank. Het zijn gemiste propagaties: dezelfde
categorie fout als de kruisverwijzingen uit de vorige run, nu op
losse zinnen in plaats van op `verwant:`-frontmatter.

### Overige controles — kort, want grotendeels ongewijzigd

- **Claims zonder bron:** geen nieuwe gevonden. `appartementdata-genereren-met-ai.md`
  is regel voor regel nagelopen; elke claim draagt `raw/2026-08-31-...` §6 of
  een verwijzing naar een ander artikel, met één `[ONBEVESTIGD]` (of het
  patroon een concrete SCI-toepassing heeft).
- **Gaten:** de twee gaten uit de eerste run (sectie 6, vervangende leesroute)
  zijn dicht. Geen nieuwe gaten gevonden bij deze tweede lezing.
- **Veroudering:** niets ouder dan vandaag of vijf dagen terug; geen
  wijziging t.o.v. de eerste run.
- **Stijl:** `appartementdata-genereren-met-ai.md` getoetst tegen de
  verboden-woordenlijst — schoon. Geen overtredingen elders geïntroduceerd.
- **Lengte (geen stijlgids-overtreding in strikte zin, wel het vermelden
  waard):** `mcp-revit-koppeling.md` staat nu op 407 regels,
  `rebar-api-parameters.md` op 279 — beide ruim boven de 200-regelrichtlijn
  uit `stijlgids.md` §5 ("loopt een artikel over de 200 regels... splits
  het"). Dit is niet nieuw en niet vandaag ontstaan, maar de regels van
  vandaag hebben ze allebei iets langer gemaakt. Geen van beide behandelt
  aantoonbaar "twee dingen" — het zijn dichte, samenhangende artikelen die
  toevallig lang zijn geworden. Ter overweging, geen acute actie.

**Ernstigste punt van deze herhaalde run:** geen van de vier is op zichzelf
schadelijk (elk artikel bevat het juiste feit ergens), maar punt 3 is het
meest zichtbare: iemand die `mcp-revit-koppeling.md` van boven naar beneden
leest, ziet in §4 dat `execute_revit_code` verwijderd is en leest twee
paragrafen later in §7 alsnog een verwijzing die suggereert dat de route nog
bruikbaar is.

### Actieplan (herhaalde run)

1. **[Claude, klein] `mcp-versus-custom-tools.md` regel 25:** "eerste" →
   "tweede SCI-werkafspraak".
2. **[Claude, klein] `mcp-revit-koppeling.md` §4-kop:** "De 20 tools" → "De 19
   tools" (of neutraal: "De tools en hun endpoints", zodat een toekomstige
   telwijziging de kop niet weer laat verouderen).
3. **[Claude, klein] `mcp-revit-koppeling.md` §7:** beide
   `execute_revit_code`-verwijzingen herschrijven — de eerste naar "was" in
   plaats van een skill-verwijzing die niet meer klopt, de tweede naar de
   Nonica-connector met een verwijzing naar §4.
4. **[Claude, klein] `rebar-api-parameters.md` §0 en §6:** de twee
   "geen vervangende leesroute"-zinnen bijwerken met de Nonica-connector en
   een verwijzing naar `mcp-revit-koppeling.md` §4.

Alle vier zijn tekstuele correcties zonder inhoudelijke keuze — geen van vieren
vraagt om iets nieuws te verzinnen, alleen om een al vastgesteld feit op één
plek extra door te voeren. Wiki-artikelen zijn door deze herhaalde run **niet**
gewijzigd; `index.md` evenmin, in afwachting van uitvoering.

---

## Tweede herhaalde run (2026-08-31, derde keer dezelfde dag)

Het actieplan van de herhaalde run hierboven is uitgevoerd: alle vier de
gemiste propagaties gerepareerd (`mcp-versus-custom-tools.md` intro,
`mcp-revit-koppeling.md` §4-kop en §7, `rebar-api-parameters.md` §0/§6). Op
verzoek nogmaals volledig doorgelicht.

**Bevindingen: geen nieuwe.** De drie bewerkte artikelen zijn integraal
herlezen: `mcp-versus-custom-tools.md` (intro én §3 zeggen nu allebei "tweede
SCI-werkafspraak"), `mcp-revit-koppeling.md` §4 en §7 (kop neutraal, geen
verwijzing meer die `execute_revit_code` als bestaand behandelt — de enige
resterende vermeldingen staan in de twee dateerde, expliciet als historisch
gemarkeerde conflictblokken in §6, waar ze horen), `rebar-api-parameters.md`
§0 en §6 (Nonica-connector nu op beide plekken genoemd). Een gerichte grep op
de drie eerder foutieve exacte formuleringen ("eerste SCI-werkafspraak", "De
20 tools", "niet vastgelegd in deze kennisbank") leverde niets meer op.

De kruisverwijzingencontrole is opnieuw gedraaid (handmatig via `awk`, geen
Python op dit systeem beschikbaar): 0 ontbrekende doelwitten, 0 eenzijdige
links, 0 weesartikelen, op alle 14 artikelen. Stijl, bronvermelding,
veroudering en coverage zijn ongewijzigd ten opzichte van de vorige run — geen
van de drie bewerkte bestanden introduceerde een nieuwe claim zonder bron of
een verboden woord.

**Geen actieplan.** Dit is het eerste punt in de drie runs van vandaag waar
niets is blijven liggen. Wiki-artikelen en `index.md` zijn door deze run niet
gewijzigd.
