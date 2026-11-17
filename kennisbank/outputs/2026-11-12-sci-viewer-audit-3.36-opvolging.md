# SCI-Viewer audit 3.36: opvolging van de open punten → 3.38 (12-11-2026)

Vervolg op `2026-11-12-sci-viewer-audit-3.36.md`. De open lijst uit dat rapport is aangepakt in **3.38** (repo-commit `24942a3`). Getest in de browser op S-8588, S-9070, t/t2.pdf, een t2.pdf met /Rotate 90, d1.dwg, wap54.dxf, het balkrooster van 9434 en drie rekenmodellen.

## Gerepareerd in 3.38
| Open punt | Wat er is gedaan | Getest |
|---|---|---|
| PDF /Rotate 90/180/270 | `bbRotVan`/`bbRotAs`/`bbRotTL`: het tekstvak krijgt `/Rotate` van het blad. Tekst, omhullende, AP-stream (`Tm`), invoervak en schalen volgen de leesrichting. | Ja: tekst horizontaal op scherm en in de teruggelezen PDF (pdf.js, rotation 90). |
| DWG-viewport met twist | `viewTwistAngle` → `v.r`; `cadLaagTeken` en `cadRaak` rekenen met rotatie. | Deels: tekenen en aanklikken zijn onderling consistent bij 0°, 23° en 90° (40 van 40). Er is geen echt bestand met een gedraaide viewport getoetst; de draairichting is dus niet bevestigd. |
| Balkrooster-wapening | Een `bas`-record zonder tekst houdt zijn plek; een waarschuwing in de console als de aantallen niet kloppen. | In vijf echte .grw-bestanden (9102, 9434, 9509, 9357 hal A en C1/C2) kwam een record zonder tekst niet voor; 9434 geeft nog steeds 10 doorsneden. |
| Vakwerk-codes na geometriewijziging | `P.topo` per vakwerk; bij een andere staafindeling worden `codes`/`staafProf` van dat vakwerk gewist met een melding. | Ja: hoogte wijzigen behoudt de code, aantal diagonalen wijzigen wist hem. |
| Grote IFC's | `selectieZ` reserveert vooraf; `oppHtml` stopt boven 20.000 elementen; melding "Geometrie controleren…"; `ifcLatin1` vangt de stringlimiet af; eid als Uint32. | Ja op S-8588 (107.280 hoekpunten in 19 ms). Niet op een model boven 512 MB. |
| Geheugen | `CloseModel` bij "geen geometrie"; een gesloten tabblad gaat uit de federatie en komt vrij. | Ja. |
| Klein | CSV-formules (`csvQ`), `/Popup` mee weg, `cam.near` na lopen, CAD-lagen-undo, emoji in `bbStr`, wachtwoordvraag. | CSV, near en eid getest; de wachtwoordvraag niet (geen beveiligde test-PDF). |

## Niet gedaan
- **Dubbele GlobalId bij platen met dezelfde naam** (`stavenNaarIfc`): een oplossing zou de GlobalId van bestaande exports veranderen. Eerst beslissen of dat mag.
- **Grenscontrole in `parseRww`/`parseEsa`**: zonder afwijkend testbestand is niet te zeggen welke records korter kunnen zijn.
- **Voortgang binnen `markeerDubbeleDriehoeken`/`vulGaten`**: er staat nu een melding vooraf, maar de bewerking zelf is niet in brokken geknipt.

## Nog te toetsen door een gebruiker
- Een DWG met een echt gedraaide viewport (draairichting).
- Een beveiligde PDF (wachtwoordvraag).
- Een PDF met tekst op een gedraaid blad openen in Revu.
