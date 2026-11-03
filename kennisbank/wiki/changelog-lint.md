---
titel: Het changelog van het SCI-lint — opzet, bronnen en afspraken
status: concept
laatst-bijgewerkt: 2026-11-03
bronnen:
  - "sessie 2026-11-03 met Albert: opdracht, splitsing en zichtbaarheid"
  - "Changelog_lint.md, door Albert aangeleverd op 2026-11-03 (de versie die geldt)"
  - outputs/2026-11-03-changelog-lint.md
  - outputs/2026-11-03-changelog-rnd.md
  - "lintaudit: outputs/2026-10-07-lint-audit-api-en-logging.md (achtergrond logging-regels)"
  - "repo Snetselaar_BIM, git log vanaf d2b3dc9 (2026-07-21) t/m 30-10-2026"
  - "repo Snetselaar_BIM, versienotities in de module-docstrings van de script.py's"
  - "repo Snetselaar_BIM, SCI-Viewer/README.md (gelezen 2026-11-03)"
skill: bimtools-promotie
---

# Het changelog van het SCI-lint

Sinds 03-11-2026 is er per knop een changelog. Daarvoor stond in de skill
`bimtools-promotie` §1 letterlijk "Er is geen changelog". Dit artikel legt vast
hoe het is opgezet. Het is ook het vertrekpunt voor de geplande samenvoeging met
het changelog van de SCI-Viewer en andere onderdelen (zie §6).

## 1. Bestanden en zichtbaarheid

| Bestand | Inhoud |
|---|---|
| `Changelog lint.md` | `# 01_SCI` en `# 02_Beta` |
| `Changelog R&D.md` | `# 03_R&D` |

Ze staan naast de gebruikslog:

```
W:\1 - Informatie Snetselaar\Constructief tekenen\Revit\10. Snetselaar Lint\Extensie\Gebruikers logs niet verwijderen\
```

In de repo `Snetselaar_BIM` komen ze in `Logging/` (spiegel van die map).

Keuze van Albert, 03-11-2026: 03_R&D **los**, maar **wel zichtbaar** voor
iedereen. Daarom staat in `Changelog R&D.md` "nog in ontwikkeling en niet
uitgerold naar de modelleurs", niet "alleen voor eigen gebruik". De eerste
opzet (twee bestanden met een R&D-deel "alleen voor Albert") is daarmee vervallen.

De geldende tekst is die van Albert (`Changelog_lint.md`, 03-11-2026), door
Claude alleen in tweeën geknipt. Kopieën van de stand van 03-11-2026:
`outputs/2026-11-03-changelog-lint.md` en `outputs/2026-11-03-changelog-rnd.md`.

## 2. Opbouw

```markdown
# 01_SCI                      ← extensie (01_SCI / 02_Beta / 03_R&D)

## Tag & Maatvoering          ← panel

### Kolommen Taggen           ← knop
*huidige versie 1.17*
- **1.17** · 30-10-2026 — Tag 800 mm boven/onder. Kijkt naar de View Range.
- **1.16** · 20-10-2026 — Vinkje "Botscontrole": uit = elke tag op zijn standaardplek.
```

- Kop van elk bestand: titel, één zin wat het is, `Stand: dd-mm-jjjj`, en de
  uitleg dat het versiebeheer op 21-07-2026 begon.
- **Nieuwste versie bovenaan**, `*huidige versie x.y*` direct onder de knopnaam.
- Regel: `- **versie** · dd-mm-jjjj — tekst`. Een reeks tussenversies mag samen:
  `**1.26–1.28** · 15/16-10-2026`.
- **Hooguit drie regels per versie, liefst één**, in gewone taal voor een
  modelleur. Wens van Albert bij de opdracht.
- Knoppen die hetzelfde doen delen één blok: stramienbollen (6), RVTLinks
  aan/uit, Level erboven/eronder, de materiaal-pulldowns (Beton, Hout,
  Kalkzandsteen, Brandwerendheid, Milieuklasse, Structural).
- Vaste formuleringen: `Al in gebruik: <wat hij doet>` (01/02) of
  `Al aanwezig: …` (03) voor knoppen die er op 21-07-2026 al waren;
  `Nieuwe knop: …`; `Vervangt Dynamo "<nr>"`; `Van 02_Beta naar 01_SCI.`;
  bij Beta `met opslaan-vraag bij de start`.
- In Alberts versie staan ook logging-wijzigingen ("Een harde crash komt nu als
  'Vastgelopen' in het gebruikslog"). In de eerste opzet van Claude waren die
  weggelaten; Albert hield ze erin.

## 3. Databronnen

Het gebruikslog en `toolboek_historie.csv` staan alleen op W:, en die waren in
de cloudsessie niet bereikbaar. Gebruikt:

1. **De git-historie van `Snetselaar_BIM`**, per `.pushbutton`-map. Eerste commit
   `d2b3dc9` op 21-07-2026: daarvóór bestaat er geen versiebeheer.
2. **De versienotities in de module-docstring** (`x.y (dd-mm-jjjj) …`). Die
   geven vaak de juiste datum waar de commit later is (AutoDim Detail
   1.26–1.28: script 15/16-10, commit 20-10).
3. **De commitberichten** van de grote verhuizingen: `e61adf8` (09-10-2026,
   lint heringedeeld, 16 knoppen van 02_Beta naar 01_SCI, Translatie X/Y uit
   het lint) en `6b50b83` (30-10-2026, stacks, promotie Levels Verbergen,
   S235 Leeg Invullen, Wapening Taggen).

Valkuilen:

- `git log --follow` haalt soms een ander script binnen dat erop lijkt (Tag
  Details volgde Tag As-Aanzichten; Crash Rapport volgde een ander
  Controle-script). Controleer de eerste versie aan het commitbericht.
- Hernoemde knoppen hebben hun geschiedenis onder een oude mapnaam:
  PrintSheets → Plot, AutoTag_SectieStaal → Tag As-Aanzichten,
  AutoDim_SectieVerticaal → AutoDim Detail, WandGaten → Wandgaten Verticaal,
  Vakwerk_uit_Excel → Vakwerk maken, Vakwerk Details → Vakwerk Aanzichten,
  Vakwerk Controle + Vakwerk Overzicht → Vakwerk Overzicht/Controle,
  Knip op stramien → Knippen op….
- Vier `Reset.pushbutton`'s (Beton, Hout, Kalkzandsteen, Brandwerendheid):
  op naam alleen zijn ze niet uit elkaar te houden, neem de pulldown mee.

## 4. Onderhoud

Handwerk, geen script. Bij elke versiebump en elke verhuizing:

- nieuwe regel bovenaan het knopblok, `*huidige versie*` meeschuiven;
- bij een verhuizing het hele blok mee naar de andere sectie of het andere
  bestand (03 → 02 betekent van `Changelog R&D.md` naar `Changelog lint.md`),
  met de regel "Van … naar …" erbovenop;
- `Stand:` in de kop bijwerken.

Vastgelegd in de skillbronnen, op 03-11-2026 aangepast in de repo maar
**nog niet geüpload** (en nog niet gepusht):

- `bimtools-promotie` — nieuwe §4a Changelog, stap 6 in de verhuischecklist,
  eis in de fase-eisen 02/01;
- `bimtools-actielijst` — verschil actielijst/changelog; kolom D moet gelijk
  zijn aan `*huidige versie*`, kolom B aan de sectie;
- `update-github-bimtools` — de twee changelogs in de bestandslijst van de
  map `Logging`, met een waarschuwing in plaats van een fout als ze ontbreken.

Tot die uploads gedaan zijn, weet een sessie dat alleen uit dit artikel.
[ONBEVESTIGD: of de patch `skills-en-changelog.patch` inmiddels in de repo
staat.]

## 5. Bewust weggelaten

- Knoppen die al weg zijn (Translatie X/Y, Plot v3/v4/v5, IFC
  Voortgangsmeting, Merk Propagation, Select-knoppen): niet in Alberts versie.
  De skills zeggen voortaan: zet zo'n knop onder "Uit het lint gehaald".
  Of het knopblok dan blijft staan, is nog niet besloten.
- Versies van vóór 21-07-2026 zonder datum (Lock Stramien 5.3–5.6, Tag
  Details 1.1–1.12 in R&D): samengevat of weggelaten.

## 6. Samenvoeging met SCI-Viewer en andere producten

Wens van Albert (03-11-2026): het lint-changelog later samenvoegen met dat van
de SCI-Viewer "en nog wat meer dingen". Wat er nu bekend is:

- **SCI-Viewer** — één HTML-bestand. Bron van waarheid sinds 30-10-2026 (2.35)
  is `\\NAS01\Data-SCI\01. BIM Software\SCI-Viewer\SCI-Viewer.html`. De
  repomap `SCI-Viewer/` is een spiegel. De versiegeschiedenis staat in de kop
  van de HTML, niet in een apart bestand (bron: `SCI-Viewer/README.md`).
  Eén versienummer voor het hele product, geen knoppen.
- Het lint heeft een versienummer **per knop**. Samenvoegen gaat dus het
  makkelijkst met per product een eigen `#`-sectie (`# SCI-Viewer` naast
  `# 01_SCI`), met dezelfde regelvorm `- **versie** · datum — tekst` en
  nieuwste bovenaan.
- [ONBEVESTIGD: welke "andere dingen" erbij komen, en of het samengevoegde
  bestand op W: of op de NAS komt te staan.]
