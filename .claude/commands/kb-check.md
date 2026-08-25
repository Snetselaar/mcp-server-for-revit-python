---
description: Health check van de kennisbank — tegenstrijdigheden, bronnen, gaten, veroudering, stijl
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

## De vijf controles

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

## 6. Schrijf het rapport

Naar `kennisbank/outputs/JJJJ-MM-DD-healthcheck.md`, met per controle een sectie
en per bevinding: waar, wat, hoe ernstig, wat je voorstelt.

Begin met een kop van vijf regels: aantal artikelen, aantal bevindingen per
categorie, en het ernstigste punt.

**Zeg niet dat alles in orde is tenzij je alles hebt gelezen en er echt niets
was.** Een kennisbank met weinig artikelen heeft altijd gaten; die niet vinden
betekent dat je niet goed genoeg hebt gekeken.

## 7. Wat je wél mag bijwerken

Alleen `index.md`: de sectie "Open vragen en gaten" bijwerken met wat je gevonden
hebt, en de statusregels laten kloppen met de werkelijkheid.

Wiki-artikelen laat je met rust. Stel de wijzigingen voor in het rapport en in je
antwoord; de gebruiker beslist.

## Rapporteer

In de chat: het pad van het rapport, het aantal bevindingen per categorie, en de
drie punten die het eerst aandacht nodig hebben. Niet het hele rapport herhalen.
