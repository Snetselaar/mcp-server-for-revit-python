---
name: annotatie-autopilot
description: Zelfstandige verbeterronde voor een maat-, peilmaat- of tagscript van het SCI-lint in een echt Revit-model, via de eigen MCP-knop (ap_testrun) en de checker in RnD.extension\annotatie_autopilot. Gebruik bij "annotatie-autopilot <script>", bij een nieuwe ronde op Paal-Paal, Palen-Stramien, AutoDim Balken/StramienBalken, AutoDim Detail of Tag Details, en bij het verwerken van een correctie van Albert op zo'n script.
---

# Annotatie-autopilot

Harnas: `W:\4 - Tijdelijk en verwijderen\AWO\Extensions\03_R&D\RnD.extension\annotatie_autopilot\`
(hierna `AP\`). Lees eerst `AP\logboek.md` (stand + besluiten B1..) en daarna
`AP\BOUWPLAN.md` §4-§8. Het logboek is het geheugen tussen sessies: niets
opnieuw doen wat daar als gedaan staat.

## Onderdelen

| Onderdeel | Pad | Wat |
|---|---|---|
| Revit-kant | `03_R&D.tab\Tools.panel\Lees_MCP.pushbutton` (>= 2.2) | `ap_testrun`, `ap_meet_annotaties`, `ap_exporteer_view_png`, `ap_dupliceer_view`, `ap_verwijder_views` |
| Client | `AP\harnas\revit_client.py` | praat rechtstreeks met de knop (geen MCP-herstart nodig) |
| Runner | `AP\harnas\draai_set.py <script> <werkkopie> --run-id ID` | hele testset van één script + checker |
| Checker | `AP\harnas\annotatie_check.py` + `regels.json` | H1-H5 hard, Z1-Z3 zacht |
| Toetsen | `AP\harnas\test_annotatie_check.py` | draai na ELKE wijziging aan de checker |
| Testset | `AP\testset\<case>.json` | case: id, model, bron_view, testview_id, scripts, invoer, viewsoort, scope, referentie, schoon_png, afbeelding |
| Werkkopieën | `AP\werk\<script>\iter_NN.py` (+ `origineel.py`) | nooit in het lint tot fase 3 |

## Voorwaarden in Revit (anders stoppen en vragen, §8)

1. Een **losgekoppelde** testkopie open (Detach), nooit central of lokale kopie.
   Opslaan alleen als nieuwe kopie in de testmap met `_autopilot_<datum>` in de naam.
2. MCP-knop op **Lezen en schrijven**, bevestiging per wijziging **uit** (Nee bij de vraag).
3. Titel of pad van het model past op een patroon in `regels.json` → `testkopieen`.
4. `python AP\harnas\revit_client.py sessies` toont precies die sessie (anders `--pid`).

## Protocol fase 2 (per script)

1. Nulmeting bestaat? (`AP\runs\baseline_<script>\overzicht.json`). Anders eerst
   `draai_set.py <script> werk\<script>\iter_00.py --run-id baseline_<script>`.
2. Begin met het script met de slechtste nulmeting.
3. Groepeer de fouten over ALLE cases naar oorzaak (lees de `*_check.json`).
4. Kies één oorzaak. Kopieer de beste versie naar `iter_NN.py` en pas alleen dat aan.
5. `draai_set.py <script> werk\<script>\iter_NN.py --run-id <script>_iterNN`.
6. Beter en nergens een nieuwe harde fout → nieuwe beste. Anders terug, met reden.
7. Harde regels groen? Bekijk de PNG's (`runs\<run>\<case>.png`, Read-tool). Zie je
   iets wat de checker mist: eerst een checkerregel (+ toets), dan pas een fix.
8. Log in `logboek.md`: hypothese, wijziging, scores voor/na, besluit.

Stoppen: alles hard groen en zacht 3x niet beter, of 15 iteraties, of 3x op rij
niets beter (→ open punt). Dezelfde botsingsoorzaak na 3 iteraties: geen nieuwe
if-tak, maar het positiekiezende deel vervangen door kandidaatposities met een
score (inline, standalone).

**Nooit:** checker versoepelen of een case aanpassen om te laten slagen (een
aantoonbare checkerbug repareren mag, met onderbouwing); minder annotaties
plaatsen; huisregels wijzigen; in een central/productiemodel werken of
synchroniseren; 01_SCI of 02_Beta aanraken (B3: Beta-scripts alleen als werkkopie).

**Crash** (Revit weg / geen antwoord): laatste wijziging als verdacht markeren,
niet ongewijzigd opnieuw draaien. Sessie terug → door. Niet → stoppen, rapporteren.

## Protocol fase 3

1. Alleen 03_R&D-knoppen: beste werkkopie terug in `script.py` (haak blijft),
   `__version__` + `Versie:` ophogen, `tools\sync_versies.py --init` draaien.
   02_Beta-scripts: werkkopie blijft staan voor `bimtools-promotie` (B3).
2. `ap_dupliceer_view` met prefix `AP_resultaat_`, dan `draai_set.py ... --houd` op
   cases die naar die views wijzen.
3. `AP\rapport_<datum>.md` volgens BOUWPLAN §5.3; korte samenvatting in de chat.

## Feedback van Albert

Elke correctie eerst als regel in `regels.json` (bron "Albert <datum>") of als
extra case, pas daarna een fix. Huisregels wijzigt alleen Albert.

## Valkuilen (gemeten, niet raden)

- Maattekst-omhullende is benaderd (tekenbreedte × hoogte); `regels.json` →
  `tekstmodel.geijkt` moet `true` zijn voordat fase 2 begint (§3.5).
- `Dimension.Origin` crashte ooit Revit 2025 via de oude routes-thread; in de
  handler op de API-thread is hij in 2.2 in gebruik. Crasht een meting toch:
  segment-Origin uitschakelen en op `box` terugvallen.
- Een script met een lokale, open `Transaction` in een functie kan de groep
  blokkeren (`transactie_blijft_open`) — dan is de run verdacht, niet de checker.
