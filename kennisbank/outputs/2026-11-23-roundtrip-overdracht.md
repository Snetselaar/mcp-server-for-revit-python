# Overdracht Roundtrip (was "Ender's Game") — stand 23-11-2026

Dit is een samenvatting voor een nieuwe sessie. De volledige achtergrond, de metingen en de bronnen staan in
`kennisbank/wiki/roundtrip-revit-rekenmodel.md` (§1–§12), en in memory onder `roundtrip-revit-rekenmodel.md`.

## Doel

Staal heen en weer halen tussen Revit en het rekenmodel. Eerst Technosoft Raamwerken, daarna SCIA.

- **Revit bepaalt de geometrie** (positie).
- **Het rekenmodel bepaalt het profiel en de staalkwaliteit.**
- De **SCI-Viewer** is de hub: hij leest beide kanten, koppelt de staven en schrijft de bestanden voor Revit.

## Werkstroom zoals hij nu is

```
Revit ─Roundtrip Export─▶ JSON ─┐                       ┌─Roundtrip export──▶ JSON ─Roundtrip Import──▶ Revit (profiel + kwaliteit)
  (of de .rvt zelf) ────────────┼─▶ SCI-Viewer: vergelijk ┤
Technosoft .rww ────────────────┘   per stramien          └─Roundtrip plaatsen─▶ JSON ─Roundtrip Plaatsen─▶ Revit (nieuwe staven)
```

1. **Roundtrip Export** (Revit, 03_R&D > Tools) schrijft per stalen staaf een JSON (`roundtrip-revit-staven`) met:
   - id, familie, type en genormaliseerd profiel;
   - kwaliteit (`StructuralClass`, anders uit het materiaal);
   - de hartlijn (door het zwaartepunt), plus de stramienen en levels.

   Zonder staal in het model kan hij alleen de stramienen en levels wegschrijven.
2. **SCI-Viewer:** open die JSON (of de .rvt zelf) samen met de .rww, en kies bij **Vergelijk met** de rww.
   - Uitlijnen gaat via de stramiennamen. Spiegelbeeld wordt herkend; is dat niet te bepalen, dan vraagt de viewer het.
   - Elke staaf krijgt een status: gelijk, ander profiel, andere kwaliteit, beide, of geen tegenhanger.
   - Lamellen tellen niet mee: strips die evenwijdig op een ligger liggen, binnen 400 mm.
3. **Roundtrip export** (knop in het vergelijkingspaneel) schrijft het profiel en de kwaliteit per Revit-id
   (`roundtrip-profielen`).
   - TS-namen worden SCI-namen: `K90/90/4CF` wordt `KK90x90x4`, `STRIP100*10` wordt `100x10`.
   - Een staaf die TS in stukken met verschillende profielen knipt, wordt een conflict.
   - Een wissel tussen strip en profiel, of vanaf iets dat geen staalprofiel is, wordt een conflict.
   - De knop weigert als de doorsnede niet het stramien van de rww is.
4. **Roundtrip Import** (Revit) zoekt of maakt het type, zoals Ligger maken doet.
   - Daarna `ChangeTypeId` en de kwaliteit zoals de knoppen S235/S275/S355. De positie wordt niet aangeraakt.
   - Eerst een overzicht, dan alles in één transactie.
   - Een kolom met een Align/Lock op een vlak schuift mee met het profiel. Afspraak: alleen melden.
5. **Roundtrip plaatsen** (knop in de viewer) en **Roundtrip Plaatsen** (Revit) zijn voor "rekenmodel eerst".
   - Ze plaatsen de TS-staven die in Revit nog ontbreken. Liggers en schoren komen op de systeemlijn (justification
     Center); kolommen krijgen een voet op het level eronder en worden in het stramienvlak gedraaid.
   - Zonder Revit-staven kies je welk level bij Technosoft-hoogte 0 hoort.
   - Comments wordt `Roundtrip: <rww> staaf <nr>`; bij een tweede keer slaat hij die staven over.

## Waar alles staat

| Onderdeel | Plek | Versie / stand |
|---|---|---|
| Roundtrip Export | `W:\4 - Tijdelijk en verwijderen\AWO\Extensions\03_R&D\RnD.extension\03_R&D.tab\Tools.panel\Roundtrip_Export.pushbutton` | 1.3, getest op Cunera (1.1/1.2) |
| Roundtrip Import | idem `Roundtrip_Import.pushbutton` | 1.2; 1.0 getest op Cunera (7 van 7 goed) |
| Roundtrip Plaatsen | idem `Roundtrip_Plaatsen.pushbutton` | 1.1, **nog niet in Revit getest** |
| Icoonscripts | `RnD.extension\tools\make_icon_roundtrip_{export,import,plaatsen}.ps1` | |
| SCI-Viewer | `\\NAS01\Data-SCI\01. BIM Software\SCI-Viewer\SCI-Viewer.html` en Snetselaar_BIM `SCI-Viewer/` | live **4.07** (4.07 is van een andere sessie; de Roundtrip-delen zitten erin) |
| Viewer-patch | Snetselaar_BIM `SCI-Viewer/roundtrip_patch.py` (+ `hernoem_roundtrip.py`) | drie delen met eigen marker: `// ROUNDTRIP-PATCH`, `// ROUNDTRIP-PLAATSEN`, `// ROUNDTRIP-RVT` |
| Changelog | `W:\7 - Software\AI-Engineer\Changelogs\SCI-Viewer` (uit `maak_changelog.py`) | t/m 4.06 voor Roundtrip |
| Testmodel | `W:\4 - Tijdelijk en verwijderen\AWO\02 Test project\IKC Cunera_CON_SNE_9204_DO_R25.rvt` (Revit 2025, testkopie) | Roundtrip Import is erop gedraaid (7 staven gewijzigd) |
| Testbestanden | `W:\...\AWO\02 Test project\roundtrip_test\` | plaatsen (aanvullen, 4 staven) / plaatsen (leeg model, 20) / profielen + README |
| Technosoft-testdata | `P:\9000-9999\9200-9249\9204 - IKC Cunera Castricum\1 Ber\DO\Stramien 7.rww`, `Spanten stramien A.rww` | P: alleen lezen |

Commits in Snetselaar_BIM: 747f022 (4.04), 71bfa33 + b31479b (4.05), 3ca2cb1 + 5851d7a (patch), d0e99eb (4.06).
**De Roundtrip-knoppen op W: staan nog niet op GitHub.** Die gaan mee bij de volgende "update github"; de
pre-commit-hook draait dan `check_versies` en de IronPython-compilatie.

## Belangrijke bevindingen

- **Technosoft-XML (fase 0):**
  - `twrmw.exe <rww> /xml_model <xml>` en `<xml> /saveas <rww>` draaien zonder dialoog.
  - Een staaf heeft geen tekstveld, dus het Revit-id kan niet in de rww.
  - **Heen en terug via XML zet de belastinggenerator uit** en wist zijn instellingen.
- **Binair patchen van de .rww:**
  - Een staaf naar een al bestaand profiel zetten (`0x2c` u16 @4) is verliesvrij.
  - Een nieuw profiel op een staaf zetten loopt vast.
  - Een knoop verschuiven zet de generator ook uit. Byte 0 van `0x0f` is de generatorstatus.
- **.rvt in de viewer (zonder Revit):**
  - Op Cunera komt dat overeen met de export: 524 stalen staven, type en kwaliteit gelijk.
  - De rvt-lezer mist het hart van schuine staven tot ±1 m. Daarom staat **plaatsen vanuit een .rvt met staal uit**.
  - Het is het bestand op schijf, niet de open sessie.
- **Spiegelbeeld:** herkend via de stramiennamen of de bestaande staven. Leeg model met maar één gemeenschappelijke
  stramiennaam: de viewer vraagt het.
- **Bekende valkuilen:**
  - Bash-heredoc maakt `\\` tot `\`, dus `\02` in een pad wordt een stuurteken. Schrijf Python met backslashes via een
    bestand.
  - Vóór elke viewer-uitrol de NAS met een `cmp` vergelijken met de eigen vorige versie; andere sessies wijzigen hem
    ook.
  - Projectdata (modelnaam, coördinaten) hoort niet op GitHub; de push werd geweigerd.
  - Testserver: `.claude/launch.json` → `ender-viewer`, poort 8767 (8765 is van een andere sessie). Laad bestanden via
    `fetch` + `openFiles`.

## Open punten (in volgorde)

1. **Roundtrip Plaatsen testen in Revit.** Eerst het aanvulbestand op de Cunera-testkopie. Controleer daarna met de
   Lees-MCP de ligging, het type en vooral de **draaiing van kolommen**. Die is [ONBEVESTIGD]: de aanname is profielhoogte
   langs Y bij 0°.
2. **Testen in andere modellen**, vooral Revit 2026/2027 en echte projecten. De gebruiker doet dit zelf.
3. **Fase 3, Revit → Technosoft:** geometriewijzigingen terugzetten in een bestaande rww. Dat kost altijd de
   belastinggenerator (XML én binair). Te bespreken: accepteren (de constructeur draait de generator opnieuw), of alleen
   een wijzigingslijst.
4. **Fase 5, SCIA:** SAF (xlsx) of XML + .def via Bestand > Update. Koppelt SCIA op naam of op GUID? Moet getest worden
   op een pc met SCIA.
5. **Kleiner:**
   - Bij spiegelen keert de open kant van UNP en L om; dat wordt nu niet meegenomen.
   - Massieve staven (ø24) hebben geen SCI-familie en worden overgeslagen.
   - Promotie van de knoppen naar 02_Beta / toolboek / actielijst is nog niet gedaan.
