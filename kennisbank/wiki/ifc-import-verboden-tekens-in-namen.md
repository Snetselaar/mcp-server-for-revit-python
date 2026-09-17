---
titel: IFC-import faalt in Revit 2027 op verboden tekens in IfcBuilding- en IfcSite-namen
status: concept
laatst-bijgewerkt: 2026-09-17
bronnen:
  - "P:\\9000-9999\\9450-9499\\9497 - warehouse met kantoor DUI02 Duiven\\5 Aangeleverd bwk\\2026-09-14 RVT en IFC modellen\\11260016_B-BWK-B_HBA_Stramienen.ifc.log.html (importlog, 2026-09-16 07:39)"
  - "hetzelfde, 11260016_B-BWK-B_HBA_Gebouw.ifc.log.html (2026-09-15 14:56)"
  - "regels 32 en 42 van 11260016_B-BWK-B_HBA_Stramienen.ifc"
  - "waargenomen in model S-9497_R27 (Revit 2027), 2026-09-16, via de Lees-MCP: Project Information element 1238"
  - "melding van de gebruiker 2026-09-16: hetzelfde IFC laadt wel in Revit 2025"
verwant:
  - ifc-export-staalgewicht.md
  - nlrs-en-bim-standaarden.md
  - lees-mcp-koppeling.md
skill: sci-bim-context
---

# IFC-import faalt in Revit 2027 op verboden tekens in IfcBuilding- en IfcSite-namen

Aanleiding: een aangeleverd IFC van Heembouw Architecten laadde niet in een
Revit 2027-project, terwijl hetzelfde bestand in Revit 2025 wel inlaadt. Revit
meldt alleen `Cannot open "…\11260016_B-BWK-B_HBA_Stramienen.ifc"`, zonder reden.

## 1. Het symptoom bedriegt

De melding lijkt op een bestands- of rechtenprobleem. Dat is het niet. Revit
begint de import wel degelijk: hij schrijft naast het IFC een
`<bestandsnaam>.ifc.log.html` en een `<bestandsnaam>.ifc.sharedparameters.txt`.
De import breekt daarna af, er komt geen `<bestandsnaam>.ifc.RVT` uit, en pas
dán volgt "Cannot open".

**Het logbestand naast het IFC is de eerste plek om te kijken.** Bij een
mislukte import staat daar de echte fout in.

## 2. De fout in het log

```
General ERROR: The name cannot contain these prohibited chars-"\ : { } [ ] | ; < > ? ` ~".
Parameter name: name

Entities Processed: 9   (alleen IfcProject, IfcApplication en de units)
Elements Created:   0
Importer Version:   27.2.0.39
```

Negen entiteiten verwerkt, nul elementen gemaakt. De import stopt bij het eerste
benoemde element na de eenheden. In dit bestand zijn dat:

```
#24=IFCBUILDING(…,'<1 gebouwnummer/naam>',$,$,#23,$,'<1 gebouwnummer/naam>',.ELEMENT.,$,$,#21);
#34=IFCSITE(…,'<Kadastrale aanduiding 1, (gemeente, sectie, nummer), Kadastrale aanduiding 2>',…);
```

Beide namen bevatten `<` en `>`, en die staan allebei in de lijst met verboden
tekens. De aanleverende partij heeft de placeholders uit zijn Revit-template
laten staan in Project Information.

> [ONBEVESTIGD] Dat precies déze twee namen de afbreking veroorzaken, is een
> gevolgtrekking uit het aantal verwerkte entiteiten, niet uit een geteste fix.
> Een geschoonde kopie is niet geprobeerd — de gebruiker vond een RVT-versie van
> hetzelfde model en had de import niet meer nodig.

## 3. Waarom 2025 het wel slikt

De importer die de fout geeft is versie 27.2.0.39. Dezelfde bestanden importeren
wel in Revit 2025.

> [ONBEVESTIGD] Of de 2025-importer de namen saniteert, of IfcSite en
> IfcBuilding niet als benoemd Revit-element aanmaakt, is niet uitgezocht.
> Vastgesteld is alleen het verschil in uitkomst.

Het IFC is zelf geëxporteerd uit Revit 2027 (`Autodesk Revit 2027 (ENU)`,
exporter 27.2.0.39, schema IFC4). De 2027-exporter schrijft dus namen die de
2027-importer weigert. Wie een IFC alleen controleert door hem te exporteren,
merkt dit nooit.

## 4. SCI heeft hetzelfde probleem

Gemeten op 2026-09-16 in `S-9497_R27` (Revit 2027), Project Information
(element 1238), via de Lees-MCP (`lees-mcp-koppeling.md`):

| Parameter | Waarde | Gaat naar |
|---|---|---|
| `Building Name` | `<RVB-gebouwnummer>` | `IfcBuilding.Name` |
| `SiteName` (shared, `15020a36-…`) | `<Kadastrale aanduiding>` | `IfcSite.Name` |
| `Client Name` | `Opdrachtgever` | — |
| `Project Name` | `Template` | — |
| `Project Number` | `S-0000` | — |

Dezelfde constructie als bij Heembouw, met dezelfde twee verboden tekens. Elke
IFC die uit een SCI-model komt waarin deze velden niet zijn ingevuld, krijgt dus
IfcBuilding- en IfcSite-namen die een Revit 2027-ontvanger niet kan importeren.

De laatste drie regels van de tabel zijn ook oningevulde placeholders, maar
zonder verboden tekens. Die breken de import niet; ze zijn wel ILS-vuil bij de
ontvanger. Zie `nlrs-en-bim-standaarden.md` §2 over BIM Basis ILS.

`BCB_ProjectFolder` in datzelfde model wijst naar
`W:\1 - Informatie Snetselaar\Constructief tekenen\Revit\01. SCI families\2020\Template\`.

> [ONBEVESTIGD] Of de placeholders uit de huidige template komen, is niet
> geverifieerd. De nieuwste `.rte` op W: is
> `01. SCI families\2025\Template\SCI_template_2025.rte` (de mappen 2026 en 2027
> bevatten alleen `Snetselaar package`-familiebestanden). Een `.rte` is binair en
> alleen in Revit uit te lezen, dus dit vraagt een controle in Revit zelf.

## 5. Wat te doen

**Aan de ontvangende kant**, als een aangeleverd IFC niet laadt:

1. Lees het `.ifc.log.html` naast het bestand.
2. Is het deze fout, haal dan de verboden tekens uit de IfcBuilding- en
   IfcSite-namen in een kopie van het IFC. Het zijn twee regels.
3. Of importeer in Revit 2025 en upgrade de resulterende RVT.
   [ONBEVESTIGD] Niet geprobeerd: de gebruiker vond een RVT-versie en had de
   import niet meer nodig. Of de upgrade de verboden tekens in de namen alsnog
   weigert, is onbekend.

**Aan de zendende kant:** Project Information invullen vóór de IFC-export. De
tekens `` \ : { } [ ] | ; < > ? ` ~ `` horen niet in `Building Name` of in de
`SiteName`-parameter. Dit is ook wat BIM Basis ILS al vraagt; de importfout maakt
er een harde eis van in plaats van een afspraak.

Een exportcontrole die hierop toetst bestaat nog niet. De IFC-exportknoppen van
het SCI-lint kijken er niet naar; `ifc-export-staalgewicht.md` beschrijft een
ander gat in dezelfde keten.

## 6. Openstaand

- Staan de placeholders in `SCI_template_2025.rte` zelf, of alleen in modellen?
  Vraagt openen in Revit.
- Welke andere velden van Project Information belanden in een IFC-naam? Getoetst
  zijn alleen `Building Name` en `SiteName`.
- Blijft `IFCMATERIAL('<Unnamed>')` — aangetroffen in
  `11260016_B-BWK-B_HBA_Gebouw.ifc` regel 113653 — ook hangen op dezelfde
  validatie? De import komt daar niet eens aan toe.
- Loont een controle in de exportknop, of is invullen van Project Information
  een afspraak die zonder script volstaat?
