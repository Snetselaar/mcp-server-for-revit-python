# Ender's Game fase 0 — Raamwerken-XML heen en terug (20-11-2026)

Proef voor de staal-roundtrip Revit ⇄ Technosoft. Zie
`wiki/enders-game-roundtrip.md` voor de context.

## Opzet

**Bron:** kopieën van `P:\9000-9999\9200-9249\9204 - IKC Cunera Castricum\1 Ber\DO\Stramien 7.rww`
en `Spanten stramien A.rww`. Er is alleen gelezen van P:. Alle schrijfstappen gebeurden in de
sessie-scratchpad.

**Programma:** Technosoft Raamwerken V6, `twrmw.exe` (ProgramVersion 6.85, FileVersion 6.15),
in `C:\Program Files (x86)\Technosoft Structural Analysis\Raamwerken V6\`.

**Handleiding:** `twrmwtn.pdf` in dezelfde map, p. 385-430 (XML-koppeling en opdrachtregel).

### Stappen

1. `twrmw.exe "Stramien 7.rww" /xml_model "Stramien 7.xml"` → exit 0, binnen enkele seconden,
   zonder dialoog.
2. In de XML drie wijzigingen gedaan:
   - een nieuw profiel `<Section ID="12" Description="K100/100/5CF" MaterialID="2"/>`, met
     alleen omschrijving en materiaal;
   - staaf 13 omgezet van `SectionID="9"` (K90/90/4CF) naar 12;
   - een proefattribuut `Description="revit:123456"` op staaf 1.
3. `twrmw.exe "Stramien 7_patch.xml" /saveas "Stramien 7_ender.rww"` → exit 0, zonder dialoog.
   De export zet zelf `TemplateFileName` (naar de bron-rww) en `XMLReadCode="Replace"` in
   `<BasicData>`.
4. Het resultaat opnieuw geëxporteerd en per XML-groep vergeleken met de oorspronkelijke export.
5. Nulmeting: de **ongewijzigde** export op dezelfde manier heen en terug gehaald.

## Uitkomst

| Wat | Resultaat |
|---|---|
| Profielwissel per staaf | **Werkt.** Staaf 13 heeft SectionID 12. |
| Nieuw profiel met alleen omschrijving + MaterialID | **Werkt.** Hoogte, breedte, A, I, wanddikte enzovoort komen uit de profieldatabase (A = 0,001836 m²). |
| Belastinggevallen, staaflasten, knooplasten, combinaties | Ongewijzigd. |
| Staalelementen, kip, steunen, doorbuigingslimieten | Ongewijzigd. Bij de kniklengte alleen afronding: 5.6 werd 5.600001. |
| Tekstveld op een staaf (`Bar/@Description`) | **Gaat verloren.** De groep Bars kent alleen ID, StartNodeID, EndNodeID, SectionID en ConnectionCodeStart/End (handleiding p. ~397). |
| **Belastinggenerator** | **Gaat uit en zijn parameters verdwijnen** (wind, sneeuw, veranderlijk). `LoadGeneratorStatus` On → Off. Bij de nulmeting gebeurt dit ook, dus het komt door het heen en weer gaan via XML zelf, niet door de wijziging. |

## Gevolgen voor het plan

1. **Het Revit-id kan niet in de .rww zelf.** Terugval: een koppeltabel naast de rww, met per
   TS-staafnummer het Revit-id. Wijzigt de constructeur de staafnummering, dan opnieuw koppelen
   op geometrie: de knoopcoördinaten blijven behouden.
2. **De XML-route voor een bestaande rww is niet verliesvrij.** Bij projecten waar de
   belastinggenerator aan staat, gooit hij de generatorinstellingen weg. Opties:
   - a. Technosoft vragen of de generator via XML mee kan;
   - b. de profielwissel binair in de .rww patchen. De viewer kent het formaat: staafrecord
     0x2c heeft het profiel als u16 @4, profielrecord 0x2e. Nieuwe profielrecords haal je uit
     een tijdelijk XML-bestand;
   - c. de XML alleen gebruiken voor een nieuw stramien (Revit → TS), en voor wijzigingen in
     een bestaande rww de constructeur het profiel zelf laten zetten op basis van de lijst uit
     de viewer.
3. **De opdrachtregel draait zonder dialoog.** Anders dan Balkroosters `/xml_concrete` eerder:
   memory `wapening-technosoft-naar-revit`.

Niet getoetst: `Spanten stramien A.rww` (wel gekopieerd), of de viewer `Stramien 7_ender.rww`
goed leest, en het openen in de Technosoft-GUI.

## Vervolg: binair patchen van de .rww (zelfde dag)

Opzet: de bytes van de kopie van `Stramien 7.rww` direct aanpassen. Elke proef daarna laten
exporteren met `/xml_model` en vergelijken met de oorspronkelijke export. Hulpscript
`rwwrec.py` in de scratchpad loopt de recordketen `[type u8][lengte u16][data]` af vanaf
byte 0. De keten loopt tot ±61 kB, daarna volgt een staart van ±14 kB in een ander formaat.

| Proef | Wijziging | Uitkomst |
|---|---|---|
| P1 | staaf 13 (13e 0x2c-record) u16 @4: profiel 9 → 5, een **bestaand** profiel | **verliesvrij**: alleen Bar 13 SectionID 5 wijzigt, generator blijft **On** met alle parameters |
| T2/T3 | **nieuw** profiel: 0x2e-record (842 B) achter het laatste 0x2e, 0x3e-record (20 B) achter het laatste 0x3e, beide overgenomen uit de XML-versie | laadt; Section 12 K100/100/5CF staat erin, generator On |
| P2/T5 | T3 plus staaf 13 → profiel 12 | `/xml_model` maakt geen XML: één keer exit 0 zonder bestand, één keer na 45 s nog bezig (afgebroken). Vermoedelijk een dialoog |
| T6 | T5 plus byte 0 van record 0x0f van 0 naar 3 (de waarde die de XML-bestanden hebben) | laadt, maar de generator staat **Off**: die byte is de generatorstatus |
| P3 | knoop 16 Z 4,0 → 4,25 (0x2b f64 @18) | laadt, de knoop is verplaatst, maar **de generator staat Off en de windparameters zijn weg** |
| T1/T4 | de staart afgeknipt | crash (exit 0xC0000409). De staart is nodig |

Conclusie:
- Een staaf binair omzetten naar een **bestaand** profiel is verliesvrij.
- Bij elke wijziging van de geometrie zet Technosoft zelf de belastinggenerator uit, of de
  wijziging nu via XML of binair gaat. Een nieuw profiel op een staaf loopt vast.

[ONBEVESTIGD] Het lijkt erop dat de generator ongeldig wordt zodra het model niet meer past bij
de gegenereerde lasten. In de GUI is nog niet bekeken wat Technosoft dan meldt.
