# Stijlgids

Regels voor alles wat Claude in `wiki/` en `outputs/` schrijft. Ze zijn
toetsbaar geformuleerd, want `/kb-check` controleert erop.

---

## Taal en toon

1. **Nederlands.** Vaktermen die in het Nederlands niet bestaan blijven Engels
   (*worksharing*, *pushbutton*, *transaction*). Vertaal ze niet geforceerd.
2. **Analytisch en precies.** Een onderbouwde formulering weegt zwaarder dan een
   vlotte. Dit is documentatie voor jezelf over een jaar, geen blogpost.
3. **Actieve vorm.** "Het script leest de parameter op naam", niet "de parameter
   wordt op naam gelezen".
4. **Korte zinnen.** Twee bijzinnen is het maximum. Bij drie: knip.

## Verboden constructies

5. **Geen opsommings-inleidingen.** Schrijf niet "Hier zijn drie punten:" of
   "Laten we eens kijken naar". Begin bij het punt.
6. **Geen AI-vulwoorden.** Verboden, ook in verbogen vorm: *cruciaal, essentieel,
   naadloos, krachtig, robuust, elegant, moeiteloos, het is belangrijk op te
   merken, het is de moeite waard te vermelden, duik in, ontgrendel, benut,
   in het huidige landschap*. Als het woord wegvalt zonder betekenisverlies,
   hoort het er niet.
7. **Geen samenvattende afsluiter.** Geen "Kortom" of "Samengevat" aan het eind
   van een artikel. Het artikel is de samenvatting.
8. **Geen drie-op-een-rij.** Niet elke opsomming hoeft drie items te hebben.
   Twee is prima, vijf ook.
9. **Geen em-dashes als stopwoord.** Eén per alinea, hooguit. Gebruik een punt
   of een komma.
10. **Geen loze bijvoeglijke naamwoorden bij getallen.** Niet "een indrukwekkende
    30 gekoppelde modellen" — "30 gekoppelde modellen".

## Inhoud

11. **Echte namen en getallen.** `NLRS_16_SF_LIB_balk met wapening`, sheet
    `TO-121`, model `S-8985`, port `48884`. Geen generieke voorbeelden
    (`MyFamily`, `foo`) als het echte voorbeeld bekend is.
12. **Onzekerheid expliciet.** "Ik weet niet of dit in 2027 nog geldt" is een
    geldige zin. `[ONBEVESTIGD]` is de markering; zie `CLAUDE.md` §6.
13. **Elke claim een bron.** Zie `CLAUDE.md` §6. Bij code in deze repo:
    `revit_mcp/status.py:15`. Bij de Revit API: de opgezochte URL.
14. **Negatieve kennis telt.** "Per-link categorie-zichtbaarheid is niet
    scriptbaar" is net zo waardevol als een werkende oplossing, en voorkomt dat
    het pad opnieuw wordt ingeslagen. Leg mislukte pogingen vast, met de reden.
15. **Datum bij alles wat kan verlopen.** Versienummers, API-gedrag, paden op
    `W:`, prijzen, teamafspraken. Zonder datum kan `/kb-check` niet zien dat het
    oud is.

## Opmaak

16. **Kop is een onderwerp, geen zin.** `## IFC-exportconfiguraties`, niet
    `## Hoe je IFC-exportconfiguraties gebruikt`.
17. **Codeblokken met taal-tag.** ` ```python `, ` ```json `. Bij IronPython:
    noteer dat het IronPython 2.7 is, want de syntaxbeperkingen zijn relevant.
18. **Tabel bij drie of meer vergelijkbare items.** Anders een lijst.
19. **Geen bold-spam.** Bold voor het begrip dat gedefinieerd wordt, niet voor
    nadruk op willekeurige woorden.
