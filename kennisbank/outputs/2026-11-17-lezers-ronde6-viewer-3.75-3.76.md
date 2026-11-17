# Lezers ronde 6 en IFC ontleden (viewer 3.75–3.76)

Datum: 17-11-2026. Vervolg op `2026-11-16-lezers-ronde5-viewer-3.56-3.60.md`.

Werkwijze: drie agents (scia4, rvt3, tech6) met een harnas in Node. Ze werkten op steekproeven vanaf P: (alleen lezen), met kopieën in `Documents\*-analyse\ronde6`. Daarna is alles in de browser nagerekend.

## 3.75 SCIA: snedekrachten en vervormingen
- **Bron:** dezelfde `HXL<nr>`-resultaten als de reacties. De snedetabel komt in twee vormen voor: 12 of 20 bytes per snede. In de nieuwe vorm staan begin- en eindknoop in de snede zelf, in de oude vorm in `E1D`.
- **Koppeling solverstuk → modelstaaf:** de solver knipt een staaf op de knopen die erop liggen.
  - Eerst wordt gekoppeld op volgorde en lengte, getoetst op de plek van elke knoop (2 mm). Lukt dat niet, dan op geometrie.
  - Twee staven op dezelfde plek zijn niet te onderscheiden.
- **Steekproef van 954 bestanden:**
  - 527 hebben snedekrachten. 521 daarvan zijn gekoppeld (50.314 van 52.797 staven); 6 niet, omdat er twee staven op dezelfde plek liggen.
  - Getoetst tegen de opgeslagen staalcontroles (`.IP_ESA_TABLE`): 32 van de 37 rekenwaarden die niet nul zijn kloppen binnen 0,5 %. De 5 afwijkingen zitten in 2 bestanden, vermoedelijk met een controle van een oudere berekening.
- **Geknikte en gebogen staven:** in het staafrecord zijn de knoopverwijzingen gegroepeerd (2 = lijnstuk, 3 = boog A-B-M). De lastsom en de tekening gebruiken nu de hele lijn. Luifel EC, BG2: de lastsom was −510 N, is nu −1548 N; de som van de reacties is 1547 N.
- **Open:**
  - niet-lineaire resultaten (`RN_`);
  - combinaties (het bestand bevat alleen belastinggevallen);
  - een staafsteun op een geknikte staaf;
  - vrije vlaklasten met een verloop.

## 3.75 Revit: bladen en views (2019–2027)
- **Soort view:** het viewtype-record eindigt op de ViewFamily-waarde, gelijk aan de enum in RevitAPI.dll 2024 en 2027 (102 3D, 107 blad, 109 plattegrond, 112 doorsnede, 113 detail, 114 aanzicht, 117 legenda, 120 constructieve plattegrond).
- **Per versie anders:** alleen de code vóór het naamveld en de plaats van de verwijzing naar het viewtype (22 bytes vanaf 2024, 122 bytes in 2019–2023).
- **Getoetst** tegen bladnamen uit PDF-bestandsnamen op P:: Cunera 19 van 19, 9424 7 van 7.
- **Niet gebouwd:**
  - Reference Level van een ligger. De regel "laatste level in de verwijzingslijst" klopte in 8174 486 van 486 keer, maar in 9424 maar 146 van 161 keer.
  - Revit 2015–2018: 25 van 3.371 bestanden, vrijwel alle conversies.
- **Bediening:** bij Revit 2022+ komen de bladen pas na de knop "Staven, bladen en views lezen". Ze komen uit dezelfde scan als de staven, en die scan kan minuten duren.

## 3.75 Technosoft
- **Construct, modules 14 (staal) en 18 (hout):** een blok van 236 bytes met f32-waarden. Getoetst tegen 3 rapporten. In module 14 vanaf 6.71 staat alleen de profielreeks in de naam, de maat niet.
- **Balkroosters, momentlasten:** type 12 is een koppel in het vlak van de balk. Een moment binnen 5 cm van een bestaande knoop gaat naar die knoop, omdat een heel kort element de oplossing onnauwkeurig maakt.
  - Getoetst tegen 224 rapporten: palen binnen 2 % (fundamenteel min) van 2.522 naar 2.612 van 3.358; geen paal van goed naar fout.
  - Rest in Ouderkerk: de belastingsoort "Schaakbord".
- **Raamwerken ouder dan 5.26:** u16 @2 van record 0x47 is de veiligheidsklasse uit de TGB. Klasse 3 gaat samen met factor 1,5 (85 van 94 bestanden), klasse 2 met 1,3 (19 van 25).

## 3.76 IFC: samengestelde elementen ontleden
- **Aanleiding:** een aannemers-IFC (Revit 2027, IFC2X3, 163 MB, 2.180 IfcBuildingElementProxy). Families met niet-gedeelde geneste onderdelen worden één element met veel vormstukken (IfcMappedItem → IfcRepresentationMap met veel items). Voorbeeld: "Steel filling hall 17,4 m" met 260–405 vormstukken per element. De 130 Revit-modelgroepen (IfcGroup) waren níét het probleem: hun leden zijn al losse elementen.
- **Oplossing:**
  - Elk vormstuk krijgt een pseudo-id (≥ 2^24). `ifcId()` voert terug naar de ouder voor eigenschappen, GUID/BCF, lijsten en relaties.
  - Alles ontleden duurt 0,3 s en geeft 69.874 onderdelen.

## Prestaties grote IFC (gemeten, nog niet opgelost)
- **Gemeten op hetzelfde model:**
  - 12,5 M driehoeken in beeld;
  - JS-heap 3,1–3,2 GB;
  - laden 20 s;
  - tekenen 5–6 ms per beeld (RTX PRO 2000);
  - een klik om te selecteren 341–423 ms (raycast).
- **Herhaling:** 70.077 plaatsingen van 9.967 unieke vormen, dus 1,3 M unieke driehoeken. Hergebruik (instancing, zoals BIMcollab) scheelt 90 %.
- De pc van de collega die het haperen meldt is even snel. Het zit dus in geheugen en klikken, niet in het tekenen.
- Instancing en GPU-picking zijn in bewerking.
