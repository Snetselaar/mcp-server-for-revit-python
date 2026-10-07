---
titel: Peil 0 en hoogtes meten in het SCI-lint
status: concept
laatst-bijgewerkt: 2026-10-07
bronnen:
  - "02_Beta NAP_Wijzigen script.py:10 en :416 (W:, stand 07-10-2026)"
  - "02_Beta As_Aanzichten script.py:32 en :364, Wand_Aanzichten script.py:339 (W:, stand 07-10-2026)"
  - "01_SCI Bovenkant paal aansluiten script.py:466, 02_Beta Kolommen_Taggen script.py:1349 en :1719 (W:, stand 07-10-2026)"
  - "03_R&D Vakwerk_Overzicht_Controle script.py:901-960, :1079, :1190 (W:, versie 2.11, 07-10-2026)"
  - "waargenomen in model 11260016_B-BKW-CS (Revit 2027): Vakwerk Overzicht 2.11 door Albert getest op 07-10-2026, uitkomst 'werkt'"
  - "reflectie op RevitAPI.dll 2024-2027 met RnD.extension\\tools\\check_api.ps1 (07-10-2026): BasePoint.GetProjectBasePoint, BasePoint.Position, Options.DetailLevel, GeometryInstance.GetInstanceGeometry, Edge.Tessellate"
  - https://rvtdocs.com/2024/Autodesk.Revit.DB.Level.ProjectElevation
  - https://rvtdocs.com/2027/Autodesk.Revit.DB.Level.ProjectElevation
verwant: []
skill: revit-api-docs
---

# Peil 0 en hoogtes meten in het SCI-lint

## Peil 0 is het projectbasispunt

Knoppen die een hoogte "t.o.v. peil" tonen, rekenen vanaf het
projectbasispunt. NAP_Wijzigen zegt het in zijn docstring (`script.py:10`),
As_Aanzichten zet het in zijn dialoog (`script.py:32`). Vakwerk Overzicht 2.11
doet hetzelfde voor de onderkant van de onderregel. Albert testte die versie
op 07-10-2026 in model `11260016` met de uitkomst "werkt"; de gemeten getallen
zelf zijn niet vastgelegd.

Geometrie staat in interne coördinaten. Een hoogte t.o.v. peil is dus altijd
`Z_intern - Z_projectbasispunt`.

## Twee routes in het lint

| Route | Gebruikt in | Wat het teruggeeft |
|---|---|---|
| `BasePoint.GetProjectBasePoint(doc).Position.Z` | As_Aanzichten, Wand_Aanzichten, Vakwerk Overzicht 2.11 | Z van het projectbasispunt in interne coördinaten; bestaat in 2024-2027 (reflectie, 07-10-2026) |
| `Level.ProjectElevation` | NAP_Wijzigen, Kolommen_Taggen, Bovenkant paal aansluiten | volgens de documentatie "the elevation relative to project origin", in 2024 en 2027 gelijk verwoord |

[ONBEVESTIGD] Of "project origin" in die omschrijving het interne nulpunt is
of het projectbasispunt. Kolommen_Taggen (`:1719`) en Bovenkant paal
aansluiten (`:466`) trekken `ProjectElevation` af van een geometrie-Z. Dat
klopt alleen als het om het interne nulpunt gaat. NAP_Wijzigen noemt dezelfde
waarde juist "t.o.v. het projectbasispunt". Beide kunnen niet waar zijn zodra
het projectbasispunt een Z heeft die niet 0 is. Toetsen: een model waarvan het
projectbasispunt verhoogd is, en daarin een level meten met beide routes.

## Onderkant van een profiel meten

De systeemlijn van een ligger zegt niets over de onderkant. Bij
z-justification Center hangt het profiel symmetrisch om de lijn. Vakwerk
Overzicht meet daarom aan de echte geometrie (`script.py:911-960`):

1. `Options` met `DetailLevel = ViewDetailLevel.Fine`, dan `get_Geometry`.
2. Door elke `GeometryInstance` heen met `GetInstanceGeometry()`. Dat levert
   modelcoördinaten op.
3. Van elke `Solid` met volume de randen tessellen (`Edge.Tessellate()`) en
   de laagste Z nemen. Bij een schuine onderregel is dat het laagste punt.
4. Geen solid gevonden: terugvallen op `get_BoundingBox(None).Min.Z`.

`Solid.GetBoundingBox()` is hier bewust niet gebruikt. Die box staat in het
assenstelsel van de solid, niet van het model; bij een getransformeerde solid
schuift de meting weg.

[ONBEVESTIGD] Of `DetailLevel = Fine` nodig is. Het is gezet omdat een ligger
op Coarse als lijn getekend wordt; niet gemeten of `get_Geometry` zonder view
dan ook alleen die lijn geeft.

## Toepassing: Vakwerk Overzicht 2.11

Per vakwerk meet de knop de onderkant van de onderregel (bottom chord) t.o.v.
peil 0, afgerond op 0,1 mm. Per family-type is de hoogte die het vaakst
voorkomt (op hele mm) de waarheid. Een exemplaar dat er meer dan 1 mm naast
zit, telt als afwijking (`script.py:901`, `:1190`). Dat is dezelfde
meerderheidsregel die sinds 2.8 voor de profielen geldt. Een type dat één keer
voorkomt toont alleen de hoogte.
