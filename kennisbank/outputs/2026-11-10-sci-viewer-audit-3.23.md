---
titel: Audit SCI-Viewer 3.23 (alleen rapport, niets gewijzigd)
datum: 2026-11-10
vraag: "Voer een audit uit op de viewer op alle onderdelen maar wijzig niks. Alleen rapporteren."
bronnen:
  - "\\\\NAS01\\Data-SCI\\01. BIM Software\\SCI-Viewer\\SCI-Viewer.html (3.23, byte-gelijk aan de geauditeerde kopie)"
  - "\\\\NAS01\\Data-SCI\\01. BIM Software\\SCI-Viewer\\SCI-Viewer-log.ps1 en SCI-Viewer-start.ps1 (ontvanger versie 5)"
  - "statische scan audit4.py in de scratchpad van de sessie (629 functies, 225 id's, 15 externe adressen)"
  - "rooktest in de testomgeving: 18 bestanden geopend, alle tabbladen doorlopen"
  - "metingen uit dezelfde sessie: S-9254 (18,5 mln driehoeken), Tekla-gewichten m.ifc / z9070 / tlb, S-9231 BA-005 en VK-100"
---

# Audit SCI-Viewer 3.23

Er is niets aan de viewer, de ontvanger of de changelog gewijzigd. Dit rapport is
bedoeld als werklijst voor de volgende ronde.

## Wat deze audit wel en niet is

**Wel gedaan**

- Statische scan van de hele code (zonder de ingebedde data): dubbele functies,
  dubbele id's, externe adressen, `eval`, ontbrekende `esc()`, toetsafhandeling,
  `localStorage`, versieregel tegen changelog.
- Rooktest: 18 testbestanden geopend (4 rww, 2 cnw, 2 dlw, 3 esa, 1 stp, 3 grw,
  1 dxf, 1 dwg, 1 pdf), daarna alle tabbladen en zijpanelen doorlopen.
  Resultaat: geen fouten, geen waarschuwingen.
- Gerichte doorloop van alles wat sinds 3.13 is bijgekomen (staallijst,
  bewegingsmodus 3D, PDF-markups, PDF-onderlaag, DWG-layouts en laagkeuze,
  IFC-export zonder verborgen elementen, knop Melden) en van het ontvangerscript.

**Niet gedaan**

- De oudere onderdelen (Technosoft/SCIA-lezers, vakwerk, BCF, sets, spelling,
  revisievergelijking) zijn niet opnieuw regel voor regel gelezen. Die zijn op
  3 en 4 november geauditeerd; hier alleen de rooktest.
- Geen test met een groot IFC, een echte Bluebeam-set, een RVT, BCF, afdrukken,
  iPad of een tweede pc. De testkopieën van klantmodellen zijn steeds verwijderd.
- De testomgeving draait in een verborgen venster zonder lopende animatie.
  Alles wat van beeldjes per seconde afhangt is met nagebootste tijden getest.

Bij elke bevinding staat hoe zeker hij is: **gemeten** (in de viewer
vastgesteld), **uit de code** (afgeleid, niet nagebootst) of **open** (nooit
getest).

## Samenvatting

Geen bevinding die de viewer laat vastlopen of gegevens beschadigt. Wel vijf
punten die een verkeerd beeld of een verkeerd bestand kunnen geven:

| # | Onderdeel | Bevinding | Ernst | Zekerheid |
|---|---|---|---|---|
| 1 | IFC 3D | Kleurlaag valt weg tijdens bewegen bij grote modellen | middel | gemeten (oorzaak), uit de code (beeld) |
| 2 | IFC-export | "Verborgen weglaten" telt ook het vergelijkfilter mee en staat standaard aan | middel | uit de code |
| 3 | IFC gewicht | Profielcorrectie hangt aan het tekengedrag van web-ifc 0.0.77 | middel | gemeten |
| 4 | PDF-markups | Opgeslagen Bluebeam-markups: meer velden herschreven, nooit in Revu teruggelezen | middel | open |
| 5 | IFC 3D | Geheugen bij S-9254: 2,7 GB | middel | gemeten |

Daarnaast 20 lagere punten, hieronder per onderdeel.

## Bevindingen per onderdeel

### IFC 3D

**1. Kleurlaag valt weg tijdens bewegen (middel).**
De bewegingsmodus (3.20, `vlotBouw`) maakt per mesh een tweede geometrie die de
attributen van het origineel deelt. Het attribuut `color` wordt pas toegevoegd
als er een kleurlaag aan gaat (`zetKleuren`). Is de bewegingsgeometrie dan al
gebouwd, dan heeft die het attribuut niet. Gemeten: na `vlotBouw` en daarna
`zetKleuren` heeft het origineel `color`, de bewegingsgeometrie niet. Het
materiaal staat dan wel op kleur per hoekpunt, dus tijdens draaien en zoomen
tekent het model vermoedelijk zwart of zonder de kleurlaag. Raakt: Structural
Usage, materiaal, versievergelijking, alleen bij modellen boven 2,5 miljoen
driehoeken. Hetzelfde risico geldt voor elk attribuut dat later wordt
toegevoegd. Voorstel: bij `zetKleuren` de bewegingsgeometrie ongeldig maken, of
de attributen bij elke start van een beweging gelijktrekken.

**5. Geheugen (middel).** S-9254 (444 MB, 18,5 mln driehoeken) gebruikt 2,7 GB
in de browser. De grens van een tabblad ligt rond 4 GB. Twee van zulke modellen
in één beeld, of randen aan (300 MB extra, eerder gemeten), komt daar dichtbij.
Er is geen waarschuwing vooraf. Voorstel: waarschuwen op bestandsgrootte en het
aantal driehoeken tonen.

**6. Eerste seconden na laden traag aanwijzen (laag, gemeten).** Tot de
zoekindex klaar is kost één straal onder de cursor 987 ms op S-9254. De eerste
zoom of klik hapert dus. Voorstel: melding "index wordt opgebouwd" of het
draaipunt zolang op het midden van het beeld.

**7. Bewegingsmodus helpt niet bij Uitlichten (laag, uit de code).** De
spooklaag en de magentalaag tekenen het volledige model, ook tijdens bewegen.

**8. Bijstelling van het budget nooit echt gemeten (laag, open).** `vlotMeet`
is alleen met nagebootste tijden getest. Op een snel scherm (120 Hz) of een
trage videokaart kan het budget anders uitpakken dan bedoeld.

### IFC staallijst en gewicht

**3. Profielcorrectie hangt aan web-ifc 0.0.77 (middel, gemeten).**
`profielFactor` corrigeert dat web-ifc kokers met halve wanddikte tekent en
I-profielen met een schuine hoek. Getoetst op Tekla-gewichten (totaal 0,9985 en
0,9989). Wordt web-ifc ooit bijgewerkt en tekent die het goed, dan worden
kokers twee keer te zwaar zonder enige melding. De correctie werkt ook alleen
als het lichaam uit één onderdeel bestaat. Voorstel: bij het laden één koker
natellen (getekend oppervlak tegen het profiel) en de correctie alleen
toepassen als de afwijking er echt is.

**9. Verschil van 1,9% met Tekla op tlb onverklaard (laag, gemeten).** Per
element is de middelste afwijking 0%, het totaal is 1,9% lager. De aanname is
dat Tekla uitsnijdingen niet aftrekt. Dat is niet nagegaan.

**10. Indeling op naam heeft gaten (laag, gemeten).**
- `CARROSSERIERING` (Tekla, als IfcBeam) telt als Ligger: 349 stuks, 9 kg.
- `muurplaat` (Revit Generic Model, materiaal S235) telt als Strip/plaat met
  19.005 kg voor 19 stuks. Dat volume lijkt niet op een stalen plaat.
- Alles met `ANKER` in de naam is Anker, dus ook een ankerrail.
Voorstel: een regel "onzeker" in de lijst voor wat alleen op klasse is ingedeeld,
en een bovengrens op kg per stuk voor Generic Models.

**11. "Hele model" telt ook verborgen elementen (laag, uit de code).** De
staallijst kijkt niet naar zichtbaarheid, de IFC-export sinds 3.23 wel. Dat is
verdedigbaar, maar het staat nergens in beeld.

**12. Bouten alleen uit Tekla getoetst (laag, open).** In de geteste
Revit-modellen zaten alleen draadeinden en ankers.

### IFC-export met kleuren

**2. "Verborgen weglaten" is breder dan het woord zegt (middel, uit de code).**
`ifcVerborgen` gebruikt `isZicht`. Daarin zit ook het filter van de
versievergelijking. Staat dat filter aan, dan verdwijnen de weggefilterde
elementen uit de kopie. Het vinkje staat standaard aan en het bestand heet nog
steeds "(kleuren).ifc". Voorstel: het vergelijkfilter niet meetellen, en de
bestandsnaam aanpassen als er iets is weggelaten.

**13. Alleen relaties worden opgeschoond (laag, uit de code).** Verwijzingen
naar een weggelaten element vanuit iets anders dan een `IFCREL…`-regel blijven
staan. Op tlb gaf dat 0 hangende verwijzingen in de relaties; andere regels zijn
niet geteld. Lege samenstellingen (IfcElementAssembly waarvan alle delen weg
zijn) blijven in de boom staan. De geometrie blijft als wees in het bestand.

**14. Niet in een ander programma geopend (open).** De kopie opent in de
viewer zelf. BIMcollab, Solibri en Revit zijn niet geprobeerd.

### PDF en markups

**4. Opgeslagen Bluebeam-markups (middel, open).** Sinds 3.15 kun je een
opgeslagen markup aanpassen; sinds 3.21 schrijft `bbBronOpslaan` daarbij ook
lijndikte, vulling, dekking en tekststijl terug en tekent het uiterlijk opnieuw.
Een wolk uit Revu krijgt daarbij de boogjes van de viewer. Geen enkele
aangepaste markup is ooit in Revu teruggelezen. Dit is het oudste open punt.

**15. Kleurstalen kloppen niet in de donkere modus (laag, uit de code).** De
donkere modus keert de hele pagina om en zet voor een vaste lijst elementen een
tegenfilter. De nieuwe werkbalk, de eigenschappenbalk, het rechtsklikmenu, het
laagvenster van de DWG en het meldvenster staan niet in die lijst. Gemeten: de
balken hebben geen eigen filter. Rood in het palet toont dan als cyaan.

**16. Sneltoetsen (laag, uit de code).**
- In het tabblad Markups draait R het blad niet meer; alleen de knop ⟳.
- De letters werken ook als het zijpaneel dicht is, zolang het tabblad Markups
  het laatst gekozen was.
- Er zijn 38 toetsluisteraars op het venster, 4 daarvan onderscheppen eerst.
  Welke wint hangt van de volgorde af. Er is geen overzicht van alle toetsen.

**17. Plakken na "Kopiëren" uit het menu (laag, uit de code).** Daarna plakt
elke Ctrl+V zonder afbeelding die markup opnieuw, ook als je intussen iets
anders hebt gekopieerd.

**18. Nog niet aanwezig.** Meerdere markups tegelijk selecteren (botst met de
Ctrl/Shift-selectie van opmerkingen), draaien, volgorde voor/achter, een
opgeslagen stempel kopiëren. Tekst groter maken houdt het vak even breed.

**19. Haperen in een echte set niet nagebootst (open).** 3.22 breekt lopend
tekenwerk af en legt een onderlaag van het hele blad. Getest op PDF's die in
50 tot 650 ms tekenen. Bij revisievergelijking is er geen onderlaag.

### DWG en DXF

**20. Elke klik opent het laagvenster (laag, uit de code).** Ook een klik om
alleen het venster te activeren. De gekozen laag kleurt oranje en dat tekent de
hele tekening opnieuw; bij een zware DWG is dat merkbaar.

**21. Layouts: wat nog ontbreekt (laag, gemeten op S-9231).** Gedraaide
viewports, niet-rechthoekige viewports en het papier zelf (formaat, rand) worden
niet getekend. Bij DXF worden per viewport bevroren lagen niet gelezen.
Niet naast AutoCAD gelegd.

### Knop Melden en de ontvanger

**22. Nooit van begin tot eind getest (middel-laag, open).** De ontvanger is
met een kopie op een andere poort getest, het venster met een nagebootst
antwoord. Een echte melding via de snelkoppeling, en op een tweede pc, is niet
gedaan.

**23. Herkomst "null" wordt geaccepteerd (laag, uit de code).** De ontvanger
neemt berichten aan zonder herkomst of met herkomst `null`. Dat is nodig voor
de oude `file://`-pagina, maar een willekeurig lokaal HTML-bestand kan zo ook
regels in het gebruikslog en de meldingen zetten. Luistert alleen op deze pc,
maximaal 16 kB, formules worden onschadelijk gemaakt.

### Algemeen

**24. Bibliotheken van internet zonder controle (laag-middel, gemeten).** 15
adressen bij jsdelivr en cdnjs, alle met vast versienummer, geen enkele met een
controlegetal (`integrity`). De zoekindex-bibliotheek wordt als tekst opgehaald
en met `eval` uitgevoerd. Zonder internet werken IFC, PDF, DWG en spelling niet.

**25. Dubbele id's in sjablonen (laag, gemeten).** `vkProfLijst`, `rwwNaam`,
`rwwTol`, `rwwVerleng` en `lagenPaneel` komen twee keer voor in de broncode.
Voor zover nagegaan zijn het alternatieven die niet tegelijk in beeld staan;
voor `vkProfLijst` is dat niet zeker.

**26. Eén plek zonder `esc()` in een attribuut (laag, gemeten).** De GUID van
een issue (`data-issue`, `data-isbew`, `data-isweg`) komt bij BCF-import uit het
bestand en gaat ongefilterd de pagina in. Alle andere vrije tekst die de scan
vond gaat via `esc()` of komt niet in de HTML.

**27. Vier keer `setPointerCapture` zonder vangnet (laag, gemeten).** In de
DWG-weergave, de 2D-tekening, het schetsdoek en de kubus. Geeft een fout als de
aanwijzer al weg is; in de test alleen met nagebootste muis gezien.

**28. 66 meldingen via `alert` (laag, gemeten).** Die blokkeren de pagina en
zien er anders uit dan de rest.

**29. Geen vaste testset en geen automatische rooktest (proces).** Elke ronde
worden klantmodellen van P: gekopieerd en daarna weer verwijderd. De rooktest
uit deze audit (18 bestanden openen, fouten tellen) bestaat alleen in deze
sessie. Voorstel: een kleine set niet-klantgebonden bestanden naast de bron, en
dat script bewaren zodat elke versie dezelfde toets krijgt.

**30. Eén bestand van 2,3 MB (proces).** 12.700 regels, waarvan één regel van
1 MB met de Bluebeam-toolsets. Wijzigingen lopen via losse patchscripts. Dat
werkt, maar een vergissing in een zoek-en-vervang raakt alles. De patches
controleren wel het aantal treffers.

## Wat goed staat

- Geen dubbele functies of dubbele globale namen in 629 functies.
- Versieregel en changelog kloppen met elkaar (3.23, 287 regels).
- Geen `console.log`, `debugger` of TODO's achtergebleven.
- NAS, repo en gepubliceerde webversie zijn gelijk aan de geauditeerde kopie.
- De ontvanger controleert de Host-kop, begrenst de berichtgrootte en levert
  een half geschreven viewer niet uit.

## Voorgestelde volgorde voor de volgende ronde

1. Punt 1 (kleurlaag tijdens bewegen) en punt 2 (vergelijkfilter in de export):
   klein, en beide geven nu een verkeerd beeld of bestand.
2. Punt 3: een zelftest op de profielcorrectie.
3. Punt 4 en 22: één aangepaste markup in Revu openen en één echte melding
   versturen. Dat is handwerk van een paar minuten.
4. Punt 29: de vaste testset en de rooktest.
5. De rest naar behoefte.
