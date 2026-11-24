---
titel: Staallijsten tweede ronde — rekentool, lookups en de ChatGPT-controle getoetst
datum: 2026-11-18
vraag: "Tweede ronde staallijst vergelijken: rekentool en lookuptabellen controleren en aanpassen, en de map Controle ChatGPT gebruiken om te toetsen. Blijf kritisch."
bronnen:
  - "W:\\4 - Tijdelijk en verwijderen\\AWO\\Werkmap\\Reken tool\\Ontwerptools.html (1245 profielen, gelezen 2026-11-18)"
  - "W:\\4 - Tijdelijk en verwijderen\\AWO\\Werkmap\\Lookuptabels\\ (alle CSV's)"
  - "W:\\4 - Tijdelijk en verwijderen\\AWO\\Werkmap\\Controle ChatGPT\\diepgaande_controle_staalprofielen.xlsx"
  - "W:\\4 - Tijdelijk en verwijderen\\AWO\\Werkmap\\Bronnen\\SCI_profielendatabase v2022-10.xlsx"
  - https://staaltabellen.nl/ (PDF's 042-054, 062, 065, 080-096)
  - https://orangebook.arcelormittal.com/node/16 (HE A), /node/6 (IPE), /node/253 (UPE)
verwant:
  - outputs/2026-11-05-ontwerptools-staaltabellen-controle.md
---

# Staallijsten tweede ronde — rekentool, lookups en ChatGPT-toets

## Conclusie

- **ChatGPT meldde 785 afwijkingen. Daarvan zijn er 0 terecht als fout in onze
  bestanden.** De meldingen zijn verschillen tussen bronnen, mappingfouten van
  ChatGPT zelf, of fouten in de referentie.
- **Wel gevonden:**
  - de INP-reeks in de rekentool heeft afgeronde t_f/t_w en een te hoge O;
  - in de lookup Koker_SH hebben twee warmgevormde kokers een A en G zonder
    hoekafrondingen.

  Beide zijn gecorrigeerd in de werkkopie. ChatGPT zag ze geen van beide.
- **Live gezet op 18-11-2026, in opdracht van Albert:**
  - **Rekentool:** in `W:\7 - Software\Ontwerptools` is alleen de profiellijst
    gewijzigd. De live versie was byte-gelijk aan de werkkopie van vóór
    vandaag, en de code buiten het JSON-blok is ongewijzigd.
  - **Back-up:** in de live map van de rekentool staat
    `_backup 2026-11-18 voor update`.
- **Revit-lookups: alleen in de werkmap aangepast.** Albert geeft ze door aan
  de beheerder van `03. Support\Lookup tables`.
  - Die map is niet van ons. Een kortstondige vervanging daar is op
    18-11-2026 teruggedraaid: byte-gelijk hersteld en de eigen backupmap
    weggehaald.
  - De live map heeft nog de versies van vóór 11-11. Daarin zitten de fouten
    die de werkmapversies oplossen: bij 119 rijen in Koker.csv past de
    oppervlakte niet bij de geometrie, en de hoeklijnstralen en G/AL in
    Koker_SH kloppen niet.
  - Over te dragen: Koker.csv, Koker_SH.csv, Hoeklijn.csv, Hoeklijn.xlsx en
    THQ.csv, met de wijzigingslogs van 11-11 en 18-11 uit de werkmap.
  - Families die al geladen zijn, houden hun ingebedde tabel tot die opnieuw
    is geïmporteerd (Manage Lookup Tables) en de familie is herladen.

## ChatGPT-bevindingen, per groep beoordeeld

| Groep | Aantal | Oordeel | Bewijs |
|---|---|---|---|
| HTML I_T van HEA/IPE wijkt af van SCI | 11 | **Bronverschil** | De tool is gelijk aan het Orange Book (HE 300 A: 87,8; IPE 80: 0,67), nagelopen voor alle 42 HEA- en IPE-profielen. De SCI-database van 2022 gebruikt oudere waarden. |
| Koker_SH h/b omgedraaid | 211 + 211 | **Onterecht** | Koker_SH bevat elke rechthoekige koker bewust twee keer, staand en liggend, onder dezelfde naam. |
| Koker_SH A, ri, ro tegen "Kokers koud" | 76 + 94 + 56 | **Onterecht** | Koker_SH is gemengd: `nummer` 1 = warmgevormd (ro = 1,5t), 2 = koudgevormd (ro = 2t). ChatGPT vergeleek ook de warmgevormde rijen met de koude tabel. |
| Koker.csv ri/ro tegen SCI | 49 + 51 | **SCI-database fout** | De lookups volgen EN 10219-2/10210-2 en reproduceren daarmee A exact. Met de SCI-stralen wijkt A 1–3% af van SCI's eigen A. |
| UPE tf en r | 14 + 12 | **Mappingfout ChatGPT** | ChatGPT schoof de kolommen één plek op: het las "Ligger nummer" (1) als tf. De UPE-lookup is gelijk aan SCI én aan het Orange Book (UPE 80: tw 4,0, tf 7,0, r 10). |

Eén toelichting in ChatGPT's samenvatting klopt ook niet. Er staat dat "G8
theoretische massa" is. In de SCI-database is G = A × 7850 (theoretisch) en
G8 = A × 8000 (handelsgewicht).

## Eigen controle

### Rekentool (1245 profielen)

- **Vergeleken met:** de SCI-database en staaltabellen.nl. Velden: h, b, t_w,
  t_f, A, massa, O, I, W_el, W_pl en I_T.
- **SHS(KW) I_T:** 72× 1–4% lager dan SCI. De tool volgt SCI P363 en de
  EN 10210-2-formule: 40×40×4 nagerekend = 19,5 cm⁴ en 60×60×8 = 118,2 cm⁴,
  allebei gelijk aan de tool. Geen fout.
- **INP (bron Bouwen met Staal / SCI-database) — gecorrigeerd:**
  - t_w en t_f zijn in de bron afgerond, bijvoorbeeld INP 300 t_w = 11 terwijl
    r₁ = 10,8. Bij DIN 1025-1 geldt r₁ = t_w.
  - Staaltabellen.nl geeft de DIN-waarden. Een oppervlaktecontrole bevestigt
    ze: met de DIN-waarden wijkt A gelijkmatig af (+1,5 ±0,1%, de fout van de
    benaderingsformule), met de toolwaarden springt het van −0,7 tot +2,8%.
  - t_f/t_w zijn aangepast voor INP 180–400, en h_i/h₁ zijn opnieuw afgeleid.
    Die tellen mee in de doorsnedeklasse en Av.
- **INP O — gecorrigeerd:** de oude waarde was berekend alsof de flenzen
  evenwijdig zijn en lag ~3% te hoog. INP 80–400 nu op de DIN-waarde. Voor
  INP 450–600 is O **geschat** (× 0,9726, de verhouding bij 300–400); daarvoor
  is geen bronwaarde gevonden.

### Lookuptabellen

**Wat getoetst is:**
- Kokers: A, ri, ro en G tegen SCI, staaltabellen.nl en de HTML. Daarnaast een
  geometrische toets: A = 2t(h+b−2t) − (4−π)(ro²−ri²).
- Hoeklijnen: r en r₁ tegen SCI, en A uit de geometrie tegen SCI en
  staaltabellen.nl.
- HE/IPE/UNP/UPE: tegen SCI, staaltabellen.nl en de HTML.
- HE-T en raatligger: tegen het moederprofiel.

**Uitkomst:**
- Alles klopt, op twee rijen na. In **Koker_SH K70×70×10 en K80×80×10** is A
  berekend zonder hoekafrondingen: 2400 en 2800, volgens h² − (h−2t)².
  - Gecorrigeerd naar 2293 (EN 10210-2, ro = 15, ri = 10; geen catalogusbron
    gevonden) en 2690 (SCI P363).
  - G is meegecorrigeerd. AL van 70×70×10 staat nu op 0,2542.
  - Op 11-11 was bij K70×70×10 alleen de factor 10 hersteld (24000 → 2400).
- **Niet getoetst:** HD.CSV en THQ.csv, omdat er geen referentie voor is.

## Fouten in de referenties zelf

- **staaltabellen.nl, UPE-tabel:** wijkt systematisch af van ArcelorMittal
  (UPE 80 t_f 8 tegen 7, t_w 4,5 tegen 4,0).
- **staaltabellen.nl, overig:** HEM-rechternummers 330/460 bij HEM 340/360, en
  bij L30×30×5 staat I = 1,40 (lager dan bij L30×30×4).
- **SCI-database 2022-10:** de hoekstralen r1/r2 van kokers passen niet bij de
  eigen A. De INP-t_w/t_f zijn afgerond.

## Wijzigingen en back-ups

- **Back-ups:**
  - `Reken tool\_backup 2026-11-18 voor update\Ontwerptools.html`
  - `Lookuptabels\_backup 2026-11-18 voor update\Koker_SH.csv`
- **Wijzigingslog:** `wijzigingen 2026-11-18.csv` in beide backupmappen,
  68 regels met de oude en nieuwe waarde en de reden.
- **Verificatie:**
  - In de HTML is alleen het JSON-blok veranderd: 63 velden, allemaal INP.
  - De tool laadt zonder consolefouten.
  - Av voor INP 300 = 3374,9 mm², handmatig nagerekend.
- **Changelog:** twee regels toegevoegd aan
  `AI-Engineer\Changelogs\Reken tools\Reken-tools-changelog.csv`.
