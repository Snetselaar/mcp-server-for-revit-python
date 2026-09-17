---
titel: Bluebeam-sets automatisch aanvullen met nieuwe PDF-revisies en hun opmerkingen
status: concept
laatst-bijgewerkt: 2026-09-17
bronnen:
  - "waargenomen in P:\\9000-9999\\9400-9449\\9429 - bedrijfsgebouw op bedrijventerrein Kraaienhoef Poederoijen\\8 Interne controle\\02. Sets\\S-9429.bex en de PDF's in die map, 2026-09-17"
  - "W:\\7 - Software\\Bluebeam\\Sets\\S-0000.bex (sjabloonset), 2026-09-17"
  - "C:\\Program Files\\Bluebeam Software\\Bluebeam Revu\\21\\Help\\Bluebeam Script Reference.pdf (Script Reference 2.0.11)"
  - "test van ScriptEngine.exe op de werkplek van AWO, Revu 21.11.0.23287 Complete, 2026-09-17"
  - "W:\\4 - Tijdelijk en verwijderen\\AWO\\Extensions\\01_SCI\\SCI.extension\\01_SCI.tab\\Printen.panel\\Plot.pushbutton\\script.py:1080-1108, 1274-1305, 1386-1407"
  - "tests op kopieën van de S-9429-set met prints 0.04 en 0.05, en controle in Revu door de gebruiker, 2026-09-17"
  - https://support.bluebeam.com/revu/subscription/subscription-features.html (rij "Implement scripting commands", opgehaald 2026-09-17)
  - https://support.bluebeam.com/online-help/revu21/Content/RevuHelp/Menus/Document/Script/Using-Scripts.htm
  - "gebruiker, 2026-09-17: PDF's met meer dan één blad komen nooit voor; idee verzonden set geparkeerd; formaatwissel is bekend en wordt bij het printen voorkomen; het team werkt al 3 jaar met sets"
verwant: []
---

# Bluebeam-sets automatisch aanvullen met nieuwe PDF-revisies en hun opmerkingen

Aanleiding: bij de interne controle staat per project een Bluebeam-set in
`8 Interne controle\02. Sets`. Per tekening staan daarin alle geprinte versies.
Elke nieuwe PDF kreeg met de hand een Bladnummer en Revisienummer in de
Tags-dialoog, terwijl die gegevens al in de bestandsnaam staan. AutoMark op een
gebied van de tekening wilde het team bewust niet gebruiken.

Stand 2026-09-17: een werkend testscript, door collega's in test. Nog niet
uitgerold.

## 1. De set is gewone XML

Een `.bex` is UTF-8-XML met BOM en CRLF-regeleinden, wortelelement
`BluebeamRevuPageSet`. Elke PDF is één `<File>`-blok:

```xml
  <File>
    <![CDATA[2026-09-16_v0.03\S-9429 - DO-01 - Fundering Begane grondvloer_2026-09-16_v0.03.pdf]]>
  <Category>Fundering</Category><Page><Label>2</Label><Tags><Tag ID="SheetNumber">01</Tag><Tag ID="RevisionNumber">2</Tag></Tags><Width>3370</Width><Height>2384</Height><Index>0</Index></Page>
    <![CDATA[2026-09-16_v0.03\S-9429 - DO-01 - Fundering Begane grondvloer_2026-09-16_v0.03.pdf]]>
  </File>
```

Waargenomen in `S-9429.bex`:

- Het pad is relatief ten opzichte van de set en staat twee keer in CDATA.
- `Label` is het PDF-paginalabel, niet het bladnummer. Revit-prints hebben
  daar `1` of `2`.
- `Width` en `Height` zijn in punten. Bij de staande tekeningenlijst schreef
  Revu `842 × 595.22`, terwijl de MediaBox `595.22 × 842` is. Revu draait de
  maat dus zelf; waarom is `[ONBEVESTIGD]`.
- Het **revisienummer is een volgnummer per bladnummer**, niet het setnummer.
  P01 kwam pas in set 0.02 en heeft daar revisie 0.
- Het bladnummer staat zonder fasevoorvoegsel: Revit-blad `DO-01` heet `01`.
- Revu voegde de v0.03-regels achteraan toe; volgorde in het bestand doet er
  niet toe.
- `<Table>` bevat per categorie trefwoorden (`Fundering; grondvloer; palenplan`).

## 2. Wat niet kan

**Een Bluebeam-script (.bci) kan geen sets bewerken.** De Script Reference
2.0.11 van Revu 21 kent geen enkel commando voor sets. Een knop ín Revu die de
set bijwerkt is daarmee uitgesloten.

**Revu Complete kan geen scripts buiten Revu draaien.** De Script Reference
kent wel `Import("vorige.pdf")`, dat de opmerkingen uit een andere PDF
overneemt. `ScriptEngine.exe Script("…bci")` gaf op 2026-09-17 echter exit
code -4 met de melding "This feature requires a maximum subscription level".
Scripting als zodanig zit volgens Bluebeam in de abonnementen Complete en Max
("Implement scripting commands"); tot en met Revu 20 heette die editie eXtreme,
en de meegeleverde Script Reference 2.0.11 noemt nog "Revu eXtreme". De melding
wijst dus op **Max** voor het externe `ScriptEngine.exe`.
[ONBEVESTIGD] Dat Max het externe draaien wél toestaat: de featuretabel noemt de
externe script engine niet apart, en Max is niet getest.

**De eigen revisie-invoer van Revu helpt niet zonder tags.** Revu koppelt een
nieuwe pagina alleen aan een bestaande revisie als die pagina al een
bladnummer heeft, en dat komt uit AutoMark. [ONBEVESTIGD] Afgeleid uit de
handmatige werkwijze van het team (bladnummer en revisie met de hand invullen
in de Tags-dialoog, zie de aanleiding) en uit `S-9429.bex`, waar elke pagina een
`SheetNumber`-tag draagt; niet in de Revu-documentatie nagelezen.

## 3. Wat Revu zelf doet bij een nieuwe revisie

De set staat op `CopyMarkups=1` en `StampPrevious=1`. Gemeten door de
annotaties van DO-11 in 0.02 en v0.03 te vergelijken (pypdf, 2026-09-17):

- Alle 99 opmerkingen van 0.02 staan ook in v0.03, met dezelfde `/NM`-id.
- 93 daarvan liggen op de laag (OCG) `Verwerkt ronde 1`, in beide bestanden.
- De enige opmerking die ontbreekt is de stempel met `/Subj (Vervangen)`.
- Die stempel staat juist op de vorige revisie. Revu zette hem daar op het
  moment dat v0.03 werd toegevoegd (`/CreationDate` 2026-09-16 17:02).
- Een stempel `Momentopname` gaat wel mee.
- Verschillen in `/Rect` zijn afrondingen in de vierde decimaal.

De opmerkingen zitten in de PDF zelf, niet in de `.bex`. Een set aanpassen
raakt dus geen opmerking.

## 4. De oplossing: "Set bijwerken"

Twee delen, samen gestart vanuit `Set bijwerken.bat`:

| Bestand | Draait op | Doet |
|---|---|---|
| `Set bijwerken.ps1` | Windows PowerShell 5.1 | nieuwe PDF's zoeken, bladnummer en revisie bepalen, set bijwerken, set openen |
| `markups_overzetten.py` | de CPython van pyRevit (`%APPDATA%\pyRevit-Master\bin\cengines\CPY3123\python.exe`) | opmerkingen overzetten, vorige revisie stempelen |
| `lib\pypdf` | idem | PDF-bibliotheek, pure Python, meegeleverd (6.18.1, BSD) |
| `Vervangen-stempel.pdf` | | voorbeeld van de stempel `Vervangen` |

Werking van het PowerShell-deel:

1. Het zoekt alle PDF's onder de setmap die nog niet in de `.bex` staan.
   Mappen die met `_` beginnen slaat het over (scriptmap, backups).
2. Het ontleedt de naam met `^(?<proj>.+?) - (?<nr>[^ ]+) - (?<naam>.+)\.pdf$`.
   Het bladnummer is `nr` zonder `^[A-Za-z]{2,3}-`. Een fasewissel `DO-01` →
   `UO-01` telt dus door op dezelfde reeks; dat was een keuze van de gebruiker.
3. De sorteerdatum komt uit de naam (`_jjjj-mm-dd`). Zonder datum in de naam
   valt het terug op de wijzigdatum van het bestand.
4. Revisie = hoogste bestaande revisie van dat blad + 1. Een blad dat nog niet
   bestaat begint op 0.
5. Categorie en `Label` komen van de vorige revisie. Voor een nieuw blad wint het
   trefwoord uit `<Table>` dat het vroegst in de tekeningnaam staat
   ("Wanden kelder" → Wanden, niet Plattegronden via "kelder").
6. De maat meet het in de MediaBox van de nieuwe PDF. Zijn het dezelfde getallen
   als bij de vorige revisie, eventueel gedraaid, dan houdt het de waarde van Revu.
7. Per nieuwe revisie roept het `markups_overzetten.py` aan. Faalt dat, dan
   stopt het vóór de set wordt geschreven.
8. Het schrijft een backup naar `_backup set`, voegt de `<File>`-blokken als
   tekst in vóór het eerste `<CategoryState>`, controleert of het resultaat
   geldige XML is, en opent de set.

Werking van het Python-deel, nagebouwd op §3:

- Het kloont elke annotatie van de vorige revisie naar dezelfde pagina van de
  nieuwe PDF, behalve `Vervangen`-stempels, `Link` en `Widget`.
- `/P`, `/Popup`, `/Parent` en `/IRT` legt het opnieuw naar de klonen.
- Een `/OC`-laag maakt het in het doel aan met dezelfde naam en dezelfde
  aan/uit-stand.
- Een opmerking met een `/NM` die al in het doel staat, slaat het over. Opnieuw
  draaien voegt daardoor niets dubbel toe.
- Het stempelt elke pagina van de vorige revisie die nog geen `Vervangen`-stempel
  heeft. De stempel schaalt mee met de paginamaat.
- Beide PDF's schrijft het als incrementele update via een tijdelijk bestand. De
  oorspronkelijke bytes blijven staan.

Een gestempelde vorige PDF groeit ongeveer 150 kB, door het ingesloten lettertype
van de stempel. Revu's eigen stempel doet hetzelfde.

## 5. Testresultaten

| Test (2026-09-17) | Uitkomst |
|---|---|
| v0.03-regels uit een kopie van `S-9429.bex` halen en het script ze laten toevoegen | byte-gelijk aan wat Revu schreef |
| Print 0.04 toevoegen | 00–43 rev 3, P01 rev 1, TL rev 2; per blad even veel opmerkingen als Revu bij v0.03 (4, 101, 99, 95, 152, 112, 93, 73) |
| Script opnieuw draaien | "Geen nieuwe tekeningen"; `markups_overzetten.py` los opnieuw: 0 gekopieerd, geen tweede stempel |
| Print 0.05 toevoegen, gecontroleerd in Revu | "echt perfect" volgens de gebruiker |
| Fasewissel `UO-01`, twee versies van één blad tegelijk, nieuw blad, vreemde bestandsnaam | rev 3, rev 3 en 4 op datum, rev 0 met categorie, gemeld en overgeslagen |

Bij de eerste 0.04-test ging het overzetten mis. Die run gebeurde met de versie
van vóór het Python-deel; de gebruiker heeft 0.04 toen met de hand rechtgezet.

PDF's met meer dan één blad komen bij SCI nooit voor (gebruiker, 2026-09-17).
Het script koppelt pagina's op volgorde en waarschuwt als het aantal verschilt,
maar dat geval hoeft niet getest te worden.

Een formaatwissel (bijvoorbeeld A1 naar A0) laat de opmerkingen verschuiven,
ook in Revu zelf. Het team werkt al drie jaar met sets, kent dat en houdt er
bij het printen rekening mee (gebruiker, 2026-09-17). Het script waarschuwt
alleen; verder is het geen open punt.

## 6. Stand en vervolg

- Testpakket: `W:\4 - Tijdelijk en verwijderen\AWO\Bluebeam Set bijwerken`
  (`Set bijwerken.bat`, `LEESMIJ.txt`, map `_Set bijwerken`). Gebruik: de bat en
  de map samen naar `02. Sets` van een project kopiëren. De set en de tekeningen
  moeten dicht zijn in Revu, anders overschrijft Revu de wijziging bij het sluiten.
- Beoogde uitrol na de collega-test: `W:\7 - Software\Bluebeam\Sets\Script\`, en
  de bat in de sjabloonmap `W:\7 - Software\Bluebeam\Sets` naast `S-0000.bex`.
- Daarna samenvoegen met Plot in de modus interne controle, via 03_R&D. Plot
  weet de uitvoermap al (`resolve_output_paths`) en draait op IronPython 2.7,
  dus het Python-deel moet extern worden aangeroepen.

## 7. Idee: een verzonden set in `7 Uit`

Probleem: de laatst verstuurde versie van een PDF raakt vaak zoek. Idee van de
gebruiker (2026-09-17): dezelfde aanpak voor een set in `7 Uit`, die dan altijd
de laatste verzonden versie bovenaan heeft.

Wat daarbij anders is dan bij de interne controle:

- **In verzendmodus heeft de bestandsnaam geen datum en geen suffix.** Plot
  schrijft naar `7 Uit\<jjjj-mm-dd>[_<suffix>][ (n)]\` en zet de datum alleen in
  de mapnaam (`script.py:1386-1407`). Elke verzending van DO-01 heet dus
  `S-9429 - DO-01 - Fundering Begane grondvloer.pdf`.
- Het huidige script valt dan terug op de wijzigdatum van het bestand. Dat is
  onbetrouwbaar, want opslaan met opmerkingen en de `Vervangen`-stempel wijzigen
  die datum. De aanpassing: de datum eerst uit de mapnaam halen, daarna pas uit
  de bestandsdatum. Twee verzendingen op één dag onderscheidt het volgnummer
  `(n)` in de mapnaam.
- In S-9429 staan onder de datummap submappen `DWG`, `IFC` en `PDF`. Het script
  zoekt alleen PDF's, dus DWG en IFC storen niet.
- In `7 Uit` van S-9429 staat al een lege map `00_laatste versie tekeningen`
  (aangemaakt 2023-09-21). Dat is een eerdere handmatige poging tot hetzelfde.
- Of de `Vervangen`-stempel ook in een verzonden set gewenst is, is niet besproken.
  Het script moet hem dan kunnen uitzetten (`--geen-stempel` bestaat al).

Status: geparkeerd op 2026-09-17, "een gedachte". Niet gebouwd.
