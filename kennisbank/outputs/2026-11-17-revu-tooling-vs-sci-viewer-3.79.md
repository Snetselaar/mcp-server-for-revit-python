# Revu 21-tooling tool voor tool tegenover de SCI-Viewer 3.79 (17-11-2026)

Vraag van de gebruiker: "bekijk de Bluebeam-functionaliteit van Bluebeam zelf en kijk of de viewer die ook allemaal heeft; met name de tooling, dat die allemaal hetzelfde werkt."

Werkwijze:
- **Revu-kant:** door een agent opgehaald uit de officiële Revu 21-handleiding (support.bluebeam.com/user-manual), de pagina's met sneltoetsen en modifier keys, en de release notes.
- **Viewer-kant:** uit de code van test379.html (versie 3.79), plus een eigen browsertest van grepen en het eigenschappenvenster.
- Wat niet officieel te bevestigen was, staat in het laatste blok.

## Al gelijk
- **Grepen en schalen:** schalen met hoekgrepen bij alle soorten, ook bij groepen en meerdere markups tegelijk.
- **Eigenschappenvenster:**
  - onderwerp, auteur, opmerking;
  - dekking;
  - lijnkleur, dikte, lijnstijl, pijlpunten;
  - vulling met eigen dekking;
  - arcering (patroon, kleur, schaal);
  - lettertype, grootte, vet, cursief, uitlijning, tekstkleur.

  In de browser getest op 17-11-2026: alle velden komen in de markup en in de opgeslagen PDF.
- **Tekenen en meten:**
  - Polyline: klikken, dubbelklik of Enter, Backspace, Shift = 45°;
  - Length/Polylength/Area/Volume/Count/Angle met snappen en Sketch to Scale;
  - Snapshot (G);
  - Undo/Redo;
  - spellingscontrole.

## Belangrijkste verschillen
| Onderwerp | Revu 21 | Viewer 3.79 |
|---|---|---|
| Esc in tekstvak | rondt af, tekst blijft | annuleert, tekst weg |
| Sneltoetsen | Q = Callout, N = Note, O = Offset, metingen Shift+Alt+L/Q/A/P/V/C/G/U/D, Shift+N/P, S | Q = vasthouden, N = Tellen, O = Oppervlak, metingen M/O/N |
| Draaien | greep, standaard 15°, Shift = 1°; lijnen draaien niet | alleen 90° via menu (greep in bouw, 3.80) |
| Selecteren | slepen in leeg vlak = kader; links→rechts geheel erin, rechts→links geraakt | kader alleen met Ctrl/Shift, altijd "geraakt" |
| Kopiëren | Ctrl+slepen = kopie; Ctrl+Shift+V = zelfde plek | ontbreekt; Ctrl+slepen = kader |
| Callout | basistool Q; vak los slepen; Alt+slepen geheel; leaders toevoegen/verwijderen | alleen uit de gereedschapskist; slepen verplaatst geheel |
| Wolk / Cloud+ | ook als veelhoek; Size en Invert | alleen rechthoek; boog vast |
| Shift/Alt bij tekenen | vierkant/cirkel, Alt = vanuit midden; lijn slepen | geen; lijn alleen klik-klik |
| Highlight | vrije dikke doorschijnende streep | gele rechthoek |
| Pen | strepen binnen ~1 s worden één markup; Shift = recht | elke streep los |
| Tekstopmaak | per woord (vet, onderstreept, doorgehaald) | voor het hele vak |
| Group / Align / Flip / Z-order per stap | Ctrl+G, Ctrl+Alt+L/E/R/T/M/B, Ctrl+Alt+H/V, Ctrl+J/[ | ontbreekt / alleen helemaal voor of achter |
| Ontbrekende tools | Typewriter, Arc, Dimension, Note, Eraser, Hyperlink, afbeelding uit bestand | — |
| Perimeter | open vorm | "Omtrek" sluit de vorm |

## Niet officieel bevestigd
- De stapgrootte bij verschuiven met de pijltjes.
- Wat "automatic text box sizing" in 21.11 precies doet.
- Opsommingen in tekstvakken.
- Klik-klik bij Line, Arrow en Dimension: de handleiding noemt alleen slepen.
- Sneltoetsen voor Reuse en Set as Default.
- Of het hoekpunt bij Angle de tweede klik is.
- De pagina's voor Radius, Diameter, Volume en Polylength gaven een 404.
- De Callout-pagina noemt "1°, Ctrl = 15°" voor draaien; alle andere pagina's zeggen "15°, Shift = 1°".

## Bronnen
- https://support.bluebeam.com/revu/resources/keyboard-shortcuts.html
- https://support.bluebeam.com/revu/how-to/tips-and-tricks/use-modifier-keys.html
- https://support.bluebeam.com/user-manual/menus/tools/edit-markups.html
- De tool-pagina's onder https://support.bluebeam.com/user-manual/menus/tools/ (callout, cloud, cloud-plus, text-box, line, arrow, polyline, polygon, rectangle, ellipse, arc, dimension, pen, highlight, note, eraser, stamp, image, hyperlink, measure, length, area, angle, count, cutout, set-page-scale)
- https://support.bluebeam.com/user-manual/menus/edit/cut-copy-paste.html
- https://support.bluebeam.com/revu/features/tool-chest-guide.html
- https://support.bluebeam.com/revu/resources/revu-21-release-notes.html
- Eerdere functie-inventaris: `2026-11-17-bluebeam-functies-vs-sci-viewer-3.67.md`.
