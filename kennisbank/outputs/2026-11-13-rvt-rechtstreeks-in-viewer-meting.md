# Revit-bestanden rechtstreeks in de SCI-Viewer: meting rvt-rs 0.19.0 (13-11-2026)

Vraag van Albert: we hebben nu veel Revit-bestanden met de IFC ernaast en er staat veel op GitHub om .rvt rechtstreeks te lezen; is er genoeg om dit in de viewer in te bouwen?

## Wat er gemeten is
- **Gereedschap:** rvt-rs v0.19.0 (github.com/DrunkOnJava/rvt-rs, Apache-2.0, release van 12-11-2026). Windows-zip gedownload met `gh`, SHA256 gelijk aan `SHA256SUMS`. Gedraaid met akkoord van Albert.
- **Model 1:** ons eigen constructiemodel `S-9464 Apartementen_R25_CF.rvt` (Revit 2025, 66 MB), vergeleken met onze eigen Revit-export `8 Interne controle\01. BIMcollab\S-9464 - Nieuwbouw Appartementen.ifc` (IFC2X3, 1.804 elementen).
- **Model 2:** `S-9488_r25.rvt` (Revit 2025, 40 MB), het model van de meting van 05-11-2026.
- Vergelijking in de SCI-Viewer 3.42: elementen gekoppeld op het Revit-elementnummer in de naam, plaats en maten na uitlijnen (draaiing om Z en verschuiving).

## Uitkomst
| Punt | 05-11 (v0.15) | 13-11 (v0.19) |
|---|---|---|
| Versieherkenning | fout (las 2024 of 2026 uit pad en buildnummer) | goed: 2025, rechtstreeks vanaf P: |
| S-9464 constructie | niet gemeten | 2.280 elementen in 12 s; 476 nog als blok; 268 records niet gelezen |
| Dekking t.o.v. Revit-export | n.v.t. | 1.766 van 1.766 genummerde elementen aanwezig, klasse gelijk (IfcMember wordt IfcBeam) |
| Plaats binnen 20 mm | n.v.t. | kolommen 53/53, balken 727/790, wanden 633/707, vloeren 125/176 |
| Maten binnen 20 mm | n.v.t. | kolommen 53/53, balken 716/790, wanden 631/707, vloeren 170/176 |
| S-9488 | 14 elementen, alle blok | 14 elementen als mesh; de 29 stalen staven die onze eigen lezer vindt ontbreken |

Afwijkers in S-9464: wandtype CS20_214 (61 stuks), muurplaat (19), hoeklijn L240 (17), balk met wapening 400x800 (13), prefab vloer 250 (12).

## Wat nog niet klopt voor ons gebruik
1. **Coördinaten.** rvt-rs schrijft het interne nulpunt; onze Revit-export staat in gedeelde coördinaten (476 km en 80,5° verschil). Los bekijken gaat goed, samenvoegen met een IFC van een andere partij niet zonder dat wij de omrekening toevoegen.
2. **GlobalId.** Geen enkele GlobalId is gelijk aan die van Revit. BCF-issues en de versievergelijking koppelen dus niet tussen een .rvt en zijn IFC.
3. **Bouwlaag.** Maar 182 van de 2.280 elementen hangen aan een bouwlaag.
4. **Eigenschappen.** Geen classificatie (NL-SfB); materiaalnamen wel. De ILS-check en de staallijst zijn op zo'n bestand dus maar deels bruikbaar.
5. **Dekking wisselt per model.** In S-9488 ontbreekt al het staal.
6. **Revit 2023 en ouder** (bijvoorbeeld 8337): volgens de eigen documentatie alleen blokken.
7. **Grootte.** De uitvoer is 122 MB tegen 26 MB uit Revit; de viewer gebruikt er 947 MB geheugen voor.
8. **Browserversie.** De map `rvt-wasm` staat in de repo, maar er is geen kant-en-klaar pakket gevonden; zelf bouwen met wasm-pack. Niet nagegaan hoe groot het wasm-bestand is.

## Oordeel
Genoeg voor **bekijken** van een Revit 2024-2027-model zonder eerst te exporteren, met de melding dat het een voorlopige weergave is. Niet genoeg om de Revit-export te vervangen voor controle, issues, samenvoegen en hoeveelheden.

## Opties
- **A. Voorlopige weergave inbouwen** (aanbevolen als eerste stap): .rvt openen via rvt-rs in de browser, met een duidelijke balk "voorlopige weergave, exporteer een IFC voor controle", en onze eigen omrekening naar gedeelde coördinaten en de bouwlaag uit de hoogte. Vraagt: de wasm-module bouwen en naast de viewer op de NAS zetten.
- **B. Omzetten op de werkplek:** de ontvanger roept `rvt-ifc.exe` aan (12 s) en geeft de IFC aan de viewer. Sneller te bouwen, maar zet een programma van derden op elke pc.
- **C. Wachten:** het project brengt bijna dagelijks een release uit; over enkele weken opnieuw meten op dezelfde twee modellen.

## Bijvangst: SCIA-model 8337
`3 Tek\0. Interne model communicatie\IFC\2023-05-16 S-8337_R23.ESA`: 57 wanden en vloeren, 59 sparingen. De viewer las bij vijf wanden 1000 of 2000 mm als dikte en bij één plaat 200 in plaats van 87,5 mm. Hersteld in 3.42 (dikte op de vaste plek in het EP_Plane-record). De namen "kalkzandsteen 250" bij 175 mm staan zo in het SCIA-bestand: in SCIA gekopieerde wanden die niet in de Revit-IFC voorkomen.
