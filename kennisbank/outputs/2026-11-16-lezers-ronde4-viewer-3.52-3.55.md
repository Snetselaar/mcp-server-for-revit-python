# Lezers ronde 4: Verbindingen, GEF, SCIA-aanvulling, Raamwerken-uitgangspunten en Revit 2019–2027 (viewer 3.52–3.55)

Datum: 16-11-2026. Vervolg op `2026-11-13-lezers-ronde3-viewer-3.49-3.50.md`. Vraag van de gebruiker: "zorg dat Revit, SCIA en
Technosoft helemaal door de viewer uit te lezen zijn". Werkwijze als in ronde 2 en 3: lezers uit de viewer geknipt, in Node gedraaid op
steekproeven rechtstreeks vanaf P: (alleen lezen), vóór en na vergeleken, daarna in de browser nagerekend op voorbeeldkopieën
(`Documents\Technosoft-analyse\ronde4`, `SCIA-analyse\ronde4`, `Revit-analyse\ronde4`, elk met `BRON.txt`).

## 3.52 Technosoft Verbindingen
- De eerdere scan telde alleen extensies van drie letters op -w en miste daardoor `.vrb` (Verbindingen, 951 op P:) en `.cdlw`.
  `.adw/.gdw` (Tekla-attributen), `.axw` (AxisVM), `.pgw` (wereldbestand) en `.brw` zijn geen Technosoft.
- `.vrb` is INI-tekst; 950 van 951 gelezen. Tegen 76 rapporten naast het bestand: type, profielen, plaatmaten, lassen, bouten en
  krachten gelijk; de afwijkingen zitten in vijf bestanden die na het rapport zijn opgeslagen. De toetsing zelf staat niet in het bestand.

## 3.53 SCIA en Technosoft-restpunten
- SCIA, twee fouten in de lastsom: (1) een lastpositie in meters ("Abso") werd over de hele staaf of rand geteld (2.203 lasten in 32
  van 218 modellen); (2) een puntlast op een staaf met herhaling n telde één keer. ΣF verandert in 38 modellen, alle verklaard.
- SCIA nieuw: niet-lineaire en stabiliteitscombinaties, vrije lijn- en puntlasten, momenten (nooit in ΣF), lijnscharnieren,
  starre armen, lastpanelen, kipsteunen, verdiepingen, staven alleen trek/druk, bogen en cirkels als kromme.
- Raamwerken: uitgangspunten, gewichtsberekening, beddingen, staaftype, vloeigrens, doorbuigingseis; plek per veld gevonden door
  830 rapporten naast de bestanden te leggen. Zeeg ontbrak t/m 6.80 (75 bestanden in de steekproef van 910).
- Balkroosters: scharnierende balkeinden in de eigen roosterberekening (106 van 774); momentlasten geprobeerd en niet ingebouwd
  (tegen de rapporten werd het slechter).

## 3.54 GEF-sonderingen
Alle 4.435 `.gef` op P: gedraaid: 4.142 sonderingen gelezen, 262 boringen en 25 dissipatietesten geven een melding. Hard bewijs:
1.544 sonderingen die ook in een `.pvw` staan hebben dezelfde qc; maaiveld gelijk in 1.539. Praktijkvalkuilen: negatieve
gecorrigeerde diepte (114 bestanden), void ±9999 zonder `#COLUMNVOID`, diepte uit de helling als kolom 11 ontbreekt (zo rekent
Technosoft ook).

## 3.55 Revit
- Scan: 3.360 `.rvt` vanaf project 8000; versies 2015–2027, zwaartepunt 2024 (1.058). De eigen lezer dekte alleen 2025–2027 (25 %).
- **Bladindeling:** elke stroom in een rvt bestaat uit bladen van 65.249 bytes (64.896 inhoud + 353 die er niet bij horen). Zonder
  die regel geeft de deflate na het eerste blad stil verkeerde uitvoer. Bewijs: 285 van 287 stromen byte-gelijk aan `rvt-dump` van
  rvt-rs 0.19. Dit verklaart de eerdere spookstaven en de onbruikbare ElemTable.
- Na de patch: staven en profielen voor 2019–2027 (steekproef 56: 47 met staven, 9 alleen gegevens, 0 fouten); S-9424 R26 geeft
  850 staven, gelijk aan Revit. Bestandsgegevens (versie, worksharing, projectinformatie, koppelingen, voorbeeld, opslaghistorie)
  voor elke versie.
- Niet: stramienen 2019–2023, staalkwaliteit 2019–2023 (ongetoetst), 2015–2018 (alleen gegevens), levels, sheets, fasen.

## 3.55 overig
- IFC: meegeladen model uitlijnen op twee metingen langs dezelfde wand (draaien + verschuiven); getoetst op twee testmodellen
  (17,5° en 14 m): binnen 0,2 mm.
- "Wat is er nieuw" toont alleen de eerste zin; changelogregels noemen geen aantallen gescande bestanden meer (verzoek gebruiker).

## Open
- Revit: stramienen 2019–2023, levels en elementenlijst (de wasm-module kan dit, `rvt-worker.js` gebruikt het niet).
- SCIA: kniklengtes, rekenresultaten (achter het modeldeel, ander blokformaat), vinkje voor lastpanelen.
- Technosoft: belastinggenerator Raamwerken, hout- en betonvelden met wapening, invoervelden per Construct-module.
