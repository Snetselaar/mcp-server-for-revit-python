# Lezers ronde 5 en IFC-verzoeken (viewer 3.56–3.60)

Datum: 16-11-2026. Vervolg op `2026-11-16-lezers-ronde4-viewer-3.52-3.55.md`. Zelfde werkwijze: agents per onderdeel met een harnas
in Node op steekproeven vanaf P: (alleen lezen), daarna in de browser nagerekend.

## 3.56 Technosoft
- Raamwerken, belastinggenerator: staaftype (record 0x2c), lastvelden (0x4a), windzones (0x57/0x58), windindex Qw (0x4d),
  sneeuwindex Qs (0x4e). Elke plek gevonden tegen 830 rapportparen; Qw 6.551 van 6.551 gelijk aan het rapport.
- Houtvelden staan niet in de recordketen maar in een tweede keten na record 0x0c (blokken 0xa6–0xa9); 82 houtberekeningen in de
  steekproef van 910. Betongegevens per profiel in een blok direct na 0x0c (37 van 42; vóór 6.75 andere vorm).
- Construct: invoer van module 21 (dak/gording), 22 (vloerbalklaag) en 25 tegen 391 rapporten.
- Balkroosters: lege omhullenden kwamen door het filteren van combinaties op naam; de soort staat in het record (u16 @36).

## 3.57 SCIA: resultaten en kniksystemen
- Achter het modeldeel van een .esa staat de werkmap van de solver als bestandsopslag met namen: `HXL<nr>` per belastinggeval
  (snedekrachten, vervormingen, reacties als float32) en `ETL` (som van de lasten per geval volgens de solver).
- Ingebouwd: reacties van puntsteunen per belastinggeval; som reacties = ETL in 194 van 194 gevallen bij modellen met alleen
  puntsteunen. Reacties van lijn- en vlaksteunen staan niet in de tabel.
- Kniksystemen uit EP_BucklingData; welke waarde bij y en welke bij z hoort is niet bevestigd (noot in het paneel).
- In de kop staat het einde van het modeldeel; boven 1,2 GB leest de viewer alleen dat deel.
- Les: in een inline `onchange` is `files` de eigenschap van het invoerveld, niet de bestandenlijst van de viewer.

## 3.60 SCIA: lastsom getoetst tegen ETL
Steekproef 954 bestanden, 1.623 belastinggevallen met lasten en een ETL-som. Gelijk en volledig: 1.205 → 1.456; anders en niet
gemeld: 242 → 40; geen geval van goed naar fout. Oorzaken:
1. De profieldraaiing van een staaf draait het lokale assenstelsel niet, alleen de LCS-draaiing doet dat (113 gevallen).
2. Hoek van een last (31), lijnlast "op projectie" (37, sneeuw 1 % te hoog), puntlast op een staaf in lokaal stelsel (14).
3. Staaf uit meerdere segmenten: de viewer nam alleen het eerste segment (16 gevallen; raakt ook de tekening).
4. Vlaklast op een plaat met sparingen: netto oppervlak (45 van 45 controleerbare gevallen).
5. 3D-wind: een vrije vlaklast met drukcoëfficiënt telt niet zelf als SCIA er lijnlasten uit heeft gemaakt (20 van 20).
ETL is geen zuivere toets: in enkele bestanden is hij verouderd of bevat hij maar een deel van de lasten.

## 3.58–3.59 IFC (verzoeken van de gebruiker) en Revit
- Meten en peil snappen op een doorsnede (snijsegmenten per element en vlak, in een cache per doorsnedestand); metingen en peilen
  verbergen als de doorsnede eroverheen gaat; elk model apart doorzichtig (dekking 0,4); model draaien op een vlak (klik 1 goed
  model, klik 2 scheef model, draait om het punt van klik 2); witte 3D-achtergrond.
- Revit: stramienen 2019–2023 uit het stramienrecord (43 van 43 lijnen gelijk aan de bestaande methode op 2024–2026), levels met
  hoogte (52 van 52 gelijk aan rvt-rs op 1 mm), kolommen aan levels, aantallen per categorie.

## Open
- SCIA: snedekrachten en vervormingen (koppeling snede–staaf), vrije lasten in niet-eenvoudige vorm, geknikte staven uit segmenten.
- Technosoft: uitgangspunten ouder dan 6.7 (geen rapport om tegen te toetsen), momentlasten in roosters, Construct-modules 14/18/20.
- Revit: sheets en views, liggers aan een level, 2015–2018.
