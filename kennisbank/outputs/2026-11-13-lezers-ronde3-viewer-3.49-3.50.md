# Lezers ronde 3: oude Technosoft-formaten en SCIA-plaatlasten, viewer 3.49 en 3.50

Datum: 13-11-2026. Vervolg op `2026-11-13-breedtetoets-lezers-viewer-3.46-3.48.md`. Zelfde werkwijze: lezers uit de viewer geknipt en
in Node gedraaid op steekproeven vanaf P: (alleen lezen), vóór en na de patch op dezelfde steekproef vergeleken.

## 3.49: oude Technosoft-bestanden
- **Raamwerken 3.7x en ouder** (binaire opslagvorm; 117 bestanden op P:, gevonden door de kop van alle 16.375 Raamwerken-bestanden te
  lezen). Belastinggevallen, lasten en combinaties worden nu gelezen; 117 van 117 openen. Getoetst tegen hetzelfde model dat later in
  versie 5.31 is opgeslagen: gevallen, lasten, sommen (−40,25 en −64,4 kN) en combinaties gelijk.
  ψ-factoren staan niet in deze bestanden; de viewer toont "–" in plaats van 0,0.
- **Paaldraagvermogen ouder dan bestandsversie 0x0369** (9 op P:): 9 van 9 openen met bodemprofielen en sonderingen. De grondsoortnaam
  is niet opgeslagen en wordt afgeleid uit de grondcode (melding in het paneel); γ, φ′ en c′ staan er niet in.

## 3.50: SCIA-lasten op platen
Steekproef 218 modellen (P: en de kopieën in `Documents\SCIA-analyse`). Lasten buiten de som: **3.017 → 57**. Aantallen, namen,
profielen en `klopt` zijn in alle 218 ongewijzigd; alleen sommen veranderen.

| Onderdeel | Regel | Bewijs |
|---|---|---|
| Vlaklast lokaal | lokale z = plaatnormaal met de grootste globale component positief; een vlag in het plaatrecord draait z om | vloeren: 477 permanent/veranderlijk omlaag, 23 grondwater/wind omhoog; wanden: grond-/waterdruk 34 van 34 naar binnen (25 van 34 zonder vlag) |
| Lijnlast op plaatrand | randnummer wijst in de randenlijst van de plaat (niet in de knoopverwijzingen); stelsel 1 = lokaal | 594 verticale lasten op de bovenrand van wanden; liftwand wind 1/3 −486/+486 kN, 2/4 −490/+490 kN |
| Vrije vlaklast | alleen gelijkmatig, loodrecht op de richting en met het midden op een plaat; vrije lasten met door SCIA gegenereerde lijnlasten tellen via die lijnlasten | 759 van 789 kandidaten liggen op een plaat; ketelhuis LC3 −50 kN/m² × 161,5 m² = −8.075 kN |

In de browser nagerekend op zes modellen (ketelhuis, liftwand, liftput, kern, Hilco-kelder, sciatest): alle sommen gelijk aan de
harnasuitkomst, geen NaN.

## 3.51: plaatvorm uit de randenlijst
Bij 329 van 1.500 platen volgden de knoopverwijzingen de echte omtrek niet. De omtrek komt nu uit de randen-/puntenlijst (terugval op
het oude gedrag als die niet sluit). Steekproef: 1.458 van 1.458 gelezen platen uit de randen; 100 gecorrigeerd (oud: 47
zelfdoorsnijdend, 35 niet vlak, 15 driehoek i.p.v. vierhoek), 17 nieuw gelezen; lastsommen in 218 van 218 gelijk. Browser: Hilco
Kelderwand 418 = vierhoek K204–K3–K184–K207; sciatest E11 611,49 m² (was 372,6), sparingen in een plaat 7 (was 1).

## Open
- Bogen nog als koorde door het middenpunt; deelgebieden (EP_SubSlab) nog via de knoopverwijzingen; 69 weggevallen knopen in S8328
  liggen in het plaatvlak maar buiten de nieuwe omtrek (niet hard bewezen zonder SCIA).
- SCIA: vrije lijn- en puntlasten, 3D-wind zonder gegenereerde lasten, lokale lasten op schuine platen en randen met een boog.
- Damwand: ankertype en -richting. Balkroosters: momenten en scharnieren in de eigen roosterberekening. Raamwerken:
  combinatieregelsoort 3.
