---
titel: Stappenplan — staalgewicht in de IFC-export
datum: 2026-10-12
vraag: "Stappenplan om onze staalprofielen zo te maken dat het gewicht in de IFC komt"
bronnen:
  - wiki/ifc-export-staalgewicht.md
  - "W:\\1 - Informatie Snetselaar\\Constructief tekenen\\Revit\\03. Support\\ExportMappings\\RSF_NLRS_3.0.1_CustomPSets.txt (regels 588-589, 1444-1446)"
  - "W:\\1 - Informatie Snetselaar\\Constructief tekenen\\Revit\\03. Support\\Shared Parameters\\ (alle .txt, gelezen 2026-10-12)"
  - "W:\\1 - Informatie Snetselaar\\Constructief tekenen\\Revit\\03. Support\\Lookup tables\\ (kopregels, gelezen 2026-10-12)"
---

# Stappenplan — staalgewicht in de IFC-export

## Waarom het nu niet werkt (samenvatting)

Zie `wiki/ifc-export-staalgewicht.md`. Kort: het gewicht bestaat alleen als
formuleveld in de staat (volume × 8000 kg/m³). Geen element-parameter draagt
het, en de IFC neemt alleen element-parameters mee.

## Wat er al klaarligt (gemeten 2026-10-12)

- **De export-mapping verwacht het al.** `RSF_NLRS_3.0.1_CustomPSets.txt`
  mapt in property set `NLRS_Prestatie`:
  `Gewicht` ← `NLRS_S_gewicht` (r. 1444),
  `Gewicht Per M` ← `NLRS_S_gewicht per m` (r. 1445),
  `Soortelijk Gewicht` ← `NLRS_S_soortelijk gewicht` (r. 1446).
  In `NLRS_Geometrie` ook `NLRS_S_gewicht_bruto` / `_netto` (r. 588-589).
- **De parameters bestaan nergens.** Geen van de shared-parameterbestanden in
  `03. Support\Shared Parameters` bevat `NLRS_S_gewicht`; die bestanden zijn
  NLRS 2.5.2, de mapping is 3.0.1.
- **Kg/m staat maar in twee lookup tables.** `Koker.csv` en `Koker_SH.csv`
  hebben een kolom `G`. HEA, HEB, HEM, IPE, HD, UNP, UPE, Hoeklijn, THQ en de
  T-varianten hebben geen gewichtskolom (wel maten).

Daarmee is de route vrijwel gegeven: **de parameters maken die de mapping al
verwacht, en ze vullen.** Aan de exportinstellingen hoeft dan niets.

## Stap 0 — Beslissingen vooraf (BIM-coördinator)

1. **Dichtheid: 7850 of 8000 kg/m³?** De staat rekent nu met 8000.
   [ONBEVESTIGD] 7850 is de waarde uit NEN-EN 1993-1-1 §3.2.6 (niet nagelezen).
   Kies één waarde voor families én staten, anders verschillen IFC en stuklijst.
2. **Netto of tabelgewicht?** Tabel-kg/m (uit de profieltabel, inclusief
   afrondingsstralen) of A × ρ uit de lookup-maten. Advies: tabelwaarde, dat is
   wat een staalbouwer verwacht.
3. **Welke lengte?** Systeemlengte of zaaglengte (`Cut Length`). Advies:
   zaaglengte, die sluit aan bij de staat (die rekent op volume).

## Stap 1 — Shared parameters aanmaken

In een nieuw bestand of in `SCI_Shared Parameters.txt`, groep bv. `NLRS_Staal`:

| Naam (exact, met spatie) | Type | Discipline | Op |
|---|---|---|---|
| `NLRS_S_gewicht per m` | Mass per Unit Length | Structural | type |
| `NLRS_S_gewicht` | Mass | Structural | instance |

De naam moet letterlijk gelijk zijn aan de CustomPSets-regel; de exporter zoekt
op naam. [ONBEVESTIGD] dat de exporter bij user defined property sets op naam
en niet op GUID zoekt — stap 5 toetst dat.

Optioneel `NLRS_S_soortelijk gewicht` (type, Mass Density) als je de dichtheid
ook wilt meegeven.

## Stap 2 — Lookup tables aanvullen met kg/m

Per profieltabel (HEA, HEB, HEM, IPE, HD, UNP, UPE, Hoeklijn, THQ, T-varianten,
raatligger) een kolom toevoegen:

```
Gewicht_per_m##mass_per_unit_length##kilograms_per_meter
```

[ONBEVESTIGD] de exacte unit-tokens voor massa per lengte in een lookup-kop;
controleer in Revit (Manage Lookup Tables → Export) hoe Revit de kop schrijft
en neem die over. `Koker.csv` heeft al `G##number##general`; daar kan de
formule die kolom gebruiken.

Waarden uit een profielentabel (staalengineers / fabrikant), niet uitrekenen.
Backup van elke csv vóór de wijziging, in `Lookup tables\Backup`.

## Stap 3 — Families aanpassen (één familie eerst)

Begin met `NLRS_28_SF_LIB_balk HE_gen_SCI`:

1. Shared parameter `NLRS_S_gewicht per m` toevoegen als **type**, formule:
   `size_lookup(Lookup Table Name, "Gewicht_per_m", 0 kg/m, Type ligger)`
   (zelfde opbouw als de bestaande lookups voor `Breedte`/`tf`).
2. Zelfde regel voor de Revit-eigen `Nominal Weight` als die parameter in de
   familie bestaat — dan klopt ook Revit's eigen `Weight` weer.
   [ONBEVESTIGD] dat `Weight` = `Nominal Weight` × lengte.
3. Shared parameter `NLRS_S_gewicht` toevoegen als **instance**. Probeer de
   formule `NLRS_S_gewicht per m * Cut Length`.
   [ONBEVESTIGD] dat de familie-editor `Cut Length` in een formule accepteert;
   bij structural framing kan dat geblokkeerd zijn. Lukt het niet: parameter
   leeg laten en vullen in stap 4.

Daarna dezelfde ingreep in de kolomfamilie `NLRS_28_SCO_TLB_kolom HE_gen_SCI`
en pas dan de rest van de bibliotheek.

## Stap 4 — Alleen als de formule uit 3.3 niet werkt: vullen met een knop

Een pyRevit-knop (03_R&D, later in de IFC-exportknop als voorstap):
`NLRS_S_gewicht = NLRS_S_gewicht per m × Cut Length` voor alle structural
framing en structural columns. Nadeel: het gewicht klopt alleen direct na het
draaien; een verlengde ligger loopt achter tot de volgende run. Daarom het
liefst in de exportknop zelf, net vóór de export.

## Stap 5 — Proefexport en controle

1. Testmodel (niet een productiemodel), aangepaste familie inladen, een paar
   liggers/kolommen plaatsen.
2. Exporteren met de bestaande setup (user defined property sets moet aan staan,
   met `RSF_NLRS_3.0.1_CustomPSets.txt`).
3. In BIMcollab: `NLRS_Prestatie → Gewicht` en `Gewicht Per M` gevuld?
   Waarde narekenen tegen de staat (verschil = 8000 vs 7850 en volume vs tabel).
4. Klopt het niet: de .ifc in een teksteditor openen en zoeken op
   `NLRS_S_gewicht` / `Gewicht` om te zien of de property er wel in staat.

## Stap 6 — Uitrol

1. Alle staalfamilies (NLRS_28 liggers, kolommen, kokers, hoeklijnen, UNP's,
   strips) dezelfde ingreep geven; de strip (`wvb strip`) apart bekijken, die
   heeft geen lookup table.
2. De SCI-template bijwerken met de nieuwe families.
3. Lopende projecten: families herladen (Overwrite parameter values). Typenamen
   blijven gelijk, dus plaatsing blijft intact.
4. De staat `SCI stalen liggers` / `kolommen` laten rekenen met
   `NLRS_S_gewicht` in plaats van de formule, zodat staat en IFC hetzelfde zeggen.

## Tussendoor de snelle test (geen familiewerk)

Wil je eerst weten of het zonder familiewerk kan: dupliceer de staat
`SCI stalen liggers`, zet "Pset_" in de titel en exporteer. Gaat de berekende
kolom mee, dan is er een noodroute. [ONBEVESTIGD] — waarschijnlijk niet, de
exporter leest velden met een parameter-id en een formuleveld heeft er geen.
