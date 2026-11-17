# SCI-Viewer: tweede audit (3.38 → 3.39) en wat de viewer nog mist (12-11-2026)

Vervolg op `2026-11-12-sci-viewer-audit-3.36.md` en `…-opvolging.md`. Vier agents werkten parallel:
- een regressiecontrole van de patches 3.37 en 3.38;
- een verdiepende audit van BCF/issues, sets, opmerkingen, clash en .rvt/STEP;
- een beveiligingsaudit van de viewer en de ontvanger (PowerShell);
- een onderzoek naar ontbrekende functies.

Elke bevinding is nagelezen in de code en waar het kon in de browser nagemeten. Live: **viewer 3.39** en **ontvanger 8** (repo-commit `d05fd84`).

## 1. Gerepareerd in 3.39 / ontvanger 8

| Deel | Punt | Getest |
|---|---|---|
| Issues | `bcfNaarProject` leest de BCF vlak voor het schrijven opnieuw in en voegt samen op GUID (`importeerBcf(…, merge)`): nieuw issue, statuswijziging en opmerkingen van een collega blijven staan. Verwijderde issues staan als grafsteen in `sci-verwijderd.json` in de zip en in `rmv-issues-weg:`. | Ja, met twee gesimuleerde gebruikers. |
| Issues | Een onleesbare BCF telt niet meer als "bestaat niet": status `onleesbaar`, er wordt niet overheen geschreven. Een kapot viewpoint breekt de import niet. Een ontbrekende snapshot wordt uit de BCF aangevuld; bij een vol localStorage komt er een melding. | Ja (kapotte zip). |
| Issues | De issuedialoog houdt een onbekende status of prioriteit (BIMcollab "Active", lege prioriteit) als optie. | Ja. |
| Beveiliging | Poortwachter voor `message`: alleen dezelfde herkomst én bron = eigen venster, ouder, opener, het paneel of een eigen kindvenster. Eerder kon een andere website via `sci-modellen-terug` een model met rauwe HTML (`m.opmerking`) in de 127.0.0.1-origin zetten. | Ja: een sandboxed iframe wordt geweigerd; splitsen werkt heen en terug. Losse vensters via `window.open` zijn niet getest. |
| Beveiliging | `esc(code)` in de oplegging-titel (Technosoft-XML); occt-import-js via `laadScript` (SRI); `xmlEsc` op de issue-GUID. | Rooktest. |
| Ontvanger 8 | Slotbestand (`FileShare.None`) om lezen-wijzigen-schrijven en toevoegen van `SCI-Viewer-meldingen.csv`; na 10 missers bij `/sci/meldstatus` een kwartier dicht; `Content-Length` verplicht; `Access-Control-Allow-Origin` niet meer `*`. | Ja, op poort 48932 met een testmap, daarna live vanaf de NAS (versie 8, viewer 3.39, meldnieuws). Gelijktijdig schrijven door twee pc's is niet getest. |
| PDF (regressie 3.38) | `Rotate` mee bij het oppakken van een opgeslagen tekstvak (`bbBronDeel`); `bbTekstOpnieuw` met het juiste hoekpunt; plakken op een blad met een andere draaiing rekent het vak om; annuleren bij de wachtwoordvraag wijst de laadtaak af; `mkWeg` op id en `opgeslagen` klopt; `pdfMetLagen19` weigert een versleutelde PDF. | Ja, behalve de wachtwoordvraag (geen beveiligde test-PDF). |
| PDF | Revisies: `revVolg` zet AA na Z. | Ja. |
| IFC | `markeerDubbeleDriehoeken`/`vulGaten` lopen in brokken met een percentage; de clashlijst wordt gewist als de modellen wijzigen; een afgebroken vergelijking haalt de oude versie uit de federatie. | Rooktest. |
| Rekenmodel | Platen met dezelfde naam krijgen een eigen GlobalId (de eerste houdt de oude); een Raamwerken-record korter dan de gelezen velden wordt overgeslagen (`RWW_MIN`; echte bestanden zitten daar ruim boven). | Rooktest op vier .rww. |

## 2. Open na deze ronde

**Beveiliging en beheer**
1. Schrijfrechten op de NAS-map: de viewer en de ps1-bestanden staan in een map waar de `Log\`-map naast staat. Als iedereen in de hele map mag schrijven, kan elke domeingebruiker de viewer of de ontvanger vervangen. Voorstel: schrijfrecht alleen op `Log\`. Dit is een beheerderstaak; de rechten zelf zijn niet bekeken.
2. Niet alle externe code heeft een controlesom: web-ifc wasm, libredwg (js en wasm), dxf-parser `+esm`, occt wasm en de woordenboeken. Oplossing: die bestanden naast de viewer op de NAS zetten en door de ontvanger laten leveren.
3. `/sci/meldstatus` accepteert nog `Origin: null` (nodig voor de Ontwikkelstraat, een file-pagina). De rem maakt raden onpraktisch; een gedeeld geheim zou het sluiten.
4. Privacy: het gebruikslog bevat Windows-naam, pc-naam, tijd en bestandsnaam en staat als kopie in `dashboard-data.js`. De publieke artifact-versie bevat sharepaden, projectnummers en initialen in de changelogtekst.
5. De ontvanger is enkeldraads: een onbereikbare share kan hem tientallen seconden laten wachten. Het log-CSV groeit onbeperkt en wordt bij elke regel helemaal herlezen.

**Functioneel**
6. Issues zijn op bestandsnaam gesleuteld: twee projecten met dezelfde IFC-naam delen hun issues. Het projectnummer in de sleutel vraagt een migratie van bestaande issues.
7. De PDF-koppeling van een issue (`i.bron`, `pdf.png`) overleeft de BCF niet: op een andere pc staat alles op "niet gekoppeld".
8. Snapshots in localStorage: structureel hoort dit in IndexedDB (nu alleen een melding en aanvullen uit de BCF).
9. Koppelen (PDF ↔ model) kan op "koppelen…" blijven staan als het andere venster niet antwoordt.
10. Zip-parsers zonder groottelimiet; `cfbOpen` zonder cyclusbewaking (een kapot bestand laat alleen het eigen tabblad vastlopen).
11. Uit de vorige ronde: grenscontrole in `parseEsa`; draairichting van een gedraaide DWG-viewport op een echt bestand; bijschriftpijl op een gedraaid blad hecht aan de pagina-zijden.

## 3. Wat de viewer nog niet heeft

Bron: de changelog (336 regels) als functiekaart, met grep in de code nagegaan dat een functie echt ontbreekt, en een vergelijking met BIMcollab Zoom, Solibri, Navisworks, BIMvision en Bluebeam Revu. Alleen de BIMcollab- en Revu-pagina's zijn actueel opgezocht; de rest steunt op algemene kennis.

| # | Functie | Voor wie | Grootte |
|---|---|---|---|
| 1 | Markuplijst exporteren (CSV over een hele set: open/verwerkt per ronde) | projectleider, constructeur | klein |
| 2 | ILS-snelcheck: NL-SfB, LoadBearing/IsExternal/FireRating gevuld, materiaal | modelleur | klein-middel |
| 3 | Betonstaat: m³ en m² per klasse, type, materiaal en bouwlaag | constructeur, projectleider | klein-middel |
| 4 | Meten en kalibreren in PDF (lengte, oppervlak, aantal), opgeslagen als Revu-maat | constructeur | middel |
| 5 | Markupstatus en antwoorden (Accepted/Rejected, reply) | constructeur, modelleur | klein-middel |
| 6 | Zachte clash (vrije ruimte in mm) en clashes groeperen | modelleur | klein-middel |
| 7 | IDS-controle (.ids inlezen, rapport per specificatie) | modelleur, projectleider | middel-groot |
| 8 | Sparingencontrole: sparingsmodel van de installateur tegen de constructie | constructeur | middel |
| 9 | Opgeslagen aanzichten los van issues; issue-rapport (PDF/Excel) | allen, projectleider | klein |
| 10 | Detailverwijzingen in een PDF-set volgen | constructeur | middel |

Net daarbuiten: wapeningslijst uit IFC, tekeningenlijst- en titelblokcontrole, doorsnede uit IFC als 2D-DXF, georeferentie (IfcMapConversion), PDF-bladwijzers en miniaturen, DWG als onderlegger.

**Bewust niet doen:** regelgebaseerde modelcontrole à la Solibri, 4D en renderen, Studio-sessies en live BIMcollab-koppeling (vragen een server), PDF samenvoegen/formulieren/ondertekenen, OCR, een volledige Revit- of Tekla-lezer.

**Puntenwolken:** het onderzoek raadt ze af (geheugen en bestandsgrootte). Albert had de keuze E57/PTS tegenover RCS nog open staan; dat blijft zijn beslissing.

### Aanbevolen volgorde
1. Markuplijst exporteren, betonstaat, opgeslagen aanzichten: klein, bouwen op wat er al is.
2. ILS-snelcheck: uitbreiding van de bestaande kwaliteitscheck.
3. PDF meten met kalibratie: grootste winst voor constructeurs, die daarvoor nu naar Revu moeten.
4. Zachte clash en sparingencontrole: bouwen op de clashmotor.
5. IDS: pas als opdrachtgevers .ids-bestanden gaan aanleveren.
