---
description: Health check van de kennisbank — tegenstrijdigheden, bronnen, kruisverwijzingen, coverage, gaten, veroudering, stijl
argument-hint: "[optioneel: web — ook online zoeken om gaten te vullen]"
---

Voer de health check op de kennisbank uit. Argument: $ARGUMENTS

Bedoeld om maandelijks te draaien. Dit command **repareert niets uit zichzelf**.
Het rapporteert, stelt voor, en vraagt. Wat je wél mag bijwerken staat onder
stap 7.

## Vooraf

Lees `kennisbank/CLAUDE.md`, `kennisbank/stijlgids.md`, `kennisbank/index.md` en
`kennisbank/memory.md`. Lees daarna **elk** bestand in `kennisbank/wiki/`. Niet
steekproefsgewijs — de waarde van deze check zit erin dat hij alles ziet.

## De zeven controles

### 1. Tegenstrijdigheden

Twee richtingen, allebei doen:

- **Tussen wiki-artikelen onderling.** Zeggen twee artikelen iets anders over
  hetzelfde? Let op verkapte gevallen: verschillende getallen voor hetzelfde,
  een pad dat in het ene artikel anders is dan in het andere, een conventie die
  ergens met en ergens zonder uitzondering staat.
- **Tussen wiki en skills.** Loop de domeinen van de skills uit `CLAUDE.md` §3
  langs en lees de skill waar een artikel hem raakt. Volgens `CLAUDE.md` §3
  regel 2 wint de skill, tenzij het artikel een nieuwere geverifieerde bron
  heeft. Meld beide gevallen; los ze niet zelf op.

Rapporteer per tegenstrijdigheid: waar, wat zegt elk van beide, welke bronnen
eronder liggen, en welke kant je zou kiezen met waarom.

### 2. Claims zonder bron

Per artikel: welke feitelijke beweringen hebben geen bron en ook geen
`[ONBEVESTIGD]`-markering? Dat zijn de gevaarlijkste regels in de kennisbank,
want ze lezen als vastgesteld. Noem ze letterlijk, met bestand en regelnummer.

Controleer ook of de bronnen die er staan nog kloppen: bestaat het `raw/`-bestand
nog, klopt de regelverwijzing naar code nog, leeft de URL nog.

### 3. Gaten

Waar houdt de kennisbank op terwijl het onderwerp doorloopt? Kijk naar:

- artikelen die naar iets verwijzen dat nergens beschreven staat;
- de open vragen die al in `index.md` staan — zijn ze nog open?
- vragen uit `outputs/` waar de sectie "Wat de kennisbank hierover niet weet"
  iets noemde dat nog steeds ontbreekt;
- domeinen uit `CLAUDE.md` §1 waar niets over staat en ook geen skill voor is.

Is het argument `web` meegegeven: zoek voor de belangrijkste gaten online naar
materiaal (Revit API-documentatie via de skill `revit-api-docs`, pyRevit-docs,
forums) en stel per gat een concrete bron voor. Zonder `web`: alleen benoemen wat
er nodig is.

### 4. Veroudering

Alles met `laatst-bijgewerkt:` ouder dan **90 dagen** krijgt een regel in het
rapport. Ouderdom alleen is geen probleem — beoordeel per artikel of de inhoud
kan zijn verschoven. Extra verdacht: versienummers, Revit-API-gedrag, paden op
`W:`, teamafspraken, alles wat aan een Revit-versie hangt.

Noem ook artikelen die `status: concept` hebben en al maanden niet zijn geraakt.
Die zijn blijven liggen.

### 5. Stijl

Toets `kennisbank/wiki/` en `kennisbank/outputs/` tegen `stijlgids.md`. De regels
zijn genummerd; verwijs naar het nummer. Let vooral op regel 6 (AI-vulwoorden),
regel 11 (echte namen in plaats van generieke voorbeelden) en regel 15 (datum bij
alles wat kan verlopen).

### 6. Kapotte kruisverwijzingen

De waarde van de kennisbank zit in de verbanden, en die verrotten stil. Controleer
drie dingen, bij voorkeur met een script in plaats van op het oog:

- **Doelwit bestaat niet.** Een `verwant:`-vermelding naar een bestand dat er niet
  (meer) is.
- **Eenzijdige link.** A verwijst naar B, B niet terug naar A. `CLAUDE.md` §7 stap
  4 schrijft voor dat beide kanten bijgewerkt worden; dit betrapt waar dat is
  blijven liggen.
- **Weesartikel.** Een artikel waar niets naar verwijst. Niet per se fout — een
  nieuw onderwerp begint zo — maar wel een signaal dat het los in de lucht hangt.

Bruikbaar als startpunt:

```python
import io, os, re
d = "kennisbank/wiki"
links = {}
for f in sorted(os.listdir(d)):
    if not f.endswith(".md"): continue
    s = io.open(os.path.join(d, f), encoding="utf-8").read()
    m = re.search(r"^verwant:\n((?:  - .*\n)*)", s, re.M)
    links[f] = re.findall(r"  - (\S+)", m.group(1)) if m else []
for f, tgts in links.items():
    for t in tgts:
        if t not in links:            print("ONTBREEKT:", f, "->", t)
        elif f not in links[t]:       print("EENZIJDIG:", f, "->", t)
for f in links:
    if not any(f in v for k, v in links.items() if k != f):
        print("WEES:", f)
```

Controleer ook de verwijzingen ín de tekst, niet alleen de frontmatter — een
`§4` die naar een verdwenen sectie wijst is net zo kapot.

### 7. Coverage — is elk raw-bestand écht verwerkt?

Deze controle betrapt half werk, en dat is de meest waarschijnlijke fout bij een
grote dump.

Loop `memory.md` langs. Voor elk bronbestand dat daar als verwerkt staat: open het
raw-bestand en loop de secties af. Is elke sectie ergens in de wiki terechtgekomen,
of is er een blok overgeslagen omdat het lastig was, buiten bereik leek, of
onderaan stond?

Rapporteer per bronbestand welke secties je niet hebt kunnen terugvinden. Een
bestand dat "verwerkt" heet maar waarvan de helft nergens staat, is erger dan een
onverwerkt bestand: de SessionStart-hook meldt het niet meer, dus niemand kijkt er
nog naar.

Controleer ook de omgekeerde kant: staat er in `raw/` iets wat niet in `memory.md`
voorkomt en dus nooit verwerkt is?

## 8. Schrijf het rapport

Naar `kennisbank/outputs/JJJJ-MM-DD-healthcheck.md`, met per controle een sectie
en per bevinding: waar, wat, hoe ernstig, wat je voorstelt.

Begin met een kop van vijf regels: aantal artikelen, aantal bevindingen per
categorie, en het ernstigste punt.

Sluit af met een **actieplan**: genummerde punten, op volgorde van belang, elk
zo geformuleerd dat het in één opdracht uitvoerbaar is ("markeer de vier claims in
§1 van X als ONBEVESTIGD", niet "verbeter de bronvermelding"). Zet erbij welke
punten je zelf kunt uitvoeren en welke een handeling van de gebruiker vragen —
iets nameten in Revit, een bestand van `W:` halen. Dat onderscheid bepaalt wat er
daadwerkelijk gebeurt.

**Zeg niet dat alles in orde is tenzij je alles hebt gelezen en er echt niets
was.** Een kennisbank met weinig artikelen heeft altijd gaten; die niet vinden
betekent dat je niet goed genoeg hebt gekeken.

## 9. Wat je wél mag bijwerken

Alleen `index.md`: de sectie "Open vragen en gaten" bijwerken met wat je gevonden
hebt, en de statusregels laten kloppen met de werkelijkheid.

Wiki-artikelen laat je met rust. Stel de wijzigingen voor in het rapport en in je
antwoord; de gebruiker beslist.

## Rapporteer

In de chat: het pad van het rapport, het aantal bevindingen per categorie, en de
drie punten die het eerst aandacht nodig hebben. Niet het hele rapport herhalen.
