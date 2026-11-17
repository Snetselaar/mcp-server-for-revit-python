# SCI-Viewer audit PDF-deel 3.62 → 3.63 (17-11-2026)

Vraag van de gebruiker: "Audit de pdf gedeelte". Drie parallelle agents, elk een deel van de PDF-code (opdracht en rapporten in de
scratchpad `audit5\`):
- markups en opslaan (tekenen, tekst/bijschrift, opslaan met reservekopie, opgeslagen markups oppakken, gereedschapskist/.btx, meten);
- tonen en navigeren (de nieuwe tekenbuffer van 3.62, zoom/pan, lagen, zoeken, overlay, verwijzingen, sets lezen, geheugen);
- de nieuwe functies van 3.62 (plat maken, samenvoegen, set maken, handtekening) en de tab Opmerkingen.

Toetsing: in Node met lokale kopieën van pdf-lib 1.17.1 en pdf.js (uit de browsercache), daarna in de browser op t.pdf, t2.pdf en
de testbestanden van 3.62. De reparaties staan live als **3.63** (repo-commit `d8677f6`).

## Gerepareerd in 3.63
| Deel | Punt |
|---|---|
| Plat maken | Stelde de naam van het origineel voor. Kiezen + annuleren kon (vermoedelijk browsergedrag, niet in Edge nagemeten) een leeg origineel achterlaten. Nu "(plat)"-naam, de vraag vóór het werk, en een leeg origineel wordt uit het geheugen teruggezet. |
| Plat maken | Over het origineel: geen controle "intussen gewijzigd" en geen opslaanslot (bladwissel tijdens het werk schreef blad A over blad B). Beide toegevoegd. |
| Markups | Opgeslagen markup met arcering of lijnstijl (Beton, KZST, WVB) verloor die na verschuiven en opslaan: `bbBronDeel` las PatternName/PatternColor/PatternScale/LineStyle niet. |
| Markups | Drie Snetselaar-tools werden na opslaan deels afgeknipt (/BBox = /Rect terwijl de tekening er tot 20 pt buiten valt). |
| Beeld | Opruiming van de CAD-cache bij sluiten stond sinds 3.61 per ongeluk achter een commentaarteken (geheugenlek bij grote DWG's); basisbeeld `#pdfb` wordt vrijgegeven. |
| Beeld | `pdfInhoudSig` keek naar aantallen in plaats van inhoud: een opmerkingslabel kon na pannen verouderd blijven staan. Set zonder geopend blad toonde het beeld van het vorige tabblad. |
| Overig | Dubbelklik op Handtekening liet een tweede sessie hangen; reservekopie bij gelijke bestandsnamen in twee submappen; stempel na "Lagen hele set". |
| Startscherm | "Wat is er nieuw": aantal versies/aanpassingen pas in het uitklapblok (verzoek gebruiker). |

## Bevestigd in orde
- De tekenbuffer van 3.62 laat het beeld na markup-, laag-, zoek-, blad-, draai-, venster- en tabwijzigingen niet verouderd staan:
  die roepen allemaal `pdfTeken(m)` aan, dat de buffer eerst ongeldig maakt.
- .btx: alle tooldelen en hulpbronnen van de profielsets komen zonder verschil terug na schrijven en lezen.
- Opslaan: tekst met é, €, ü, haakjes en backslash komt heel terug; groepen, stempels, maten idem. /Rotate 0/90/180/270 klopt.
- Schrijven via de browser (`createWritable`) gaat via een tijdelijk bestand: geen half geschreven PDF of .bex bij een fout.

## Open (in bewerking na 3.63)
1. Wijzigingen tijdens het opslaan gaan stil verloren (markups die je tijdens het schrijven versleept of wijzigt).
2. Tekst gewijzigd onder Opmerkingen én dezelfde markup verschoven onder Markups → oude tekst na opslaan.
3. "Bluebeam-set maken" over een bestaande set nummert revisies opnieuw (S-9401: 31 van 39 anders); moet blad/rev/cat uit de
   bestaande .bex overnemen.
4. Samenvoegen mag een bronbestand niet als doel overschrijven; plat maken over het origineel zonder reservekopie.
5. Meetschaal van een losse PDF hangt alleen aan de bestandsnaam.
6. Drie acties in het opmerkingenpaneel tekenen de PDF niet direct opnieuw.

Niet opgepakt (gedrag in Revu onbekend): dubbele /NM na samenvoegen van revisies, /OC als laagnaam-tekst in 56 tooldelen,
antwoorden/groepsleden die achterblijven bij verwijderen van een opgeslagen markup.
