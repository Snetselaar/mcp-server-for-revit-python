---
titel: Roundtrip — staal Revit ⇄ Technosoft/SCIA
status: concept
laatst-bijgewerkt: 2026-11-20
bronnen:
  - outputs/2026-11-20-enders-game-fase0-technosoft-xml.md
  - "C:\\Program Files (x86)\\Technosoft Structural Analysis\\Raamwerken V6\\twrmwtn.pdf, p. 388-398 en 428 (XML-koppeling, opdrachtregel)"
  - "waargenomen op kopie van 9204 Cunera, 1 Ber\\DO\\Stramien 7.rww (Raamwerken 6.85)"
  - https://help.scia.net/19.1/en/rb/importexport/scia_esa_pt_update.htm
  - https://www.scia.net/en/innovations/structural-analysis-format-saf
verwant:
  - externe-bronnen-ronde-okt2026.md
  - ifc-export-staalgewicht.md
  - lees-mcp-koppeling.md
---

# Roundtrip — staal Revit ⇄ Technosoft/SCIA

> **Geparkeerd op 23-11-2026** (besluit gebruiker). De stand en de open punten staan in outputs/2026-11-23-roundtrip-overdracht.md.

> Heette tot 20-11-2026 **Ender's Game** (knoppen Ender Export/Import, viewerknop "⇢ Revit (profielen)"). Hernoemd op verzoek van de gebruiker; viewer 4.05, Roundtrip Export 1.2, Roundtrip Import 1.1. Bestanden in het oude formaat (`ender-…`) blijven leesbaar.

Roundtrip is het project om staal heen en weer te halen tussen Revit en het rekenmodel.
Gestart op 20-11-2026.

**Uitgangspunt:** **Revit bepaalt de geometrie** (positie, hartlijn). **Het rekenmodel bepaalt
het profiel en de staalkwaliteit.** De eerste stap is alleen staal, dus Structural Framing en
Columns.

Gekozen op 20-11-2026:
- Technosoft komt eerst, SCIA later.
- Het Revit-ElementId gaat mee naar het rekenmodel, zonder nieuwe parameter in Revit.
- De Revit-staven komen via een eigen pyRevit-exportknop (JSON).
- De SCI-Viewer is de hub.

## 1. Fases

| Fase | Inhoud | Stand |
|---|---|---|
| 0 | Proef: Raamwerken-XML heen en terug, en binair patchen | gedaan 20-11-2026, zie §2-§3 |
| 1 | Knop "Roundtrip Export" (03_R&D): staven uit het open model als JSON | 1.1 op W: 20-11-2026, getoetst op Cunera, zie §5 |
| 2 | Viewer: Roundtrip-JSON lezen en koppelen aan de rww | live in SCI-Viewer 4.04 (20-11-2026), zie §6 |
| 3 | Revit → TS: Raamwerken-XML met id, of een bestaande rww bijwerken | open, zie §3 |
| 4 | TS → Revit: viewer-JSON + knop "Roundtrip Import" (type zoeken of maken, ChangeTypeId, staalkwaliteit) | gebouwd en getest 20-11-2026 op de Cunera-testkopie, zie §7 |
| 5 | SCIA via SAF of XML-update | open, op een pc met SCIA |
| 6 | Rekenmodel eerst: het rekenmodel plaatst de eerste keer ook de geometrie in Revit | viewer 4.06 live; knop Roundtrip Plaatsen 1.1 nog niet in Revit getest, zie §11 |

## 2. Wat Raamwerken via XML wel en niet doet

Bron: `outputs/2026-11-20-enders-game-fase0-technosoft-xml.md`.

- **`/xml_model` en `/saveas` draaien zonder dialoog.** Exitcode 0 binnen enkele seconden.
  Dat is anders dan bij Balkroosters `/xml_concrete`, die bleef eerder hangen.
- **De export zet `TemplateFileName` en `XMLReadCode="Replace"` al zelf in `<BasicData>`.**
  Terugzetten werkt de bron-rww bij.
- **Een profiel wisselen werkt.** Per staaf zet je `SectionID` om. Een nieuw profiel met alleen
  `Description` + `MaterialID` (bv. `K100/100/5CF`) wordt aangevuld uit de profieldatabase.
- **Belastingen, combinaties en de staalcontrole blijven staan.** Dat zijn de staalelementen,
  knik, kip, steunen en doorbuigingslimieten.
- **Een staaf heeft geen tekstveld.** `Bars` kent alleen ID, de knopen, SectionID en de
  aansluitcodes. Een extra `Description` verdwijnt bij het terugzetten. Het Revit-id moet dus
  in een koppeltabel náást de rww.
- **De belastinggenerator gaat uit en zijn instellingen verdwijnen.** Dat zijn de wind-, sneeuw-
  en veranderlijke parameters. Het gebeurt ook als je de XML ongewijzigd heen en terug haalt.

## 3. Bestaande rww bijwerken: binair patchen

Bron: `outputs/2026-11-20-enders-game-fase0-technosoft-xml.md`, het deel "Vervolg".

Het profielnummer van een staaf staat in het staafrecord 0x2c als u16 @4, 1-based.

- **Een staaf binair op een al bestaand profiel zetten is verliesvrij.** Alleen het profiel
  wijzigt; de generator en de staalcontrole blijven staan.
- **Een nieuw profiel toevoegen** (een 0x2e- en een 0x3e-record) laadt wel. **Een staaf erop
  zetten loopt vast** in `/xml_model`.
- **Een knoop verschuiven zet de belastinggenerator uit.** Dat gebeurt binair net zo als via
  XML. Byte 0 van record 0x0f is de generatorstatus: 0 is aan, 3 is uit.
- De staart na de recordketen is nodig; zonder die staart crasht Raamwerken.

Gevolg voor het ontwerp:
- Geometrie van Revit naar een bestaande rww schrijven gaat in Technosoft altijd ten koste van
  de generator. Dat geldt voor beide routes.
- [ONBEVESTIGD] Het lijkt erop dat de generator vervalt zodra de gegenereerde lasten niet meer
  bij het model passen. De melding in de GUI is nog niet bekeken.

## 4. SCIA (fase 5)

SCIA kan een bestaand model bijwerken via Bestand > Update > XML. Je ziet dan per wijziging
een overzicht om te accepteren
([help](https://help.scia.net/19.1/en/rb/importexport/scia_esa_pt_update.htm)).

SAF (xlsx) is volgens SCIA ook bedoeld om te exporteren, aan te passen en opnieuw te
importeren ([SAF](https://www.scia.net/en/innovations/structural-analysis-format-saf)).

[ONBEVESTIGD] Of SCIA bij een update koppelt op naam of op GUID, is niet getest. SCIA staat
niet op de werkplek van AWO.

## 5. Roundtrip Export, getoetst op Cunera 9204 (R25)

Gemeten op 20-11-2026 met versie 1.0, in de testkopie `AWO\02 Test project\IKC Cunera_CON_SNE_9204_DO_R25.rvt`.
Gecontroleerd met de Lees-MCP (locatie, bbox, parameters).

- **Aantallen:** 672 framing- en kolomelementen. Daarvan 524 staven, 129 geen staal (hout, opstort,
  strook) en 19 zonder locatielijn (stekankers, Isokorf, koudebrugonderbrekers).
  Alle 81 kolommen en 591 liggers zijn met de Lees-MCP nagelopen: niets is ten onrechte weggevallen.
- **Hartlijn:** door het zwaartepunt van de grootste solid. Die klopt op de mm met het midden
  van de bbox bij HEB700 (−150/−350 ten opzichte van de locatielijn) en HEB260 (+50).
- **Koker KK90x90x4:** het hart ligt 364 mm boven de locatielijn. Dat komt door een
  `z Offset Value` van 364 met `z Justification` Center, dus de locatielijn is geen
  systeemlijn.
- **StructuralClass:** 5 van 5 gelijk. Bij 160 staven is hij leeg terwijl het Structural
  Material wel `SCI_Staal_S235` is. Daarom valt 1.1 terug op het materiaal
  (`kwaliteit_bron`).
- **Niet herkend in 1.0:** `ø24` (massieve staaf) en `L150x150x15_M16x415` (hoeklijn met
  anker). Versie 1.1 herkent beide.
- **1.1 op dezelfde testkopie** (20-11-2026, 08:12): 524 staven, allemaal met profiel en kwaliteit. 364 komen uit StructuralClass en 160 uit het materiaal (152x S235, 8x S355). 8 zijn massief (RND) en 37 zijn hoeklijnen.

## 6. Viewer leest de Roundtrip-JSON (fase 2, eerste stap)

Werkkopie van SCI-Viewer 4.03 met een patchscript (`roundtrip_patch.py` in de sessie-scratchpad). Op de NAS staat de oude versie nog;
die is niet aangeraakt. Het script voegt drie dingen toe:
- `parseEnder`, dat de JSON omzet naar het model van de Revit-lezer (`bouwRvtModel`);
- een .json-tak in `openFiles`, die alleen `formaat: roundtrip-revit-staven` opent;
- `.json` in de bestandskiezer.

Getoetst 20-11-2026 op Cunera met Stramien 7.rww:
- de bestaande vergelijking werkt zonder verdere aanpassing en springt zelf naar stramien 7;
- 28 Revit-staven in de doorsnede: 3 gelijk, 15 ander profiel, 2 profiel en kwaliteit anders, 8 zonder tegenhanger.

Lamellen: de stripplaten (300x15, 338x15, 158x15, 253x15, S355) liggen op dezelfde lijn als de HEB-liggers. In Revit is
dat een samengestelde ligger (HEB met lamellen), in TS een enkel HEB-profiel. Afspraak met de gebruiker (20-11-2026):
**zo'n strip telt niet mee in de koppeling.** De regel: een strip ligt evenwijdig, binnen 400 mm van het hart van een
ligger, en minstens de helft van de strip ligt langs die ligger.
- In heel Cunera zijn dat 43 strips.
- In stramien 7 blijven daarna 16 koppelingen over: 3 gelijk, 5 ander profiel, 2 profiel en kwaliteit anders, 6 zonder
  tegenhanger.

## 7. Terugweg Technosoft → Revit (fase 4)

- **Viewer:** de knop "Roundtrip export" verschijnt in het vergelijkingspaneel als een Roundtrip-export tegen een rww
  staat. Hij schrijft `formaat: roundtrip-profielen` weg met per Revit-id het TS-profiel en de TS-kwaliteit. Daarbij gelden
  drie regels:
  - de TS-schrijfwijze wordt omgezet naar de SCI-typenaam (`K90/90/4CF` wordt `KK90x90x4`, `STRIP100*10` wordt `100x10`);
  - `(90)` wordt gemeld als 'gedraaid';
  - knipt TS één Revit-staaf in stukken met verschillende profielen, dan wordt dat een conflict en geen wijziging.
- **Revit:** de knop `03_R&D > Tools > Roundtrip Import` 1.0.
  1. Hij zoekt het type in de familie die bij de profielreeks hoort, of maakt het aan zoals Ligger maken / Kolom maken
     doen, met de maat getoetst aan de opzoektabel.
  2. Hij zet het type om met `ChangeTypeId`.
  3. Hij zet de staalkwaliteit zoals de knoppen S235/S275/S355.
  4. Hij meet de locatie voor en na.
  5. Eerst toont hij een overzicht, daarna voert hij alles in één transactie uit.
- **Cunera stramien 7:** 7 wissels (o.a. HEB700 naar HEB500, HEA320 S355 naar HEB340 S235, met de melding 'gedraaid'),
  3 gelijk, 6 zonder tegenhanger. Een massieve staaf (ø24) heeft geen SCI-familie en wordt overgeslagen met een reden.

**Test in Revit** (20-11-2026, Cunera-testkopie, gebruiker draaide de knop; gecontroleerd met de Lees-MCP):
- alle 7 types zijn juist, en HEB500 is als nieuw type in de HE-familie gemaakt;
- de kwaliteit klopt: twee kolommen S235 (Materiaal KS leeg, Structural Material `SCI_Staal_S235`), de rest S355;
- de 4 liggers liggen op dezelfde lijn als voor de import;
- **2 van de 3 kolommen zijn verschoven:** 3874784 met −15 mm in X (HEA320 naar HEB340) en 3875024 met +5 mm (HEA320
  naar HEB300). Dat is precies het halve verschil in profielhoogte. De derde kolom (3874707, dezelfde wissel als
  3874784) bleef staan.
- [ONBEVESTIGD] Waarschijnlijk zijn die twee met Align/Lock aan een flensvlak vastgezet. Revit houdt dan het vlak
  vast en schuift het hart op.
- **Afspraak met de gebruiker (20-11-2026):** het vlak blijft staan, want de lock geeft aan wat de modelleur bedoelde. Roundtrip Import
  meldt de verschuiving alleen in het rapport en zet het hart niet terug.

## 8. Rekenmodel eerst (fase 6, gepland)

De constructeur rekent vaak voordat er een Revit-model is. De eerste keer levert het rekenmodel dan ook de geometrie:
- de viewer schrijft een plaatsings-JSON;
- een Revit-knop plaatst de staven;
- een TS-raamwerk (2D) komt op zijn plaats via de stramiennamen en levels die in Revit al bestaan, of via een
  stramien en nulpunt die de gebruiker kiest;
- SCIA is al 3D.

Daarna heeft elke staaf een Revit-id en is Revit leidend voor de geometrie.

## 9. Uitrol SCI-Viewer 4.04 (20-11-2026)

- **NAS en repo:** 4.04 staat op de NAS (`\\NAS01\Data-SCI\01. BIM Software\SCI-Viewer\SCI-Viewer.html`) en in Snetselaar_BIM
  (commit 747f022, met `SCI-Viewer/roundtrip_patch.py`). Vóór het kopiëren was de NAS gelijk aan de basis 4.03.
- **Changelog:** opnieuw gegenereerd met `maak_changelog.py` naar `W:\7 - Software\AI-Engineer\Changelogs\SCI-Viewer`.
- **Nieuw sinds de werkkopie:** "Roundtrip export" weigert als de doorsnede niet het stramien van de rww is. Na het
  wisselen van partner blijft de viewer op het oude stramien staan (bestaand gedrag). Spanten stramien A tegen doorsnede 7
  gaf zo onzinwissels.
- **Spanten stramien A op stramien A:** 10 wissels, 13 gelijk, 0 conflicten. `B323.9/8` wordt `ø323.9x8`.
- **Overschrijft een andere sessie de viewer met een nieuwere versie zonder deze functies:** pas `roundtrip_patch.py` opnieuw
  toe (`python -I roundtrip_patch.py <in> <uit>`) en verhoog daarbij VERSIE. Het script stopt als een anker ontbreekt of als
  de patch er al in zit.

## 10. Uitrol SCI-Viewer 4.05 (20-11-2026)

- Op de NAS en in Snetselaar_BIM (commits 71bfa33 en b31479b; de eerste bevat alleen de hernoeming van het patchscript).
  De changelog op W: is opnieuw gegenereerd. Vóór het kopiëren waren NAS, repo en changelog nog gelijk aan onze 4.04.
- In de repo staan `SCI-Viewer/roundtrip_patch.py` (alle Roundtrip-functies op een viewer zonder deze functies zetten) en
  `hernoem_roundtrip.py` (een viewer met de oude Ender-namen omzetten).

## 11. Rekenmodel eerst: Roundtrip plaatsen (fase 6, gebouwd 20-11-2026)

- **Roundtrip Export 1.3:** staat er nog geen staal in het model, dan kan hij alleen de stramienen en levels wegschrijven.
- **Viewer 4.06** (werkkopie; aangevuld met een tweede, los herkenbaar deel van `roundtrip_patch.py`): naast "Roundtrip export"
  staat de knop **"Roundtrip plaatsen (n)"**.
  - Hij neemt de TS-staven zonder Revit-tegenhanger, met de uitlijning van de vergelijking. Langs het stramien gaat
    dat via de stramiennamen. In de hoogte via de best-fit op de Revit-staven die er al staan, of 0 als er geen staan
    (`z_bron: geen`).
  - De punten komen in Revit-coördinaten (mm, projectinterne oorsprong).
  - Het soort staaf volgt uit de richting: verticaal is kolom, horizontaal is ligger, anders schoor.
  - Dezelfde stramiencontrole als bij Roundtrip export.
- **Roundtrip Plaatsen 1.0** (03_R&D):
  - Het type zoekt of maakt hij zoals Roundtrip Import.
  - Liggers en schoren komen op de TS-systeemlijn, met y/z-justification Center. Gedraaid betekent Cross-Section Rotation 90°.
  - Kolommen krijgen hun voet op het level eronder, boven- en onderkant als offset. De draaiing kiest hij zo dat het
    profiel in het stramienvlak staat (gedraaid: haaks erop).
  - Comments wordt `Roundtrip: <rww> staaf <nr>`. Een staaf die al geplaatst is, slaat hij de volgende keer over.
  - Bij `z_bron: geen` kies je welk level bij Technosoft-hoogte 0 hoort.
- **Viewertest Cunera stramien 7:**
  - Met een lege export (alleen stramienen) worden het 20 staven, waarvan kolom TS1 op y = 7250, net als de Revit-kolom.
  - Met de volledige export worden het 4 staven op hoogte −170 mm. De kolomvoet komt dan op 1830, net als in Revit.
- [ONBEVESTIGD] De draaiing van kolommen (profielhoogte langs Y bij 0°) en het plaatsen in Revit zelf zijn nog niet getest.

### Spiegelbeeld (vraag gebruiker 20-11-2026)

Een Technosoft-raamwerk staat vaak in spiegelbeeld ten opzichte van de Revit-doorsnede. De uitlijning probeert altijd
beide richtingen (`sgn` = +1 of −1).
- **Getoetst met een gespiegelde Stramien 7 (x → −x):**
  - met 5 gemeenschappelijke stramiennamen wordt het gespiegelde raamwerk herkend (sgn −1);
  - de plaatsing en de statussen zijn exact gelijk aan die van het normale raamwerk, zowel bij een leeg model als bij
    aanvullen;
  - dat geldt ook voor Roundtrip export (profielen).
- **Gat:** een leeg model met maar één gemeenschappelijke stramiennaam. Dan valt het niet te bepalen en koos de viewer
  stil "niet gespiegeld": TS3 kwam op 14250→7250 in plaats van 250→7250. Daarom vraagt "Roundtrip plaatsen" het in dat
  geval aan de gebruiker. Wie "gespiegeld" antwoordt, krijgt de staven gespiegeld rond dat ene stramien; dat is getoetst.
  Zonder gemeenschappelijke stramiennaam weigert de knop.
- In het plaatsingsbestand staat `uitlijning.gespiegeld` en hoe dat bepaald is. Roundtrip Plaatsen 1.1 toont het in
  het overzicht.
- [ONBEVESTIGD] Bij asymmetrische profielen (UNP, L) draait spiegelen ook de open kant om. Dat wordt nu niet
  meegenomen.

## 12. Zonder Revit: de .rvt rechtstreeks in de viewer (vraag gebruiker 20-11-2026)

Doel: een constructeur zonder Revit wil zien of de profilering in het model klopt met zijn berekening.
Dat kan al: de SCI-Viewer leest de .rvt zelf en de vergelijking met de rww werkt erop.
Getoetst op Cunera: de .rvt van 09:08 (na Roundtrip Import) naast de Roundtrip-export van 08:12.
- **Inlezen:** de .rvt is in ±12 s gelezen, met 672 liggers en kolommen (hout en beton zitten erbij). Alle 524 stalen
  staven uit de export zitten erin, en er is geen spookstaaf.
- **Type:** 514 van 524 gelijk. Van de 10 verschillen zijn er 7 de wissels van Roundtrip Import (de export is van
  daarvoor) en 3 alleen de toevoeging `_M16x415`.
- **Kwaliteit:** 521 van 524 gelijk, zonder onbekende waarde.
- **Stramien 7:** dezelfde uitlijning (dz −170 mm). Na de import zijn de 7 gewijzigde staven "gelijk".
- **Verschil met de Roundtrip-export:**
  - de lamellen worden bij de .rvt niet weggefilterd en geven ruis ("profiel" 300x15 tegen HEB500): 28 staven in plaats
    van 16;
  - de .rvt is het bestand op schijf en niet de open sessie;
  - er zijn geen hartlijnen;
  - "Roundtrip export" (het profielenbestand voor Roundtrip Import) is er nog niet voor de .rvt.
- [ONBEVESTIGD] Bij Revit 2026/2027 meldde de rvt-lezer eerder ±1% spookliggers. Cunera is Revit 2025.

### Gebouwd: .rvt in de viewer werkt met Roundtrip (4.06, 20-11-2026)

- **Derde deel van `roundtrip_patch.py` (marker `ROUNDTRIP-RVT`):** een geopende .rvt krijgt dezelfde
  Roundtrip-gegevens als een export. Daardoor werken het lamellenfilter en "Roundtrip export" ook zonder Revit.
- **Staalfilter:** hout, beton en losse onderdelen (geen staalprofiel in de typenaam) tellen niet mee. Een strip is
  b x t met t ≤ 60 mm.
  - Cunera: 524 stalen staven, precies als in de Roundtrip Export; 148 vallen af.
- **Veiligheidsregel, geldt voor beide bronnen:** een wissel tussen strip en profiel, of vanaf iets dat geen
  staalprofiel is, wordt een conflict en geen wissel.
  - Gezien via de .rvt: strip 338x15 → HEB500 en koudebrugonderbreker → HEA220. Die werden nu een conflict.
  - Roundtrip Import 1.2 toont de reden in het rapport.
- **Rvt-lezer en schuine staven:** bij 4 spantbenen in Spanten A wijkt de lijn uit de lezer tot ±1 m af van het hart. Ze
  komen dan als "geen tegenhanger" uit: 9 gelijk tegen 13 via de export.
  - Voor controleren is dat bruikbaar.
  - Daarom staat "Roundtrip plaatsen" vanuit een .rvt met staal uit, om dubbele staven te voorkomen. Vanuit een
    Roundtrip-export of een .rvt zonder staal werkt hij wel.
- **Export zonder staal:** de tekening viel uit (NaN), omdat `fit()` rekent op knopen. Nu krijgt zo'n export hulpknopen
  op de uiteinden van de stramienen, op het laagste en het hoogste level. Getoetst: geen fouten, en het TS-raamwerk staat
  gestippeld op het lege stramien.
- **Uitgerold als SCI-Viewer 4.06** (20-11-2026): op de NAS, in Snetselaar_BIM (d0e99eb; patch 5851d7a) en in de changelog op W:.
