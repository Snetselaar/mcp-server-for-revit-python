# SCI-Viewer audit 3.36 → 3.37 (12-11-2026)

De audit is uitgevoerd met vier parallelle agents, elk op een deel van de code:
- IFC: laden, gewicht en vergelijken;
- IFC: 3D-bediening, export en meten;
- PDF, markups, BCP en DWG;
- rekenmodellen, vakwerk en de algemene code.

Elke bevinding is daarna nagelezen in de code. Waar dat kon, is hij in de browser nagemeten op tlb, S-8588, S-9070, t/t2.pdf en vier rekenmodellen. De gerepareerde punten staan live als **3.37** (repo-commit `16441f0`).

## Gerepareerd in 3.37
| Deel | Punt |
|---|---|
| PDF | Reservekopie ook als de PDF sinds het openen is gewijzigd (extra kopie `naam_HHMMSS.pdf`). Eerder ging het tussenwerk van een collega verloren als er die dag al een kopie was. |
| PDF | Snel bladeren: renderronde met token (`pdfTok`); een oudere ronde tekent niet meer over een nieuwer blad. |
| PDF | Markups die tijdens het opslaan geplaatst worden, blijven staan. Een versleutelde PDF wordt geweigerd. `bexAutoKoppel` heeft time-outs (offline schijf). Geplakte afbeelding draait met `pg.rotate`, niet met de schermdraaiing. Geheugen wordt vrijgegeven bij sluiten (`vorig.doc`, `PDFB`, `CADC`). |
| IFC | Stramienen van een tweede model volgen `z.T` (plaatsing/rotatie). |
| IFC | `volumeVan`: de dikte van een open vlakvorm komt nu uit `elementMaten`/`vlakDikte`, niet uit de as-uitgelijnde bbox (schuine wand: tot 15× te zwaar). |
| IFC | Vergelijken: staallijst zonder de oude versie; een tweede vergelijking ruimt de eerste op; tabwissel tijdens laden. |
| IFC | Selectie-export zonder verborgen elementen; STEP-tekst geëscaped (`stpT`); vierkante plaat zonder diagonale lengte; `esc` op de objectnaam in de hoek-tooltip; `hoekFactor` alleen op staven; `gewichtDeel` houdt `onzeker` vast. |
| Rekenmodel | Vakwerk: "Verticalen om" < 1 gaf een oneindige lus; aantal diagonalen wordt afgerond en begrensd op 200; ingelezen vakwerk-XML wordt opgeschoond. |
| Rekenmodel | grw/dlw: namen met latin1-tekens (ø, é, –) worden niet meer overgeslagen. Daardoor verschoven eerder doorsneden, belastinggevallen en paaltypen. |
| Algemeen | Melding versturen heeft een time-out van 8 s. |

## Vals alarm (nagemeten)
- `ifcVerborgen` zou IfcOpeningElement/IfcSpace weglaten. Die staan niet in `z.elems`: S-8588 behoudt 63 van 63 sparingen.
- `idbMap` zonder `onerror`: die is er al, met een time-out van 4 s (sinds 3.27).

## Open (niet in 3.37, groter of zonder testbestand)
1. **PDF met /Rotate 90/270:** nieuwe tekstmarkups staan gekanteld; de AP-stream en de Rect moeten mee draaien.
2. **DWG-viewport met twist-hoek:** wordt ongedraaid getekend.
3. **Balkroosters:** de wapening per doorsnede (`bas`/`beu`) koppelt op positie. Eén doorsnede zonder basistekst verschuift alle volgende. Er is een testbestand nodig om dit veilig te repareren.
4. **Vakwerk:** handmatige codes, profielen en opleggingen hangen aan de positie. Na een geometriewijziging komen ze op een andere staaf terecht. Voorstel: wissen met een melding.
5. **Grote IFC's:**
   - `selectieZ` en `oppHtml` bevriezen bij miljoenen driehoeken;
   - `markeerDubbeleDriehoeken`/`vulGaten` draaien zonder voortgang;
   - boven ~512 MB faalt `TextDecoder` op de hele buffer;
   - eid als Float32 (fout boven 16,7 miljoen express-id's).
6. **Geheugen:**
   - `bouwIfc3d` sluit het web-ifc-model niet na een fout;
   - een gesloten tabblad in een federatie houdt zijn geheugen vast.
7. **Klein:**
   - CSV-formule-escaping alleen in de staallijst;
   - dubbele GlobalId bij platen met dezelfde naam in `stavenNaarIfc`;
   - `cam.near` na het lopen;
   - `/Popup` blijft staan na het verwijderen van een annotatie;
   - lagen-undo bij CAD;
   - emoji in `bbStr`;
   - geen wachtwoordvraag bij een beveiligde PDF;
   - parseRww/parseEsa zonder grenscontrole op de recordlengte.
