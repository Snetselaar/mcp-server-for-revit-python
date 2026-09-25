---
titel: Structural connection blijft aan een gekopieerd profiel hangen
status: concept
laatst-bijgewerkt: 2026-09-17
bronnen:
  - "waarneming van de gebruiker 2026-09-17: gekopieerd profiel met een structural connection naar een kolom bleef vastzitten nadat de kolom weg was"
  - "waarneming van de gebruiker 2026-09-17: ligger splitten en het stuk met de connection deleten lost het op, en is sneller dan de connection zelf opzoeken"
verwant: []
---

# Structural connection blijft aan een gekopieerd profiel hangen

Aanleiding: een stalen profiel had een structural connection naar een kolom.
Na het kopiëren van het profiel ging de connection mee. Op de nieuwe plek staat
geen kolom, maar het profiel bleef zich gedragen alsof het vastzat. Model en
Revit-versie zijn niet vastgelegd.

## 1. Werkende oplossing: splitten en deleten

De gebruiker heeft dit op 2026-09-17 in de praktijk gedaan:

1. Splits de ligger met Split Element (`SL`) vlak bij het uiteinde waar de
   connection aan zit.
2. Delete het korte stuk met de connection.
3. Trek het overgebleven uiteinde terug naar de gewenste lengte.

Volgens de gebruiker gaat dit sneller dan de connection zelf selecteren.

Aandachtspunten, niet getoetst:

- [ONBEVESTIGD] Na een split houdt één stuk het oorspronkelijke element-ID en
  krijgt het andere een nieuw ID. Delete je het stuk met het oude ID, dan raak
  je tags, Mark en IFC-GUID van de ligger kwijt. Bij een net gekopieerd profiel
  weegt dat meestal niet.
- [ONBEVESTIGD] Instanceparameters gaan bij de split mee naar beide stukken.
- [ONBEVESTIGD] De connection verdwijnt met het gedelete stuk. Controleer dat
  in Manage → Warnings.

## 2. Alternatief: de connection zelf verwijderen

Deze route is als advies gegeven, maar de gebruiker heeft haar niet
uitgeprobeerd. Alles hieronder is dus [ONBEVESTIGD]:

- Zet in een 3D-view de categorie Structural Connections aan en gebruik
  detail level Medium of Fine. Selecteer de connection met Tab op het
  uiteinde en delete haar.
- Een losse connection geeft meestal een waarschuwing. Via Manage → Warnings
  selecteer je het element vanuit die melding.
- Bij veel kopieën werkt een schedule van Structural Connections. Daarin kun
  je rijen selecteren en verwijderen.
- Blijft het uiteinde daarna aan iets vastzitten, klik dan met de
  rechtermuisknop op de grip en kies Disallow Join. Zet Start/End Extension en
  Start/End Join Cutback terug op 0.
- Cope-, cut- en plate-bewerkingen zijn losse elementen op het profiel. Ze
  gaan niet mee weg met de connection.

## 3. Open vragen

- Kopieert Revit de connection altijd mee, of alleen als het profiel bij het
  kopiëren nog aan de kolom vastzit?
- Geeft Revit een waarschuwing als een connection nog maar aan één element
  hangt?
