# Breedtetoets van de lezers op de projectschijf, viewer 3.46 t/m 3.48

Datum: 13-11-2026. Vervolg op `2026-11-13-scia-analyse-p-schijf-en-viewer-3.44.md` en
`2026-11-13-technosoft-analyse-p-schijf-en-viewer-3.45.md`. Vraag van de gebruiker: "Ga verder, haal eventueel nieuwe bestanden op en
analyseer".

## Aanpak
Ronde 1 toetste de lezers op een handvol kopieën. Ronde 2 draaide de lezers (uit de viewer geknipt, in Node via VS Code
`ELECTRON_RUN_AS_NODE=1 Code.exe`) rechtstreeks op grote steekproeven vanaf P: (alleen lezen). Van elke gevonden oorzaak staan één of
twee voorbeelden in `Documents\Technosoft-analyse\ronde2` en `Documents\SCIA-analyse\ronde2`, met `BRON.txt`.

Bron die ronde 1 miste: de Technosoft-handboeken staan lokaal als PDF onder `C:\Program Files (x86)\Technosoft Structural Analysis\`.
Daarin staan de codes (lasttypen, combinatiesoorten); dat het bestand dezelfde codes gebruikt blijkt uit de namen van de
belastinggevallen.

## Uitkomst (fout = de lezer gooit een fout of opent niet)

| Soort | Getoetst | Fout vóór | Fout na | Belangrijkste stille fout |
|---|---|---|---|---|
| Raamwerken | 404 | 1 | 1 (geen Raamwerken-bestand) | belastinggevallen weg in 45 bestanden; lasttypen 3.45 deels verkeerd geduid (226 sommen veranderen); staalvelden ontbraken in 185 |
| Balkroosters | 152 | 15 | 2 | t/m 6.71 en 6.84 andere recordlengtes |
| Liggers | 200 + alle 590 oude | 53 | 0 (3.47) | oud formaat TS-DLG-WIN (397 op P:) en WIN2 (193) |
| Construct | 302 | 137 | 0 | gording: h.o.h. gelezen als overspanning bij 124 van 160 (recordblok 952/960 i.p.v. 968); klimaatklasse |
| Kolommen (.klw) | 206 | opende niet | 0 | binair `twkol`, 9 van 10; getoetst tegen 49 rapporten |
| Paaldraagvermogen | 481 | 19 | 8 (ouder dan 0x0369) | berekening verkeerd ontleed in 39 |
| Funderingen op staal | 187 | 2 | 0 | |
| Damwanden | 23 | 2 | 0 | profiel, bouwfasen, ankers nu gelezen |
| SCIA | 206 | 1 | 1 (geen model) | lokale lijnlasten en lasten op interne randen weggegooid in 50; staven uit IFC/Revit zonder profiel; namen buiten ASCII |

## 3.48: SCIA-lasten in het lokale assenstelsel van een staaf
Omgerekend met de assen die de viewer ook voor het profielsymbool gebruikt (x langs de staaf, z in het verticale vlak omhoog,
y = z × x, staand y = globaal Y, daarna de draaihoek). Het teken is hard: in 8328 heten de gevallen "Wind opwaarts" en "Wind
neerwaarts" en die komen nu op +83,5 en −41,7 kN (eerst beide 0).

## Les
Een handvol bestanden is te weinig. Recordlengtes verschillen per programmaversie en dat geeft vooral **stille** fouten: het bestand
opent, maar een getal staat op de plaats van een ander. Toets daarom op een steekproef gespreid over jaren (versies) en vergelijk
waar mogelijk met het rapport (.rtf) dat naast het bestand staat.

## Open (ronde 3 loopt)
- SCIA: vlaklasten in het lokale assenstelsel van een plaat, lijnlasten op een plaatrand, vrije lasten en momenten (niet in de som).
- Oud Raamwerken BIN 3.73 (17 van 404) en Paaldraagvermogen ouder dan 0x0369 (8 van 481).
- Damwand: ankertype onbekend; de richting van het anker in de tekening is een aanname.
- Balkroosters: momenten (lasttype 9 en 12) en scharnierende einden zitten niet in de eigen roosterberekening.
