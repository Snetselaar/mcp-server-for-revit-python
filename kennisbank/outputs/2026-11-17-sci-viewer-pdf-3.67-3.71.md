# SCI-Viewer PDF-deel 3.67 → 3.71: Bluebeam-functies en audit (17-11-2026)

Aanleiding: de gebruiker vroeg om "kijk nog even goed wat bluebeam voor functies allemaal heeft". Daarna volgden de wensen
voor snappen, dekking, Cloud+, Sketch to Scale, meten, grepen en een eigenschappenvenster. De functie-inventaris staat in
`2026-11-17-bluebeam-functies-vs-sci-viewer-3.67.md`.

Werkwijze: per ronde twee of drie agents. Elke agent kreeg één deel en leverde een patch op test*.html. De hoofdsessie
voegde de patches samen en testte in de browser. Opdrachten en verslagen staan in de scratchpad (`r368`, `r369`, `r370`,
`audit6`).

## Gebouwd
| Versie | Repo-commit | Inhoud |
|---|---|---|
| 3.67 | `9e269fc` | Snappen op de vectorinhoud (lijnen uit de operatorlijst van pdf.js), dekking per markup, tekstvak sluit om de tekst |
| 3.68 | `8e78666` | Cloud+, Sketch to Scale, hoek/straal/diameter/omtrek/volume/sparing, eigenschappenvenster, schaalgrepen voor groepen; IFC: tekenen in de issuedialoog, Reset in Lijsten; Splitsen sleepbaar en inklapbaar, zijpaneel volgt het actieve venster; Technosoft: staaf selecteren onder palen en labels |
| 3.69 | `77f553a` | Vergelijken met wolken, Blad vervangen, Snapshot, rapport CSV/PDF, arcering in het echte patroon, gezamenlijke grepen |
| 3.70 | `dc70beb` | Gelijke symbolen zoeken, doornummeren en nummerballon, Links maken en volgen, bladnummers uit het stempel |
| 3.71 | `1db197f` | Reparaties uit de audit |

## Lessen
- **Dekking.** Revu zet de dekking in de AP met een ExtGState (`/BBGS gs`); gemeten in t.pdf. pdf.js 3.11 negeert /CA op
  een annotatie, dus zonder ExtGState in de AP lijkt een afbeelding na heropenen weer dekkend. Plat maken moet /CA niet nog
  eens toepassen als de AP al een ExtGState met CA of ca heeft; anders werd een markeerstift van 40 % na platmaken 16 %
  (fout sinds 3.62).
- **Groepen.** pdf.js geeft een FreeText in een groep (/IRT + /RT /Group) de /Contents van de groepsleider. Daarom leest
  het doornummeren de teksten met pdf-lib, en zet de viewer de groepstekst ook op de leider.
- **Snappen.** pdf.js 3.11 levert de paden in `constructPath` (ops, coördinaten, minMax), in de CTM van
  transform/save/restore en Form-XObjects. Op een A0 met 26.036 lijnstukken duurt het lezen 34 ms. De gevonden lijnen
  vallen voor 98 % op inkt in de render; bij een verschoven controle is dat 38 %.
- **Klikken onder lagen.** Een klik in een SVG met lagen erboven kan via `document.elementsFromPoint` het onderliggende
  doel vinden. Bij Balkroosters f.grw ging het aantal aanklikbare staven van 15 naar 52–56 van 62.
- **Flex.** Met `flex-grow` waarvan de som kleiner is dan 1 vult een flexbox de ruimte niet. Dat brak het inklappen bij
  Splitsen.

## Audit 3.70 (deel teken en deel doc)
In 3.71 gerepareerd:
- reservekopie altijd vers bij Plat maken en Blad vervangen;
- Blad vervangen weigert na een bladwissel;
- bladwissel geblokkeerd tijdens een dialoog;
- doornummeren loopt door na heropenen;
- maatlabel klopt na wijzigen van de dikte;
- arcering gaat mee bij kopiëren;
- Zoeken gaat uit bij het kiezen van een tool;
- Vergelijken geeft een melding tijdens het opslaan;
- het ExtGState-criterium bij Plat maken.

Open, alleen beschreven:
- de controle "intussen gewijzigd" komt pas na de bestandskiezer;
- Plat maken en Vervangen bij een losse PDF zonder bestandsgreep;
- Tel alle op een andere pagina begint bij 1;
- de nummerballon is niet te bewerken;
- arcering op een meetvlak doet niets;
- de dekking geldt niet voor de arceerlijnen.

## In Revu te toetsen
Testblad en lijst staan in `Documents\PDF-analyse\revu-test-3.70` (lokaal, niet in de repo). Onzeker zijn:
- de opslagvorm van Cloud+: een groep, niet het eigen Revu-type;
- straal, diameter, volume en sparing: eigen sleutels;
- de vorm van de GoToR-links bij Batch Link.
