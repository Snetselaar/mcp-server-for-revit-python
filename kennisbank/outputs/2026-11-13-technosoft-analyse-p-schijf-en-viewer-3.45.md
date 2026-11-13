# Technosoft-bestanden van P: geanalyseerd, viewer 3.45

Datum: 13-11-2026. Vraag: hetzelfde als voor SCIA (zie `2026-11-13-scia-analyse-p-schijf-en-viewer-3.44.md`), nu voor
Technosoft: P: scannen, kopie op de eigen schijf, analyseren en inbouwen in de SCI-Viewer.

## Scan
P: alleen gelezen, projecten vanaf 8000: 23.121 Technosoft-bestanden.

| Extensie | Programma | Aantal | Viewer vóór 3.45 |
|---|---|---|---|
| .rww | Raamwerken | 16.375 | gelezen |
| .dlw | Liggers | 3.429 | gelezen |
| .cnw | Construct | 1.565 | alleen hout |
| .grw | Balkroosters | 777 | gelezen |
| .pvw | Paaldraagvermogen | 481 | niet |
| .klw | Kolommen | 227 | niet |
| .fsw | Funderingen op staal | 187 | niet |
| .dmw | Damwanden | 23 | niet |

Kopieën: 21 bestanden in `C:\Users\S-WOU1A\Documents\Technosoft-analyse` met `BRON.txt`.

## Bevindingen per lezer (bewijs: Node-harnas op de kopieën, daarna browsertest)
- **Raamwerken** (5 bestanden, alle versie 6.85): de lezer stopte bij het eerste belastinggeval. Het record van een
  belastinggeval is 1 byte korter dan zijn kop zegt; met die correctie loopt de recordketen door tot en met de combinaties.
  Gelezen: belastinggevallen, lasten, combinaties, belastingbreedte, verende opleggingen en verbindingen, E en sterkte,
  traagheidsmomenten. Bewijs o.a. 9217: wind op gevel as 1 ΣFx +592 kN, as 14 −592 kN.
- **Balkroosters** (3): in versie 6.80 is het belastinggevalrecord 182 lang (6.83: 184) en het beugelrecord 168; daardoor
  ontbraken bij 8543 de belastinggevallen en dus de paalreacties. De kopvelden nummer, opdrachtgever en paraaf staan op
  @830/@842/@910.
- **Liggers** (3): doorsnede van type 0 werd overgeslagen; bij één sector geldt de doorsnede van de sector; wapening ontbrak.
- **Construct** (3): twee bestanden bevatten alleen betonberekeningen en openen niet; de melding noemt nu de berekeningen.
- **Paaldraagvermogen, Funderingen op staal, Damwanden**: andere opslagvorm (doorlopende stroom, `<eor>` als scheiding).
  Getoetst op 12 + 12 + 7 bestanden tegen de Technosoft-rapporten die ernaast stonden. Het draagvermogen staat niet in het
  .pvw-bestand (Technosoft rekent bij het openen); het komt uit het rapport (.rtf).
- **.klw**: 9 van 10 steekproeven zijn binair (`twkol`), niet RTF. Niet ontleed.

## In de viewer (3.45, live)
Nieuwe soorten openen met een tekening van sondering en grondlagen en een zijpaneel; Raamwerken toont lasten en
combinaties (klik op een geval); Balkroosters 6.80 rekent weer; Liggers tonen de juiste profielen en de wapening.

## Open
- Scharnierende balkeinden zitten niet in de eigen roosterberekening (losse patch beschikbaar, niet tegen Technosoft getoetst:
  paalreacties verschuiven gemiddeld 1,6 %, hoogstens 17 %).
- Lasttype 12 in Balkroosters (vermoedelijk een koppel) wordt getoond, niet meegerekend.
- Damwand: profiel, bouwfasen en ankers niet ontleed. Kolommen (.klw) niet ontleed.
- Geen Technosoft beschikbaar om tegen te controleren; waar een rapport ontbrak berust het op interne samenhang.
