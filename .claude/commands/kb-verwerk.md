---
description: Verwerkt nieuwe bestanden uit kennisbank/raw/ naar de wiki, werkt index en memory bij
argument-hint: "[optioneel: specifiek bestand in raw/]"
---

Verwerk de kennisbank. Argument: $ARGUMENTS (leeg = alles wat nog open staat).

## Vooraf

1. Lees `kennisbank/CLAUDE.md` volledig. Dat is het schema.
2. Lees `kennisbank/stijlgids.md`. Alles wat je schrijft voldoet hieraan.
3. Lees `kennisbank/memory.md` om te bepalen wat al verwerkt is.
4. Lees `kennisbank/index.md` om te weten welke artikelen bestaan.

## Werkwijze

1. **Bepaal de werkvoorraad.** Is er een argument, verwerk dan dat bestand.
   Anders: alle bestanden in `kennisbank/raw/` die niet in `memory.md` staan
   (`README.md` overslaan). Is er niets te doen, zeg dat en stop — schrijf geen
   artikel om iets te doen te hebben.

2. **Lees het materiaal.** Bij PDF's en afbeeldingen: lees ze echt, ga niet af op
   de bestandsnaam.

3. **Beslis: bijwerken of nieuw.** Voorkeur gaat naar het uitbreiden van een
   bestaand artikel. Begin alleen een nieuw bestand als het onderwerp echt nieuw
   is. Bestaat er een skill die het onderwerp al dekt (zie `CLAUDE.md` §3), dan
   schrijf je alleen het deel op dat de skill niet dekt, met verwijzing.

4. **Schrijf.** Frontmatter volgens `CLAUDE.md` §5. Nieuwe artikelen krijgen
   `status: concept`. Elke feitelijke claim krijgt een bron; kan dat niet, dan
   `[ONBEVESTIGD]` ervoor. Vind je iets dat in strijd is met een skill: het blok
   `> **Conflict met skill `naam`:** …` gebruiken en het in je antwoord melden.
   Nooit stil overschrijven.

5. **Leg verbanden.** Dit is de belangrijkste stap en de makkelijkste om te
   vergeten. Loop de bestaande artikelen langs en vraag je af: raakt dit
   materiaal iets wat er al staat? Werk `verwant:` aan **beide** kanten bij en
   benoem het verband in de tekst — niet alleen als link, maar met een zin die
   zegt wat het verband is. Zie je een patroon over meerdere artikelen heen dat
   nergens is opgeschreven, schrijf dat dan op; dat is precies wat de kennisbank
   moet opleveren.

6. **Werk `index.md` bij.** Regel per artikel: titel, status, datum, één zin.
   Zet nieuwe open vragen onder "Open vragen en gaten".

7. **Werk `memory.md` bij.** Eén regel per verwerkt bronbestand: datum, bron,
   geraakte artikelen, één zin toelichting. Actualiseer `laatst-verwerkt:`.

8. **Laat `raw/` met rust.** Niets verplaatsen, hernoemen of verwijderen.

## Rapporteer

Bondig, in het Nederlands:
- welke bronbestanden verwerkt zijn;
- welke artikelen nieuw zijn en welke bijgewerkt;
- welke verbanden je hebt gelegd;
- elk conflict met een skill;
- elke claim die je als `[ONBEVESTIGD]` hebt moeten markeren, met wat er nodig
  is om hem wél te onderbouwen.
