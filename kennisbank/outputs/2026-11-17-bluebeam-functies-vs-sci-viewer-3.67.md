# Bluebeam Revu 21 tegenover het PDF-deel van de SCI-Viewer (17-11-2026, na 3.67)

Vraag van de gebruiker: "kijk nog even goed wat bluebeam voor functies allemaal heeft". Een hulpagent heeft een inventaris
gemaakt uit de officiële Revu 21-handleiding en de abonnementstabel. De bronnen staan onderaan. Daarna heb ik die
inventaris naast de code van viewer 3.67 gelegd.

Edities in Revu 21: Basics, Core, Complete en Max. "Standard" bestaat in 21 niet meer. Wij werken met Core of hoger.

## Al in de viewer (geen actie)
- **Tekenen:** tekst, pijl, lijn, rechthoek, ellips, wolk, polylijn, pen en markeerstift, met kleur, dikte, vulling,
  tekstgrootte en sinds 3.67 dekking.
- **Gereedschapskist:** Tool Chest met Mijn tools en Recente tools. Ondersteunt .btx in en uit, vergrendelen en wisselen
  tussen properties- en drawing-modus.
- **Meten:** lengte, polylengte, oppervlak, tellen en kalibreren, met schaal per blad. Viewports uit Revu worden gelezen.
- **Snappen** (3.67) op de vectorinhoud en op de eindpunten van eigen markups. Shift geeft 45° en Ctrl schakelt het even
  uit, net als in Revu.
- **Opmerkingenlijst:** status (Accepted / Rejected / Cancelled / Completed), aangepaste kolommen en lagen.
- **Documentbeheer:** plat maken, samenvoegen, Bluebeam-set (.bex) maken en aanvullen, handtekening en spellingscontrole.
- **Weergave:** revisie-overlay, splitsen en een eigen venster.

## Ontbreekt, prioriteit hoog voor tekeningcontrole
| Revu-functie | Wat het doet | Inschatting voor de viewer |
|---|---|---|
| Cloud+ (K) | Wolk met een tekstvak en pijl in één markup, het standaardgereedschap voor een opmerking | klein: wolk en bijschrift bestaan al los |
| Compare Documents | Verschillen tussen revisie A en B als wolken | middel: pixelvergelijking van twee renders, wolken rond de clusters |
| Sketch to Scale | Een lengte intikken tijdens het tekenen (bv. 2400 mm) | klein: de schaal is al bekend |
| Meten: hoek, straal, diameter, omtrek los, volume, sparing aftrekken | Overige meetgereedschappen | klein per stuk |
| Snapshot (G) | Gebied kopiëren als afbeelding of markup | klein: plakken van een afbeelding bestaat al |
| Replace Pages | Nieuw blad erin, markups blijven staan | middel |
| Batch Slip Sheet (Complete) | Nieuwe revisies in een set, markups mee | middel tot groot: overlapt met "Set bijwerken" |
| Summary-export van de markups (CSV/PDF) | Rapport van de opmerkingenlijst | klein |

## Middel
- Rechtsklik op een markup, Lock (vergrendelen tegen verschuiven).
- Sequences: automatisch doornummeren.
- Alignment tools: uitlijnen en verdelen.
- Multiply: verschoven kopieën maken.
- Page labels uit het stempelveld.
- Visual Search: gelijke symbolen vinden en tellen.
- Batch Link: automatische hyperlinks tussen bladen.

## Laag of niet voor ons
Studio Sessions/Projects, formulieren, redaction, content editing, 3D PDF, Dark Mode (de viewer heeft al een eigen
donker thema).

## Kanttekeningen
- **Snap-punttypen.** Welke punttypen Snap to Content in Revu precies heeft (midden en snijpunt), staat niet in de
  officiële handleiding, alleen in een tutorial. De viewer snapt op eindpunt, snijpunt, midden en op de lijn.
- **Dekking.** Revu zet de dekking in de weergavestroom met een ExtGState (`/BBGS gs`). Dat is gemeten in t.pdf. De viewer
  doet het sinds 3.67 net zo, en zet /CA er ook bij.
- **Sneltoetsen.** Revu 21 gebruikt Ctrl+Shift+F8 (Snap to Content) en Ctrl+Shift+F7 (Snap to Markup). In de viewer zit
  snappen nu achter het vinkje "Snappen" in de eigenschappenbalk.

## Bronnen
- https://support.bluebeam.com/articles/revu-21-subscription-features
- https://support.bluebeam.com/revu/resources/revu-21-release-notes.html
- https://support.bluebeam.com/revu/resources/keyboard-shortcuts.html
- https://support.bluebeam.com/revu/how-to/tips-and-tricks/use-modifier-keys.html
- https://support.bluebeam.com/online-help/revu21/Content/RevuHelp/Menus/Revu/Preferences/General--MV.htm
- https://support.bluebeam.com/revu/how-to/disable-snap-to-content-in-measurements-panel.html
- https://support.bluebeam.com/revu/features/compare-documents-vs-overlay-pages.html
- https://support.bluebeam.com/revu/how-to/transfer-markups-with-batch-slip-sheet.html
- https://support.bluebeam.com/user-manual/menus/window/markups-list-summary.html
- https://support.bluebeam.com/revu/features/tool-chest-guide.html
- https://novedge.com/blogs/design-news/bluebeam-tip-precision-snapping-with-midpoint-and-intersection-in-bluebeam-revu (derde partij)
- Code viewer 3.67 (scratchpad `test367.html`), gemeten in t.pdf.
