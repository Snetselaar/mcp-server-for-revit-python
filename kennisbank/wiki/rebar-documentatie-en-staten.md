---
titel: Wapening documenteren — tags, filters en buigstaten
status: concept
laatst-bijgewerkt: 2026-08-26
bronnen:
  - "raw/2026-08-25 samenvatting-bronnen.md §1.4 en §1.7"
  - "raw/2026-08-25-samenvatting-revit-structure-rebar.md §1.C"
verwant:
  - rebar-3d-modelleren.md
  - rebar-api-parameters.md
  - nlrs-en-bim-standaarden.md
skill: sci-bim-context
---

# Wapening documenteren

Van gemodelleerde staaf naar leesbare tekening en bruikbare buigstaat. Het
modelleren zelf staat in `rebar-3d-modelleren.md`; de versietabel daar geldt ook
hier.

---

## 1. Partitions — eerst bundelen, dan schedulen

De parameter **Partition** (Properties, groep *Construction*) bundelt
wapeningsgroepen zodat uittrekstaten per onderdeel te organiseren zijn. De bron
geeft als voorbeeld een waarde als "kolom A1 begane grond".

Dit is de stap die vooraf gaat aan alles hieronder. Zonder partitie-indeling is
een uittrekstaat op een project van formaat onleesbaar, en dat is achteraf
corrigeren duur werk.

[ONBEVESTIGD] Of SCI een vaste conventie heeft voor de inhoud van Partition.
`sci-bim-context` §3 beschrijft wel de browser-organisatie via `hoofd_map` en
`sub_map`, maar zegt niets over Partition. Uitzoeken — als er geen conventie is,
is dat er een om te maken.

---

## 2. Kleurcodering via filters

Rule-based filters in *View Templates*, op parameters zoals `Typename`. Twee
categorieën, en ze zijn gescheiden:

- `Structural Rebar` voor staven
- `Structural Fabric Reinforcement` voor netten

> **Conflict met skill `sci-bim-context`:** de bronnen-dump §1.7 stelt voor om
> zulke filters op te zetten. Volgens `sci-bim-context`
> (`references/template-en-mcp.md` §A) heeft de SCI-template **al** een
> wapeningdiameter-filtersysteem voor ø6 t/m ø40, en §5 van diezelfde skill zegt
> letterlijk: de standaard-template bevat al filters, stel geen generieke
> automatisering voor die hier al in zit.
>
> Bouw deze filters dus niet opnieuw. Wat de dump wél toevoegt is de scheiding
> tussen de twee categorieën — of het bestaande filterstelsel ook
> `Structural Fabric Reinforcement` afdekt, of alleen staven, is niet nagegaan.

---

## 3. Tags

Detailviews op schaal **1:5 tot 1:10**, met een beperkte `Far Clip` zodat er geen
staven uit de diepte meeliften.

De tagfamilie is een `Structural Rebar Tag` met tekst-labels voor *Quantity*,
*Bar Diameter* (Ø) en *Rebar Number*. `Add / Remove Host` laat één tag meerdere
staven van dezelfde soort aanwijzen.

De bron schrijft voor die tag "conform de NLRS-naamgeving" te maken. Dat raakt de
huisregels in `sci-bim-context` §5, waar vaste tagfamilies staan vastgelegd — voor
kolommen bijvoorbeeld `NLRS_28_TAG-SCOL_kolom-dec_SCI` type `tekst - zonder lijn`.
[ONBEVESTIGD] Of er een vergelijkbare vastgelegde SCI-tagfamilie voor wapening
bestaat. Zo niet, dan is dat een gat.

Let ook op de huisregel dat staal getagd wordt en beton gedimensioneerd
(`sci-bim-context` §5). Wapening is beton, maar krijgt hier wél tags — dat is geen
tegenspraak (die regel gaat over constructie-elementen in detailviews, niet over
staven), maar het is een plek waar iemand zich kan vergissen.

---

## 4. Maatvoering

**Multi-Rebar Annotation** (MRA) bemaat en tagt een hele wapeningsgroep via één
maatlijn. De bronnen-dump noemt de lineaire variant, `Linear Multi-Rebar
Annotation`, voor repetitieve wapening.

Dit is de wapeningstegenhanger van het handwerk dat het SCI-dimensioneerscript
voor detailviews doet (`sci-bim-context`, `references/scripts-en-skills.md`).
[ONBEVESTIGD] Of dat script iets met wapening doet of alleen met
constructie-elementen.

---

## 5. Buigstaten

Schedule op categorie `Structural Rebar`.

**Velden:** *Shape*, *Bar Diameter*, *Bend Diameter*, *Bar Length*, *Rebar
Number*, *Reinforcement Volume*, *Partition*, *Quantity*, *Bending Detail*.

**Sorteren** op *Shape*, *Rebar Number* en *Bar Diameter*, met `Itemize every
instance` **uit**. Zonder dat laatste krijg je één regel per staaf in plaats van
per soort.

### Bending Details (2024+)

Het veld *Bending Detail* toont een door Revit gegenereerde, bemate buigvorm in
de tabel.

Twee praktische punten die je anders zelf ontdekt:

- **In een model-view blijft het veld leeg.** Dat is normaal gedrag voor
  afbeeldingen; ze verschijnen pas als de schedule op een sheet staat.
- Op het sheet: schedule selecteren, in Properties `Resize Rows` op `Image Rows`
  en `Row Height` op bijvoorbeeld 40 mm, anders zijn de vormen onleesbaar.

Sinds **2025** zijn *Schematic* en *Realistic* Bending Details ook rechtstreeks in
2D-aanzichten te plaatsen, niet alleen in schedules. Ze updaten mee met wijzigingen
aan de staven. Niet beschikbaar op 2024.

### Bending Detail is niet Shape Image

Twee verschillende dingen die makkelijk verward worden:

| | Bending Detail | Shape Image |
|---|---|---|
| Komt van | Revit zelf, gegenereerd | een afbeelding die je zelf toevoegt |
| Bemating | ja, automatisch | nee, het is een plaatje |
| Sinds | 2024 | bestond al langer |
| In de API | — | zie hieronder |

De dump noemt `REBAR_SHAPE_IMAGE` als BuiltInParameter voor die afbeelding.
Dat is waarschijnlijk onjuist: "Shape Image" lijkt een parameter die je zelf in de
familie aanmaakt. Zie `rebar-api-parameters.md` §3.
