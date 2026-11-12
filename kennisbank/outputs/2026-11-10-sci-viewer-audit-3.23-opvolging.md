---
titel: Opvolging audit SCI-Viewer 3.23 (versie 3.24)
datum: 2026-11-10
vraag: "Repareer alle punten voor zo ver mogelijk"
bronnen:
  - 2026-11-10-sci-viewer-audit-3.23.md
  - "patch_324.py en meld/patch_ps6.py in de scratchpad van de sessie"
  - "getest op S-9254 (18,5 mln driehoeken), S-9070, S-9380 (TLB11), S-9231 VK-100, t.pdf"
---

# Opvolging audit 3.23

Nummers verwijzen naar het auditrapport.

## Gerepareerd in 3.24 en getest

| # | Wat | Hoe getest |
|---|---|---|
| 1 | Kleurlaag tijdens bewegen | S-9254: rode pixels 15.962 in rust, 13.866 tijdens bewegen |
| 2 | Vergelijkfilter telt niet als verborgen; bestandsnaam zegt het | nagebootst filter op S-9070 |
| 3 | Zelftest profielcorrectie; ook meerdere lichamen met dezelfde factor | S-9070: 7 stemmen voor correctie, met nagebootst goed getekende kokers vervalt alleen de kokercorrectie |
| 5 | Waarschuwing bij zwaar model | S-9254 |
| 6 | Geen straal door een zwaar model zolang de index niet klaar is | 987 ms naar 0,6 ms |
| 7 | Uitlichten begrensd tijdens bewegen | 55,4 mln naar 14,7 mln driehoeken |
| 10 | Carrosseriering, ankerrail, groep Controleren (proxy boven 250 kg) | functie los getest |
| 11 | Tekst "ook wat nu verborgen is" | |
| 13 | Lege samenstellingen weg | S-9070: 188 naar 154, 0 hangende verwijzingen in het hele bestand |
| 15 | Donkere modus markup-balk, laagvenster, menu, meldvenster | berekende stijl |
| 16 | Shift+R draait in Markups; sneltoetsenoverzicht aangevuld | nagebootste toets |
| 17 | Ctrl+V plakt alleen een echt gekopieerde markup | nagebootst klembord |
| 18 | 90° draaien (lijn, polylijn, polygoon, pen, rechthoek, ellips), voor/achter (nieuwe markups), tekstvak schaalt mee | t.pdf |
| 20 | Gekozen laag als losse laag: 30 ms naar 6,5 ms; klik die het venster activeert telt niet | S-9231 VK-100 |
| 21 | Niet-rechthoekige viewport | alleen nagebootst, geen bestand beschikbaar |
| 23 | Ontvanger 6 neemt herkomst `null` niet meer aan; Melden alleen via de ontvanger | testkopie op eigen poort |
| 24 | Controlegetallen (sha384) op 9 bibliotheken | laden geslaagd met controlegetal: three, web-ifc, pdf.js, worker, pdf-lib |
| 26 | `esc()` op de id's uit BCF | |
| 27 | `setPointerCapture` met vangnet | |
| 28 | Meldingen in eigen stijl (`confirm` en `prompt` blijven van de browser) | |
| 29 | Rooktest als script: `SCI-Viewer/test/rooktest.js` in de repo | De vaste testset zelf ontbreekt nog: de testbestanden komen uit klantprojecten |

## Punt 9 opgehelderd

Het verschil van 1,9% op TLB11 is geen fout in de uitsnijdingen, zoals de audit
aannam. De HE- en IPE-profielen wegen er 3 tot 6% te weinig en de kokers tot 5%
te veel. De staven in dat bestand zijn facetten (IfcFacetedBrep) zonder de
afrondingen van het profiel; een HEB300 zonder afrondingen is 4,2% lichter. De
correctie kan hier niet: er is geen profieldefinitie, alleen de naam. Waarneming
op tlb, aanname over de oorzaak gebaseerd op het oppervlak zonder afrondingen.

## Niet gerepareerd

**Kan alleen met de hand:**
- 4: een aangepaste markup in Revu openen.
- 14: de IFC-kopie in BIMcollab of Solibri openen.
- 22: één echte melding via de snelkoppeling, en op een tweede pc.

**Kan pas met een geschikt bestand of scherm:**
- 8: budget van de bewegingsmodus bij echt lopende animatie.
- 12: bouten uit Revit.
- 19: haperen in een echte Bluebeam-set.
- 21 (rest): gedraaide viewports. Zonder voorbeeld is de draairichting een gok.

**Bewust gelaten:**
- 5: het geheugen zelf is niet verlaagd, alleen de waarschuwing is erbij.
- 13: geometrie van weggelaten elementen blijft als wees in het bestand; onschadelijk.
- 18: meerdere markups tegelijk selecteren vraagt een keuze (botst met de
  Ctrl/Shift-selectie van opmerkingen). Tekstvakken en stempels draaien niet;
  PDF kent geen gedraaid tekstvak. Een opgeslagen stempel kopiëren niet gedaan.
- 24: de WebAssembly-bestanden, LibreDWG en dxf-parser (ES-modules) hebben geen
  controlegetal; de browser kent dat daarvoor niet. Zonder internet werken IFC,
  PDF en DWG nog steeds niet.
- 25: de dubbele id's staan in sjablonen die niet tegelijk in beeld zijn.
- 30: één bestand blijft één bestand.
