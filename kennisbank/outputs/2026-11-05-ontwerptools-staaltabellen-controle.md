---
titel: Controle staaltabellen Ontwerptools tegen staaltabellen.nl
datum: 2026-11-05
vraag: "Loop de staallijsten/-tabellen in Ontwerptools.html na tegen de tabellen op staaltabellen.nl"
bronnen:
  - "W:\\7 - Software\\Ontwerptools\\Ontwerptools.html (blok id=\"profile-data\", 945 profielen, gelezen 2026-11-05)"
  - https://staaltabellen.nl/balkstaal (PDF's 042, 044, 046, 050)
  - https://staaltabellen.nl/buizen (PDF's 080, 084, 087, 091, 096)
  - https://staaltabellen.nl/images/stories/pdf/symbolen.pdf (betekenis G8)
verwant:
  - outputs/2026-10-12-stappenplan-staalgewicht-ifc.md
---

# Controle staaltabellen Ontwerptools tegen staaltabellen.nl

## Conclusie

De profieldata in Ontwerptools.html klopt met staaltabellen.nl. Er is geen
waarde gevonden die gecorrigeerd moet worden. Het enige structurele verschil
is de massa van I- en H-profielen, en dat is een verschil in definitie.

## Wat is vergeleken

- **Tool:** het JSON-blok `profile-data` in Ontwerptools.html, met 945 profielen:
  - HEA, HEB, HEM en IPE uit het ArcelorMittal Orange Book (HEA 320 uit de
    verkoopcatalogus 2024);
  - CHS, SHS en RHS, koudgevormd (KK) en warmgevormd (KW), uit SCI P363.
- **Site:** de PDF-tabellen op staaltabellen.nl:
  - HEA, HEB, HEM en IPE;
  - buizen: rond (gelast = KK, naadloos = KW), vierkant (KK en KW) en
    rechthoekig (KK en KW).
- **Velden:** h, b, t_w, t_f, massa, A, O, I_y, W_el,y, I_z en W_el,z.
  Bij vierkante en ronde buizen is de I_z en W_el,z van de tool getoetst
  tegen de enkele waarde I_y = I_z op de site.
- **Match:** 454 profielen komen in beide bronnen voor (HEA/HEB/HEM 24 elk,
  IPE 18, SHS KW 86, RHS KW 82, RHS KK 79, SHS KK 62, CHS KW 38, CHS KK 17).

## Uitkomst per grootheid

| Grootheid | Grootste afwijking | Oorzaak |
|---|---|---|
| h, b, t_w, t_f, A, O, I, W_el | 0,62 % | afronding |
| Massa IPE/HE | site 1,4 tot 2,6 % hoger | andere definitie (G8) |
| Massa buizen | 0,1 kg/m bij 2 profielen | afronding |

- **Afronding:** de tool rondt af op 3 significante cijfers (A van HEA 400 =
  15900 tegen 15989 mm²). W_el berekent de tool uit I/(h/2) (HEA 100: 72,7
  tegen 72,8 cm³).
- **Massa IPE/HE:** de site gebruikt kolom "G8", volgens `symbolen.pdf` het
  *handelsgewicht*. Dat komt neer op ρ ≈ 8000 kg/m³: 2124 mm² × 8,0 =
  17,0 kg/m bij HEA 100. De tool gebruikt de theoretische massa uit het
  Orange Book met ρ = 7850 (16,7 kg/m). Dezelfde 8000 kg/m³ zit in de
  gewichtsformule van onze Revit-staat, zie
  `outputs/2026-10-12-stappenplan-staalgewicht-ifc.md`.
- **Massa buizen:** CHS KW 323,9×16 (122,0 tegen 121,0 kg/m) en RHS KW
  260×140×12,5 (72,4 tegen 72,3 kg/m).

## Wat de controle niet dekt

- **491 profielen staan alleen in de tool.** Vooral kleine buizen (CHS onder
  114,3 mm) en tussendiktes zoals 3,0, 3,2 en 3,6 mm. De ronde-buistabellen
  op de site beginnen bij 114,3 mm. Lagere paginanummers staan niet als PDF
  online, en ook pagina's 88-89 niet.
- **202 maten staan alleen op de site.** Voorbeelden: CHS 121, 127, 133 en
  159; RHS 140×70 en 220×120; SHS 110 en 220. Die ontbreken in de tool, omdat
  SCI P363 de Britse reeks volgt.
- **Niet vergeleken:** W_pl, i en I_T staan niet op staaltabellen.nl.
- **Wel gezien, niet uitgezocht:** HEA 320 komt uit een andere bron dan de
  rest van de HEA-reeks. De waarden kloppen.

## Fout in de bron zelf

In de HEM-tabel op staaltabellen.nl (PDF 046) staat in de rechter
profielnummerkolom "330" bij HEM 340 en "460" bij HEM 360. De waarden in de
rij horen wel bij 340 en 360: ze matchen de tool op het linker nummer.

## Werkwijze

- De PDF's zijn met `pdftotext -table` omgezet. De `-layout`-modus verschoof
  de kolommen.
- Daarna is per profielnaam gematcht: beide bronnen genormaliseerd naar
  "reeks(KK/KW) h×b×t".
- Afwijkingen boven 0,2 % zijn handmatig nagelopen.
- PDF's 087 en 091 overlappen. De dubbele regels zijn identiek.
- De scripts stonden in de sessie-scratchpad en zijn niet bewaard.
