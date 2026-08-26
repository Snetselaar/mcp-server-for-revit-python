---
titel: BuiltInParameters voor wapening — wat er klopt van de dump
status: concept
laatst-bijgewerkt: 2026-08-26
bronnen:
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

## 3. Niet bevestigd

### `REBAR_ELEM_HOST_MARK` en `REBAR_NUMBER`

De **parameters** bestaan: "Host Mark" en "Rebar Number" zijn bekende
wapeningsparameters, en de combinatie van die twee vormt het unieke staafmerk.
Vóór Revit 2015 ging dat via een handmatige parameter "Schedule Mark".

Maar de **exacte enum-spelling** is nergens teruggevonden. `REBAR_NUMBER` is
opvallend kort naast de `REBAR_ELEM_`-reeks; dat kan kloppen, maar het is niet
vastgesteld.

[ONBEVESTIGD] `REBAR_ELEM_HOST_MARK` en `REBAR_NUMBER` als exacte
`BuiltInParameter`-namen. Alleen de dump zegt dit.

Bron voor het bestaan van de parameters:
[Modelling Reinforcement in Revit](https://www.symetri.co.uk/insights/blog/modelling-reinforcement-in-revit-tips-and-tricks/).

### `REBAR_SHAPE_IMAGE` — hier klopt vermoedelijk iets niet

De dump zet `REBAR_SHAPE_IMAGE` neer als BuiltInParameter voor "de afbeelding van
de buigvorm die in uittrekstaten getoond kan worden". Meerdere onafhankelijke
bronnen beschrijven "Shape Image" echter als een parameter die **de gebruiker
zelf toevoegt** in de Family Types-editor van de rebar shape-familie, omdat de
standaard Rebar Shapes die afbeelding niet bevatten.

Een parameter die je zelf moet aanmaken is per definitie geen BuiltInParameter.

[ONBEVESTIGD] Dat `REBAR_SHAPE_IMAGE` als `BuiltInParameter` bestaat. Waarschijnlijker
is dat "Shape Image" een familieparameter is.

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

| Parameter | Uitkomst |
|---|---|
| `REBAR_ELEM_LAYOUT_RULE` | bevestigd, beschrijving te dun (het is een integer) |
| `REBAR_ELEM_BAR_SPACING` | bevestigd, valkuil ontbreekt (leeg bij Fixed number) |
| `REBAR_ELEM_QUANTITY_OF_BARS` | naam teruggevonden |
| `REBAR_ELEM_TOTAL_LENGTH` | naam teruggevonden |
| `CLEAR_COVER` | **beschrijving fout** — geldt alleen voor in-place families en trappen |
| `REBAR_ELEM_HOST_MARK` | niet bevestigd |
| `REBAR_NUMBER` | niet bevestigd |
| `REBAR_SHAPE_IMAGE` | **waarschijnlijk geen BuiltInParameter** |

Vier van de acht houden stand, één is aantoonbaar verkeerd omschreven, één is
vermoedelijk onjuist, twee blijven open. Dat is de meetwaarde van dit type
gecureerde samenvatting: bruikbaar als startpunt, onbruikbaar als naslagwerk.
Neem er niets uit over zonder het na te lopen.

---

## 6. Openstaand

Deze tabel opnieuw langslopen vanuit een omgeving waar `revitapidocs.com`
bereikbaar is — in de praktijk een lokale sessie op de werkplek. Per parameter de
enum-pagina openen en de GUID-truc toepassen op **2024 en 2027**, zoals
`revit-api-docs` §1 voorschrijft. Pas daarna mag hier het kopje *Geverifieerd*
boven.
