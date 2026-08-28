---
titel: BuiltInParameters voor wapening — wat er klopt van de dump
status: concept
laatst-bijgewerkt: 2026-08-28
bronnen:
  - "gemeten 2026-08-28: live Routes-API op localhost:48884, Revit 2025, Enum.IsDefined(BuiltInParameter, <naam>) via /execute_code/"
  - "raw/2026-08-25-samenvatting-revit-structure-rebar.md §5 (de te controleren tabel)"
  - https://forums.autodesk.com/t5/revit-api-forum/get-rebar-layout-rule/td-p/12431938
  - https://www.revitapidocs.com/2015/669bcf80-e0b7-ee57-30c0-82fdf4184012.htm
  - https://help.autodesk.com/view/RVT/2025/ENU/?guid=Revit_API_Revit_API_Developers_Guide_Discipline_Specific_Functionality_Structural_Engineering_Structural_Model_Elements_Reinforcement_Rebar_html
  - https://www.revitapidocs.com/2024/fb011c91-be7e-f737-28c7-3f1e1917a0e0.htm
verwant:
  - rebar-3d-modelleren.md
  - rebar-documentatie-en-staten.md
  - mcp-revit-koppeling.md
  - revit-bronnen-en-communities.md
skill: revit-api-docs
---

# BuiltInParameters voor wapening

De dump `2026-08-25-samenvatting-revit-structure-rebar.md` §5 bevat een tabel met
acht `BuiltInParameter`-namen. Die tabel is overgenomen uit een AI-samenvatting,
en de skill `revit-api-docs` §0 regel 2 verbiedt het doorgeven van zulke namen
zonder controle. Dit artikel legt vast wat de controle heeft opgeleverd.

---

## 0. Wat "gecontroleerd" hier betekent — lees dit eerst

> **Update 2026-08-28 — het bestáán van de acht namen is nu geverifieerd, sterker
> dan via een doc-pagina.** Op de werkplek draaide Revit 2025 met de Routes-server
> live op `localhost:48884`. Via `/execute_code/` is per naam
> `Enum.IsDefined(DB.BuiltInParameter, "<naam>")` uitgevoerd. **Alle acht gaven
> `True`**, plus de vijf `CLEAR_COVER_*`-varianten. Daarmee zijn de twee
> `[ONBEVESTIGD]`-namen (`REBAR_ELEM_HOST_MARK`, `REBAR_NUMBER`) bevestigd en is
> de aanname dat `REBAR_SHAPE_IMAGE` géén BuiltInParameter zou zijn, weerlegd.
>
> Twee grenzen aan deze meting: (1) `Enum.IsDefined` toetst alleen dat de **naam**
> een geldig enum-lid is, niet wat de parameter betékent of teruggeeft — de
> beschrijvingscorrectie bij `CLEAR_COVER` in §2 blijft dus staan. (2) Gemeten op
> **Revit 2025**; 2024 en 2027 zijn niet apart getoetst, maar dit zijn
> langbestaande enum-leden, dus verschil is onwaarschijnlijk. De secties hieronder
> beschrijven de oorspronkelijke, doc-geblokkeerde beoordeling; de verdicts zijn
> per sectie bijgewerkt.
>
> Dit legt ook een methode vast die de skill `revit-api-docs` niet noemt: een
> naam toetsen tegen de **draaiende** API met `Enum.IsDefined` is definitiever dan
> een documentatiepagina, mits Revit lokaal bereikbaar is via de Routes-server
> (zie `mcp-revit-koppeling.md` §4).

**Geen enkele claim hieronder is geverifieerd in de zin van `revit-api-docs` §0
regel 3.** Die regel eist een opgehaalde documentatiepagina. In de sessie waarin
dit artikel geschreven is, blokkeerde de netwerkpolicy alle vier de bronnen uit
die skill:

```
revapidocs.com:443        gateway 403 op CONNECT
rvtdocs.com:443           gateway 403 op CONNECT
www.revitapidocs.com:443  gateway 403 op CONNECT
help.autodesk.com         geblokkeerd
```

Ook de niet-Autodesk-bronnen (forums, blogs) bleken onbereikbaar: bij een
controle op 2026-08-26 gaf de proxy op **elk** van de acht URL's in dit artikel
een blokkade. De URL's komen dus uit zoekresultaten — ze zijn niet verzonnen
(`revit-api-docs` §0 regel 1), maar of ze vandaag nog laden is hier niet
vastgesteld. Reken op een enkele dode link.

Wat wél kon: zoeken. De categorieën hieronder zijn daarom:

- **Bevestigd via zoekresultaat** — de exacte naam is teruggevonden in werkende
  code of op een echte pagina, maar die pagina is niet opgehaald.
- **Niet bevestigd** — de naam is nergens teruggevonden. Dat betekent niet dat
  hij fout is, wel dat de dump de enige bron is.

**Openstaande actie:** deze tabel opnieuw langslopen vanuit een omgeving waar
`revitapidocs.com` bereikbaar is. Zie de laatste sectie.

---

## 1. Bevestigd via zoekresultaat

Alle vier de namen in deze sectie gaven op 2026-08-28 ook `True` op
`Enum.IsDefined` in de live Revit 2025-API (zie de update in §0). Ze staan dus
dubbel vast: teruggevonden in code én bevestigd als geldig enum-lid.

### `REBAR_ELEM_LAYOUT_RULE` en `REBAR_ELEM_BAR_SPACING`

De sterkste twee. Beide komen voor in werkende code in een draad op het Revit API
Forum, in hetzelfde fragment:

```csharp
Parameter layoutParam = rebar.get_Parameter(BuiltInParameter.REBAR_ELEM_LAYOUT_RULE);
if (layoutParam.AsInteger() == 0) { return ""; }
Parameter spacingParam = rebar.get_Parameter(BuiltInParameter.REBAR_ELEM_BAR_SPACING);
```

Bron: [Get Rebar Layout Rule](https://forums.autodesk.com/t5/revit-api-forum/get-rebar-layout-rule/td-p/12431938).

Twee dingen die de dump niet vermeldt en die in de praktijk uitmaken:

- `REBAR_ELEM_LAYOUT_RULE` levert een **integer**, geen tekst. Waarde `0` staat
  in dat fragment voor de vaste-aantal-variant.
- **Een set met "Fixed number" heeft geen spacing.** Uitlezen van
  `REBAR_ELEM_BAR_SPACING` zonder eerst de layout rule te checken levert dus
  onzin. Dat is precies waarom het codefragment die volgorde aanhoudt.

### `REBAR_ELEM_QUANTITY_OF_BARS` en `REBAR_ELEM_TOTAL_LENGTH`

Beide staan genoemd op de revitapidocs-pagina van `AddFormulaParameter`, in de
lijst van parameters waar formules in een rebar shape-definitie naar mogen
verwijzen. Pagina niet opgehaald; naam teruggevonden via zoeken.

Bron: [AddFormulaParameter Method](https://www.revitapidocs.com/2015/669bcf80-e0b7-ee57-30c0-82fdf4184012.htm)
(jaargang 2015 — die vindplaats zegt dus niets over 2024–2027).

---

## 2. Correctie: `CLEAR_COVER` betekent niet wat de dump zegt

De dump zet in de tabel:

> `CLEAR_COVER` — **Rebar Cover** — De betondekking van de constructieve host.

Dat klopt niet. De dekking wordt niet door één parameter geregeld maar door een
familie parameters, elk gebonden aan een ander type host en een ander vlak:

| Parameter | Geldt voor |
|---|---|
| `CLEAR_COVER_TOP` | alle hosts behalve wanden en in-place families |
| `CLEAR_COVER_BOTTOM` | idem |
| `CLEAR_COVER_EXTERIOR` | alleen wanden |
| `CLEAR_COVER_INTERIOR` | alleen wanden |
| `CLEAR_COVER_OTHER` | alle hosts behalve in-place families en trappen |
| `CLEAR_COVER` | **alleen in-place families en trappen** |

`CLEAR_COVER` is dus de uitzondering, niet de regel. Wie hem gebruikt om "de
dekking van de host" op te halen, krijgt op een gewone balk of vloer niets.

De namen zelf — `CLEAR_COVER` en alle vijf de `CLEAR_COVER_*`-varianten — zijn op
2026-08-28 alle bevestigd in de live enum (Revit 2025, `Enum.IsDefined`). Dat
raakt de beschrijvingscorrectie hierboven niet: die gaat over wat `CLEAR_COVER`
betékent, niet over of de naam bestaat. De dump had de naam goed en de
beschrijving fout.

Dekking hangt aan afzonderlijke **vlakken** van de host en wordt in de API
benaderd via `RebarHostData` (`GetCoverType` / `SetCoverType`); de
`CLEAR_COVER_*`-parameters zijn daar een beperkte ingang op. `RebarCoverType` is
de benoemde waarde voor een dekkingsafstand.

Bron: [Help | Rebar (RVT 2025)](https://help.autodesk.com/view/RVT/2025/ENU/?guid=Revit_API_Revit_API_Developers_Guide_Discipline_Specific_Functionality_Structural_Engineering_Structural_Model_Elements_Reinforcement_Rebar_html)
en [RebarCoverType Class](https://www.revitapidocs.com/2025/b90685db-d2c5-aecb-ff1f-425ca2e5fae9.htm).
Beide pagina's niet opgehaald.

Dit sluit aan op `rebar-3d-modelleren.md` §2, waar de dekkingstypes 0/20/40 mm
staan: die stel je per vlak in, niet per element.

---

## 3. Voorheen onbevestigd — nu bevestigd (2026-08-28)

### `REBAR_ELEM_HOST_MARK` en `REBAR_NUMBER`

De **parameters** bestaan: "Host Mark" en "Rebar Number" zijn bekende
wapeningsparameters, en de combinatie van die twee vormt het unieke staafmerk.
Vóór Revit 2015 ging dat via een handmatige parameter "Schedule Mark".

De **exacte enum-spelling** is op 2026-08-28 bevestigd:
`Enum.IsDefined(DB.BuiltInParameter, "REBAR_ELEM_HOST_MARK")` en
`... "REBAR_NUMBER")` gaven beide `True` in de live Revit 2025-API. `REBAR_NUMBER`
is inderdaad kort naast de `REBAR_ELEM_`-reeks, maar het is een geldig enum-lid.
De eerdere `[ONBEVESTIGD]`-markering vervalt.

Bron voor het bestaan van de parameters:
[Modelling Reinforcement in Revit](https://www.symetri.co.uk/insights/blog/modelling-reinforcement-in-revit-tips-and-tricks/),
en de live-meting hierboven.

### `REBAR_SHAPE_IMAGE` — bestaat wél als BuiltInParameter

De dump zet `REBAR_SHAPE_IMAGE` neer als BuiltInParameter voor de afbeelding van
de buigvorm die in uittrekstaten getoond kan worden. Dit artikel vermoedde eerder
dat dat onjuist was, omdat meerdere blogs "Shape Image" beschrijven als een
parameter die de gebruiker zelf toevoegt in de Family Types-editor van de rebar
shape-familie.

**Dat vermoeden is op 2026-08-28 weerlegd.**
`Enum.IsDefined(DB.BuiltInParameter, "REBAR_SHAPE_IMAGE")` gaf `True` in de live
Revit 2025-API. `REBAR_SHAPE_IMAGE` ís een BuiltInParameter; de dump had gelijk.

De twee waarnemingen sluiten elkaar niet uit: er bestaat een ingebouwde parameter
én in de praktijk voegt men soms een eigen familie-afbeeldingparameter toe voor
shapes waar de ingebouwde niet gevuld is. Wat `Enum.IsDefined` niet zegt, is of en
waarmee de ingebouwde parameter in standaard Rebar Shapes gevuld is — dat is een
semantische vraag die alleen documentatie of een model beantwoordt.

**Let op de verwarring met Bending Details.** Sinds Revit 2024 bestaat het
schedule-veld *Bending Detail*: een door Revit zélf gegenereerde, bemate
buigvorm. Dat is iets anders dan een handmatig toegevoegde afbeelding. Zie
`rebar-documentatie-en-staten.md`.

Bronnen: [Rebar Shape Images in Revit (Autodesk)](https://www.autodesk.com/support/technical/article/caas/tsarticles/ts/1L02xAHDK9iZnhFfg1nZ9J.html),
[Revit beyond BIM](https://revitbeyondbim.wordpress.com/2016/12/15/rebar-shape-images-in-revit/).

---

## 4. Vondst naast de tabel: 2024 verandert het type van de enum

In **Revit 2024** is de onderliggende typegrootte van `BuiltInParameter`
opgehoogd van **32-bit naar 64-bit**, om opslag en conversie als `ElementId`
mogelijk te maken.

Relevant omdat SCI 2024 t/m 2027 moet ondersteunen: code die een
`BuiltInParameter` naar `int` cast of in een 32-bits container stopt, gedraagt
zich vóór en na 2024 verschillend. Dit staat niet in de migratie-cheatsheet in
`sci-bim-context` (`references/technische-issues.md` §A).

Bron: [BuiltInParameter Enumeration, 2024](https://www.revitapidocs.com/2024/fb011c91-be7e-f737-28c7-3f1e1917a0e0.htm).
Pagina niet opgehaald.

**Bijvangst die de skill bevestigt:** dezelfde GUID
`fb011c91-be7e-f737-28c7-3f1e1917a0e0` levert de enum-pagina op voor 2017.1, 2024
én 2026. Dat is de GUID-truc uit `revit-api-docs` §3, hier onafhankelijk
waargenomen.

---

## 5. Score van de dump

Bijgewerkt na de live-meting van 2026-08-28. Kolom "naam" = bestaat het enum-lid;
kolom "beschrijving" = klopt wat de dump erover zei.

| Parameter | Naam (live 2025) | Beschrijving |
|---|---|---|
| `REBAR_ELEM_LAYOUT_RULE` | bevestigd | te dun — het is een integer, geen tekst |
| `REBAR_ELEM_BAR_SPACING` | bevestigd | valkuil ontbreekt — leeg bij Fixed number |
| `REBAR_ELEM_QUANTITY_OF_BARS` | bevestigd | in orde |
| `REBAR_ELEM_TOTAL_LENGTH` | bevestigd | in orde |
| `CLEAR_COVER` | bevestigd | **fout** — geldt alleen voor in-place families en trappen |
| `REBAR_ELEM_HOST_MARK` | bevestigd | in orde |
| `REBAR_NUMBER` | bevestigd | in orde |
| `REBAR_SHAPE_IMAGE` | bevestigd | in orde — de eerdere twijfel was onterecht |

**Alle acht namen bestaan** in Revit 2025. De dump had de namen dus goed; de
zwakte zat in de beschrijvingen: `CLEAR_COVER` is verkeerd omschreven, en bij
`REBAR_ELEM_LAYOUT_RULE`/`REBAR_ELEM_BAR_SPACING` ontbreken de valkuilen. De les
verschuift daarmee: een gecureerde samenvatting is bruikbaar als startpunt, en de
namen kon je hier definitief live toetsen — de betekenis niet. Die blijft
documentatie- of modelwerk.

---

## 6. Openstaand

Het bestáán van de acht namen is afgehandeld (§0, live-meting Revit 2025). Wat nog
open is:

- **Semantiek.** `Enum.IsDefined` toetst geen betekenis. De beschrijvingen van
  `REBAR_ELEM_LAYOUT_RULE` (integer, geen tekst) en `REBAR_ELEM_BAR_SPACING` (leeg
  bij Fixed number) leunen op één forumfragment; de scope-correctie van
  `CLEAR_COVER` op Autodesk-docs die niet zijn opgehaald. Die drie zijn het
  narekenen waard tegen een echte doc-pagina of een testmodel.
- **2024 en 2027.** Gemeten is alleen 2025. Voor deze langbestaande enum-leden is
  verschil onwaarschijnlijk, maar strikt genomen niet uitgesloten — met een
  draaiende 2024 of 2027 is dezelfde `Enum.IsDefined`-check in seconden gedaan.
