---
description: Beantwoordt een vraag uit de kennisbank en bewaart het antwoord in kennisbank/outputs/
argument-hint: "<je vraag>"
---

Beantwoord deze vraag en bewaar het antwoord: $ARGUMENTS

## Vooraf

1. Lees `kennisbank/CLAUDE.md` en `kennisbank/stijlgids.md`.
2. Lees `kennisbank/index.md` om te zien wat er is.

## Werkwijze

1. **Bepaal de bronnen.** Valt de vraag binnen het domein van een SCI-skill
   (zie `CLAUDE.md` §3), gebruik dan die skill — die gaat voor. Lees daarnaast
   de relevante wiki-artikelen. Gaat het om een Revit API-signatuur, gebruik dan
   `revit-api-docs` en zoek het op; reproduceer niet uit geheugen.

2. **Antwoord op basis van wat er is.** Geen bron in de kennisbank en geen skill
   die het dekt? Zeg dat expliciet in plaats van het uit algemene kennis in te
   vullen. Vul je toch aan uit algemene kennis, markeer dat deel dan zichtbaar
   als zodanig.

3. **Schrijf het antwoord weg** naar `kennisbank/outputs/JJJJ-MM-DD-onderwerp.md`
   met frontmatter:

   ```yaml
   ---
   vraag: <de letterlijke vraag>
   datum: JJJJ-MM-DD
   gebruikte-bronnen:
     - wiki/...
     - skill: ...
   ---
   ```

   Bestaat het bestand al, kies dan een nieuwe naam met een volgnummer.
   Overschrijf nooit een bestaand antwoord.

4. **Benoem de gaten.** Sluit het bestand af met een sectie
   `## Wat de kennisbank hierover niet weet`. Wees concreet: welk artikel
   ontbreekt, welke bron zou het beantwoorden, wat zou er in `raw/` moeten
   belanden. Een lege sectie is verdacht bij een niet-triviale vraag.

5. **Werk `index.md` bij** — de gevonden gaten onder "Open vragen en gaten",
   voor zover ze er nog niet staan.

## Rapporteer

Geef het antwoord in de chat, kort, plus het pad van het opgeslagen bestand en
de gevonden gaten. Herhaal het bestand niet integraal in de chat.
