---
titel: Model vergelijken, fase 0 — GlobalId-stabiliteit en de inhoud van een IFC-link
status: concept
laatst-bijgewerkt: 2026-09-28
bronnen:
  - "bouwplan_model_vergelijken.md (Downloads, stand 26-09-2026), sectie Voorwaarde: fase 0"
  - "gemeten op W:\\4 - Tijdelijk en verwijderen\\AWO\\02 Test project: drie aanleveringen IKC Cunera van GAJ (16-06, 28-07, 22-09-2026), elk IFC + RVT"
  - "RnD.extension\\tools\\ifc_guid_stabiliteit.py op W: (28-09-2026)"
  - "waargenomen in model IKC Cunera_CON_SNE_9204_DO_R25_test project (Revit 2025) via de Lees-MCP, met de IFC- en RVT-link van 28-07 geladen"
  - https://www.revitapidocs.com/2024/c13bd6d6-8292-7fa0-0e78-c81dc1b3ecc3.htm
  - https://www.revitapidocs.com/2027/bdb3a91e-9a0a-e68d-51da-c460535f5fd2.htm
verwant:
  - ifc-import-verboden-tekens-in-namen.md
  - lees-mcp-koppeling.md
skill: revit-api-docs
---

# Model vergelijken, fase 0

De knop Model vergelijken (03_R&D, bouwplan van 26-09-2026) vergelijkt twee
aanleveringen van de architect op sleutel: IfcGUID bij een IFC-link, UniqueId bij
een RVT-link. Fase 0 moest vooraf aantonen dat die sleutel stand houdt en laten
zien wat er in een IFC-link binnenkomt. Gemeten op 28-09-2026 op drie
aanleveringen van IKC Cunera (architect GAJ, Revit 2025).

## GlobalId-stabiliteit

De norm uit het bouwplan is dat minstens 95% van de GlobalIds terugkomt. Letterlijk
geteld haalt deze architect dat niet: 48,3% (16-06 → 28-07) en 91,7% (28-07 →
22-09). Die telling mengt twee dingen. De Revit-exporter zet het Revit-ElementId
achter de naam (`Basic Wall:ontwerp_lichte_scheidingswand_125mm:8810367`), en een
ElementId wordt in een Revit-document nooit hergebruikt. Daarmee is "echt weg" te
scheiden van "zelfde element, nieuwe GlobalId".

| | 16-06 → 28-07 | 28-07 → 22-09 |
|---|---|---|
| letterlijk terug | 1660 van 3439 (48,3%) | 5200 van 5673 (91,7%) |
| echt weg (ElementId verdwenen) | 1752 | 464 |
| zonder ElementId in de naam, niet te toetsen | 25 | 9 |
| nog bestaand, zelfde GlobalId | 1660 van 1662 (99,9%) | 5200 van 5200 (100%) |
| sparingen (IfcOpeningElement) terug | 194 van 430 (45,1%) | 372 van 482 (77,2%) |

Het lage letterlijke getal is modelwerk: in de DO-fase haalde de architect onder
meer 51 van de 53 IfcColumns, 52 van de 61 IfcBeams en 1424 IfcMembers weg. De
twee elementen met een nieuwe GlobalId zijn IfcSlabs. De tweede export komt van
een andere werkplek en een oudere exporter (25.4.30.30 tegen 25.4.41.14); ook
daarover blijft de GlobalId gelijk.

Sparingen zijn geen bruikbare sleutel. Ze krijgen nieuwe GlobalIds en in de
aanlevering van 22-09 staan 14 GlobalIds dubbel, allemaal IfcOpeningElement. Een
sparing draagt de naam en het ElementId van haar host, dus de ElementId-toets
werkt er niet.

**Conclusie:** doorgaan. De 95%-norm hoort te gaan over elementen die blijven
bestaan. Een terugvalmatching op bbox-overlap is voor deze architect niet nodig.

`ifc_guid_stabiliteit.py` herhaalt de meting voor een andere architect, zonder
ifcopenshell. [ONBEVESTIGD] Voor een IFC uit een ander pakket dan Revit werkt de
ElementId-toets niet; dan blijft alleen de letterlijke telling over.

## Inhoud van een IFC-link

Waargenomen in 9204 met `…_28-07-2026.ifc` gelinkt. Revit schreef de
`.ifc.RVT` (176 MB), een `.ifc.log.html` en een `.ifc.sharedparameters.txt` naast
het IFC-bestand op W:.

- **Documentnaam.** De titel van het linkdocument eindigt op `.ifc`, niet op
  `.ifc.RVT`. Het bouwplan herkent een IFC-link aan `.ifc.RVT`; dat moet op het
  pad (`PathName`) gebeuren, of op beide.
- **Klasse.** Alles komt binnen als `DirectShape`, zonder Level (`level: null`).
- **IfcGUID** staat in de BuiltInParameter `IFC_GUID` (id -1019000) en is gelijk
  aan de GlobalId in het IFC-bestand, gecontroleerd op wand 8810367
  (`0McjYUQbf9Re2$9MWFbnXQ`). De IFC-link van de architect draagt dezelfde
  IfcGUID ook in zijn RVT: de sleutel is in beide linksoorten beschikbaar.
- **Bouwlaag** komt als tekstparameter `IfcSpatialContainer`
  (`-01 tussenverdieping kelder`), plus `IfcSpatialContainer GUID`.
- **Properties** komen als gedeelde parameters binnen, onder meer
  `Pset_WallCommon.LoadBearing`, `Pset_WallCommon.IsExternal`,
  `Pset_SlabCommon.LoadBearing`, `IfcTag` (het ElementId van de architect),
  `IfcName` en `BaseQuantities.*`.

### Categorieën

| Revit-categorie | aantal | IFC-klasse |
|---|---|---|
| Walls | 265 | IfcWall + IfcWallStandardCase (13 + 252) |
| Floors | 72 | IfcSlab, inclusief afwerkvloeren |
| Roofs | 10 | IfcRoof |
| Doors | 113 | IfcDoor |
| Windows | **0** | ramen staan in Generic Models |
| Structural Framing | 9 | IfcBeam |
| Structural Columns | 2 | IfcColumn |
| Stairs | 13 | IfcStair |
| Curtain Panels | 45 | IfcPlate |
| Curtain Wall Mullions | 4643 | IfcMember |
| Generic Models | 781 | gemengd: sparingen, ramen, proxies, trapdelen, afwerkingen |

In een steekproef van 206 van de 781 Generic Models stond in `Export to IFC As`:
142× `IfcOpeningElement`, 38× `IfcBuildingElementProxyType`, 22×
`IfcWindowStyle`, 3× `IfcStairFlightType` en 1× `IfcCoveringType`.

- **Sparingen zijn eigen elementen.** Elke IfcOpeningElement wordt een losse
  DirectShape in Generic Models, zonder type, met de naam van host of kozijn
  (`Floor-23_kanaalplaat_260mm-8032515-2`, `32_hout_deur_enkel-…-8915685-1`).
  Sparing 678424 valt binnen de bbox van wand 678417.
- **Solid of mesh** is via de Lees-MCP niet te zien. In het IFC-bestand zijn de
  Body-representaties grotendeels SweptSolid, Brep en MappedRepresentation;
  SurfaceModel komt 9 tot 17 keer voor. [ONBEVESTIGD] Hoe Revit dat omzet, meet
  de eerste snapshot in fase 1.

## RVT-link

De RVT-link van 28-07 in hetzelfde model: gewone `Wall`, `Floor` en
`FamilyInstance` met Level, ramen in Windows, deuren in Doors. Alle acht
worksets staan open, ook `vervallen` en `bruto inhoud`.

De bbox van hetzelfde element verschilt tussen de twee linksoorten. Wand 8810367:
Y 23300–26850 in de RVT, 23362,5–26700 in de IFC. Een IFC-snapshot mag dus nooit
met een RVT-snapshot vergeleken worden, alleen met een snapshot van dezelfde soort.

## Dragend-vlag onbruikbaar bij deze architect

`Pset_SlabCommon.LoadBearing` staat op `No` bij `Floor-23_kanaalplaat_260mm`
(678430, 678982), en in de RVT-link staat `Structural` op `No` bij dezelfde
vloeren en bij de wanden. Het bouwplan zet "dragende elementen eerst" in de
aandachtspunten; bij GAJ levert die vlag niets op.

## Gevolgen voor het bouwplan

| Bouwplan | Wat fase 0 laat zien |
|---|---|
| categoriefilter op Revit-categorie | bij een IFC-link staan ramen, sparingen en proxies samen in Generic Models; filteren op `Export to IFC As` (`IFC_EXPORT_ELEMENT_AS`), niet op categorie |
| sparingen via contouren | nodig en juist: sparing-GlobalIds zijn instabiel en dubbel |
| IFC-link herkennen op `.ifc.RVT` | op het pad, niet op de titel |
| bouwlaag uit IFC-parameters | `IfcSpatialContainer` |
| dragende elementen eerst | vlag leeg bij GAJ; een andere toets is nodig |
| Floors | bevat afwerkvloeren (`43_vloerbedekking`, `43_cementdekvloer_70mm`) |

## API-verificatie voor de bouw (28-09-2026)

Alle aangenomen API-namen uit het bouwplan zijn met `check_api.ps1` getoetst in de
RevitAPI.dll van 2024, 2025, 2026 en 2027. Ze bestaan in alle vier met dezelfde
signatuur, op één na: `ParameterFilterRuleFactory.CreateEqualsRule(ElementId,
String, Boolean)` bestaat alleen in 2024/2025. `CreateEqualsRule(ElementId,
String)` staat in alle vier.

Uit de documentatie, 2024 en 2027:

- `RevitLinkType.UpdateFromIFC(Document, String, String, Boolean)` vraagt een
  open transactie (`ModificationOutsideTransactionException`). Over undo zegt de
  pagina niets.
- `RevitLinkType.LoadFrom(ModelPath, WorksetConfiguration)` moet buiten elke
  transactie en wist de undo-geschiedenis. Vervangen van een RVT-link is dus
  nooit met Ctrl+Z terug te draaien.
