---
titel: 3D-wapening modelleren in Revit
status: concept
laatst-bijgewerkt: 2026-08-26
bronnen:
  - "raw/2026-08-25 samenvatting-bronnen.md §1.1 t/m §1.6"
  - "raw/2026-08-25-samenvatting-revit-structure-rebar.md §1.A en §1.B"
verwant:
  - rebar-documentatie-en-staten.md
  - rebar-api-parameters.md
  - revit-robot-interoperabiliteit.md
skill: sci-bim-context
---

# 3D-wapening modelleren in Revit

De werkwijze voor het modelleren van betonwapening: instellingen, kolommen,
balken, vloeren en vrije vormen. Documentatie, tags en buigstaten staan apart in
`rebar-documentatie-en-staten.md`.

**Beide bronnen zijn gecureerde samenvattingen** met verwijzingen naar
onderliggende documenten die wij niet hebben. Alles hieronder is dus
tweedehands. Waar een claim nergens anders op steunt, staat dat erbij.

---

## 1. Versies — lees dit eerst

SCI moet werken op **Revit 2024 t/m 2027** (`sci-bim-context`, compatibiliteitseis).
De twee dumps spreken elkaar hierover bijna tegen: de ene schrijft functies toe
aan "Revit 2025", de andere aan "sinds Revit 2024". Deze tabel maakt expliciet
wat waar staat.

| Functie | Volgens de bron beschikbaar vanaf | Bruikbaar op 2024? |
|---|---|---|
| `Propagate Rebar` | 2024 (bronnen-dump §1.2) | ja |
| `Varying Rebar Set` met schuinte | 2024 (bronnen-dump §1.6) | ja |
| *Bending Detail* als schedule-veld | 2024 (bronnen-dump §1.7) | ja |
| `Splice Rebar` | 2025 (rebar-dump §1.A) | **nee** |
| Realistic/Schematic Bending Details in 2D-aanzichten | 2025 (rebar-dump §1.C) | **nee** |
| `Rebar Constraint Status` in schedules/filters/tags | 2025 (rebar-dump §1.B) | **nee** |

[ONBEVESTIGD] Deze versiegrenzen komen uitsluitend uit de twee dumps. Geen ervan
is nagelopen tegen release notes of documentatie — dat kon niet, want de
API-bronnen zijn in de schrijfsessie geblokkeerd (zie
`rebar-api-parameters.md` §0).

**Praktisch gevolg:** een script of werkwijze die op `Splice Rebar` leunt, faalt
op 2024. Wie voor het hele bereik bouwt, kan alleen de bovenste drie rijen
gebruiken.

---

## 2. Basisinstellingen

### Rebar Shapes laden

Shapes komen uit de Autodesk-bibliotheek. Twee smaken, en het verschil bijt:

- **US Metric** shapes gebruiken parameternamen in **hoofdletters**.
- **Nederlandse (NLRS)** shapes gebruiken **kleine letters**, en bevatten wél de
  juiste Rebar Bars.

Wie de twee door elkaar gebruikt, krijgt shapes waarvan de parameters niet
aansluiten. Dit raakt direct de NLRS/SCI-naamgeving uit `sci-bim-context` §3.

> **Conflict met skill `sci-bim-context`:** de bronnen-dump §1.1 beveelt sterk aan
> een gespecialiseerde template te gebruiken, met name die van **Cadix**, omdat
> die een correct geconfigureerde set Rebar Shapes, Bars en Hooks bevat. SCI
> werkt met een **eigen template** (`sci-bim-context`,
> `references/template-en-mcp.md` §A), waarin 163 families en ~50 wapeningsvormen
> zitten. Neem de Cadix-aanbeveling dus niet over. Wat er wel uit te halen valt is
> de checklist: bevat onze template een sluitende set shapes, bars én hooks?
> Dat is niet nagegaan.

### Rebar Cover Settings

Via `Structure` > `Reinforcement` > `Rebar Cover Settings`. De dump noemt drie
dekkingstypes:

| Type | Waarde |
|---|---|
| Geen dekking | 0 mm |
| Binnenomgeving | 20 mm |
| Buitenomgeving | 40 mm |

[ONBEVESTIGD] Of dit de SCI-waarden zijn of generieke voorbeelden uit de bron.
Nagaan in de SCI-template.

Dekking geldt **per vlak**, niet per element: toepassen op het hele betononderdeel
of handmatig per face via `Rebar - Cover` op de Options Bar. Dat per-vlak-karakter
verklaart waarom de API er een hele reeks parameters voor heeft en niet één — zie
`rebar-api-parameters.md` §2, waar de dump op precies dit punt de mist in gaat.

---

## 3. Kolomwapening

Werk in een plattegrond met een doorsnede over de kolom, of maak een aparte
`Detailview`.

**Langswapening.** `Structure` > `Reinforcement` > `Rebar`, vorm `M_00`, diameter
via de Type Selector. Plaatsingsrichting is `Perpendicular to Cover` (loodrecht op
de doorsnede) of `Parallel to Work Plane` (evenwijdig eraan). Verdelen via
`Rebar Set`, op vast aantal of op afstand.

Die keuze tussen vast aantal en afstand is dezelfde die in de API terugkomt als
`REBAR_ELEM_LAYOUT_RULE`, en bij een vast aantal is er geen spacing om uit te
lezen — zie `rebar-api-parameters.md` §1.

**Beugels.** Vorm `M_T1`, plaatsing `Parallel to Work Plane`, `Rebar Set` op
`Maximum spacing 300mm`. De dekking wordt automatisch gerespecteerd.

**Zichtbaarheid in 3D.** Wapening is per staaf of selectie zichtbaar te maken via
Properties > `View Visibility States` > `Edit`: kies de 3D-view, vink `View as
solid` en `Unobscured` aan. Zet het detailniveau op **Fine**, anders tonen staven
niet hun werkelijke diameter.

**Uitlijnen.** `Modify` > `Constraints` > `Edit Constraints` koppelt staven aan
betonvlakken of beugels, met exacte offsets.

**Stekeinden.** Verticale staven plaatsen, uitlijnen via `Edit Constraints`, en
onderaan een haak van `90 degrees`. Rotatie en hoeklengte handmatig aanpasbaar met
`Override Hook Lengths`.

**Propagate Rebar** (2024+) kopieert complete kolomwapening naar andere hosts via
`Align By Host` of `Align By Face`. Valkuil uit de bron: zorg dat de constraints
vooraf aan de júiste dekking hangen. Zitten de beugels per ongeluk vast aan de
dekking van een aangrenzende vloer, dan gaat het kopiëren mis.

---

## 4. Balkwapening

Doorsnede over de balk, detailniveau **Fine**.

1. Beugels (`M_T2` of `M_T1`) op de gewenste h.o.h.-afstand. Overbodige beugels
   verwijder je met `Edit Bars` > `Remove Bar` — niet door de set opnieuw op te
   bouwen.
2. Langsstaven (`M_00`), uitgelijnd op de bochten van de beugels met
   `Edit Constraints`, offset 0.
3. **Bijlegwapening** via Sketch Mode: doorsnede in de lengterichting met een kort
   bereik, `Refplanes` op de knikpunten, dan `Rebar` > `Sketch Mode`. Hoeken worden
   automatisch afgerond. Na het schetsen alsnog uitlijnen met `Edit Constraints`.

---

## 5. Vloeren

**Area Reinforcement.** Vloer selecteren in plattegrond, `Structure` >
`Reinforcement` > `Area`, contour schetsen, overspanningsrichting opgeven. In
Properties staan diameters, h.o.h.-afstanden en dekkingen voor boven- én
ondernet.

**Fabric Area** voor geprefabriceerde netten. Sheet-type kiezen; uitsparingen en
schachten worden automatisch gespaard.

**Aanpassen** via `Edit Sketch` (contour) of `Edit Bars` (losse staven
verschuiven of verwijderen).

---

## 6. Vrije vormen

**Free Form Rebar** is uitsluitend *host-driven*: de geometrie komt uit de vorm
van het beton, niet uit een shape-familie.

- **Surface** — 3D-view, `Rebar` > `Free Form` > `Surface`. Host-oppervlak kiezen,
  daarna start- en eindvlak waartussen verdeeld wordt. Verdeling via `Layout` in
  Properties. Geschikt voor dubbelgekromde vlakken zoals hellingbanen.
- **Aligned** — voor beugels in vrije vormen. Vier omhullende vlakken selecteren,
  pad langs een rechte lijn, haken via Properties.
- **Varying Rebar Set** (2024+) laat beugels meelopen met een schuinte in de host.
  Beperking uit de bron: werkt met **maximaal één** schuinte.
- **Hellingbanen** wapen je als balken: Surface in de langsrichting, Aligned voor
  de beugels, per hellingvlak afzonderlijk.

### Shape Driven versus Free Form

| | Shape Driven | Free Form |
|---|---|---|
| Geometrie uit | Rebar Shape Family | de host |
| Plaatsing | `Expand to Host`, `By Two Points`, schetsen | host-vlakken aanwijzen |
| Constraints | automatisch én handmatig t.o.v. dekking | host-gestuurd |

`Rebar Constraint Status` (2025+) toont in schedules, filters en tags of
constraints `All Enabled`, `All Disabled` of `Some Disabled` zijn. Bedoeld om te
betrappen dat de parametrische werking stilletjes stuk is. Niet beschikbaar op
2024.

---

## 7. Splitsen op handelslengte (2025+)

`Splice Rebar` verdeelt lange staven over handelslengtes en genereert ketens die
meebewegen bij geometrische wijzigingen, omdat ze op rebar constraints leunen.

- **By Length** — splitsen op maximale en minimale staaflengte, bijvoorbeeld 12 m.
- **Pick Line** — handmatig splitsen op een kruisende referentielijn of betonvlak.

Koppelingstypes: *Lap Splices*, *Staggered Lap Splices*, *End-to-End Splices*.

Met de parameter `Maximum Bar Length` zijn filters te bouwen die staven boven de
fabricagelimiet visueel markeren.

**Niet beschikbaar op Revit 2024.** Wie het hele bereik moet bedienen, splitst
handmatig of bouwt er geen werkwijze omheen.
