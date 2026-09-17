---
titel: Staalgewicht komt niet mee in de IFC-export
status: concept
laatst-bijgewerkt: 2026-09-17
bronnen:
  - "waargenomen in model S-9479_R25 (Revit 2025), 2026-09-15, via de Lees-MCP"
  - "W:\\1 - Informatie Snetselaar\\Constructief tekenen\\Revit\\01. SCI families\\2023\\IFC export setting 21\\IFC Configuration - SCI_IFC.json"
  - "W:\\1 - Informatie Snetselaar\\Constructief tekenen\\Revit\\03. Support\\ExportMappings\\RSF_NLRS_3.0.1_CustomPSets.txt"
  - "W:\\1 - Informatie Snetselaar\\Constructief tekenen\\Revit\\03. Support\\ExportMappings\\SCI_ParameterSets.txt"
  - "screenshots van het IFC Modify Setup-venster, aangeleverd door de gebruiker op 2026-09-15"
verwant:
  - ifc-import-verboden-tekens-in-namen.md
  - lees-mcp-koppeling.md
  - externe-repos-kandidaten-en-afgevallen.md
skill: sci-bim-context
---

# Staalgewicht komt niet mee in de IFC-export

Aanleiding: in S-9479_R25 toont BIMcollab bij stalen kolommen en liggers geen
gewicht, terwijl de staalstaten in Revit wel een gewicht geven. Bestemd voor de
BIM-coördinator, die de familiebibliotheek beheert.

## 1. De kern

Het gewicht bestaat alleen als **berekend veld in de staat**. Geen enkele
element-parameter draagt het. De IFC-export neemt eigenschappen van elementen
mee, geen formules uit staten. Daarom blijft het gewicht in de IFC leeg.

Uitgelegd voor een constructeur zonder Revit: de stuklijst rekent volume × 8000
kg/m³ uit op het moment dat je hem bekijkt. Het profiel zelf weet zijn gewicht
niet. De IFC is een kopie van de profielen, niet van de stuklijst.

## 2. Waarnemingen in S-9479_R25

Gemeten op 2026-09-15, alleen gelezen.

**De staten.** `SCI stalen liggers` en `SCI stalen kolommen` hebben een kolom
`Gewicht (8000kg/m³)`. Die kolom is een formuleveld (`berekend: true`, geen
parameter-id) op basis van het verborgen veld `Material: Volume`. Het model
bevat 59 staten; geen andere draagt een staalgewicht.

**De families.** `NLRS_28_SF_LIB_balk HE_gen_SCI` en
`NLRS_28_SCO_TLB_kolom HE_gen_SCI` sturen hun maten via een lookup table
(`Lookup Table Name` = `HEA`/`IPE`, eigen parameters `A`, `Breedte`, `tf`,
`tw`). De standaardparameters van Revit blijven leeg:

| Parameter | Kolom IPE360 (4136239) | Ligger HEA260 (4149994) |
|---|---|---|
| `Weight` (instance) | 0,00 kg | 0,00 kg |
| `Nominal Weight` (type) | leeg | bestaat niet |
| `Section Area` (type) | leeg | bestaat niet |
| `Section Shape` | I-shape Parallel Flange | Not Defined |
| `Structural Material` | `<By Category>` | `SCI_Staal_S355` |

`Weight` is 0,00 kg op alle steekproefelementen (HEA260, HEB500, HEB450,
HEA180, KK140x140x8, twee IPE360-kolommen). De strip
`NLRS_28_SF_LIB_wvb strip_gen_SCI` heeft de parameter niet.

**Het materiaal.** Op `SCI_Staal_S355` is de eigen parameter
`soortelijke_massa` leeg. Of er een physical asset met dichtheid aan hangt, is
via de Lees-MCP (`lees-mcp-koppeling.md`) niet zichtbaar.

[ONBEVESTIGD] Revit berekent `Weight` uit `Nominal Weight` × lengte. Dat past
bij de ligger, die ondanks S355 op 0 kg staat, maar het is niet opgezocht in de
API-documentatie.

## 3. De exportinstellingen

**In het model** (screenshots, 2026-09-15) staan aan: Revit property sets, IFC
common property sets, base quantities, material property sets, schedules als
property sets (alleen titels met IFC, Pset of Common), user defined property
sets en een parameter mapping table. Verder aan: *Export 2D plan view
elements*, *Export parts as building elements*, *Include Steel Elements*.
Category mapping: `RSF_NLRS_3.0.1_IFC Export Mapping Table`.

De bestandspaden van de user defined property sets en de mapping table waren
in de screenshot afgekapt. [ONBEVESTIGD] Het zijn
`RSF_NLRS_3.0.1_CustomPSets.txt` en `RSF_NLRS_3.0.1_ParameterMappingTable.txt`.
In de screenshots was in de lijst links niet `SCI_IFC` blauw geselecteerd. Of
de getoonde instellingen van `SCI_IFC` zijn, is dus niet zeker.

**De json op W:** (map `2023`) wijkt af: daar staan base quantities, user
defined property sets en parameter mapping uit. Die json is dus niet de stand
van de setup in S-9479_R25.

Waarom geen van die opties het gewicht oplevert:

| Route | Waarom leeg |
|---|---|
| Revit property sets | `Weight` gaat mee, maar is 0 |
| User defined property sets | `NLRS_Prestatie` mapt `Gewicht` → `NLRS_S_gewicht` (regel 1444). Die parameter bestaat niet op de elementen, dus de property vervalt |
| Parameter mapping table | bevat geen gewicht |
| Schedules als property set | alleen titels met IFC/Pset/Common. `SCI stalen liggers` en `SCI stalen kolommen` vallen erbuiten. `Pset_SCI_Algemeen` voldoet, maar bevat geen staalgewicht |
| Base quantities | [ONBEVESTIGD] levert voor liggers en kolommen lengte, doorsnede en volume; een gewicht vraagt een dichtheid op het materiaal, en die ontbreekt |

`SCI_ParameterSets.txt` (property set `Snetselaar_CustomPset`) bevat ook geen
gewicht.

[ONBEVESTIGD] Of een formuleveld uit een staat meegaat als de staattitel wél
"Pset" bevat, is niet getest.

## 4. Oplossingsrichtingen

Beslissing ligt bij de BIM-coördinator. Geen van deze routes is uitgevoerd.

1. **Kg/m als typeparameter uit de lookup table.** Het gewicht wordt kg/m ×
   lengte, via een familieformule of een script. Mappen naar `NLRS_S_gewicht`
   laat het landen in `NLRS_Prestatie.Gewicht`. Structureel, raakt de hele
   bibliotheek.
2. **`Nominal Weight` en `Section Area` vullen** vanuit de lookup table. Dan
   klopt ook Revit's eigen `Weight`, mits de aanname in §2 klopt.
3. **Dichtheid op de `SCI_Staal_*`-materialen** en materiaal op de kolommen.
   Botst met de afspraak dat S235 `Structural Material` bewust leeg laat
   vanwege de IFC-export (skill `sci-bim-context`). Eerst afstemmen.
4. **Snelle test zonder familiewerk.** Een kopie van de staalstaat met "Pset_"
   in de titel, exporteren, controleren in BIMcollab. Bewijst of route 3 uit de
   tabel in §3 werkt.

Voor een volgende ronde externe repo's staan vier IFC-kandidaten klaar: de
exporter zelf (`Autodesk/revit-ifc`, welke property sets hij standaard schrijft),
IDS en `ifctester` om een IFC vóór verzending te valideren, en een Nederlandse
pyRevit-tool die de mappingtabel bewerkt. Zie
`externe-repos-kandidaten-en-afgevallen.md` §2.

Een tweede gat in dezelfde keten staat in
`ifc-import-verboden-tekens-in-namen.md`: de placeholders in Project
Information komen ongefilterd in de IFC terecht en blokkeren daar de import
bij de ontvanger. Beide gevallen hebben dezelfde vorm — de export slaagt, de
ontvanger heeft er niets aan — en geen van beide wordt door een controle in
de exportknop gevangen.

Twee losse aandachtspunten. De staat rekent met 8000 kg/m³, de gangbare waarde
voor constructiestaal is 7850 kg/m³ (NEN-EN 1993-1-1 §3.2.6; de norm is in
deze sessie niet ingezien, [ONBEVESTIGD] tot hij is nagelezen). En de export neemt zes property-bronnen
tegelijk mee, waaronder de volledige NLRS-CustomPSets van ruim 1.700 regels. Dat
verklaart de lange, grotendeels lege eigenschappenlijst in BIMcollab.
