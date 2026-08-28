---
titel: Waar Revit-kennis vandaan komt — bronnen, kanalen en het P.R.O.C.E.S.S.-kader
status: concept
laatst-bijgewerkt: 2026-08-26
bronnen:
  - "raw/2026-08-25 samenvatting-bronnen.md §2 t/m §5"
  - "raw/2026-08-27_revit_mcp_bronnen_transcripties.md §7"
verwant:
  - rebar-api-parameters.md
  - mcp-revit-koppeling.md
  - mcp-versus-custom-tools.md
skill: revit-api-docs
---

# Bronnen en communities

Het landschap waar Revit-, API- en pyRevit-kennis vandaan komt. Bedoeld om bij een
onbekend probleem te weten wáár te zoeken.

---

## 1. API-documentatie — de skill gaat voor

Voor het opzoeken van een concrete signatuur is de skill **`revit-api-docs`** de
bron van waarheid: welke sites, welke URL-patronen, de GUID-truc voor
versievergelijking, en de regels over wat "geverifieerd" mag heten. Dit artikel
dupliceert dat niet.

Wat de dump toevoegt en daar niet in staat:

**Revit API Docs** dekt de versies **2015 t/m 2026** volgens de dump, en is
bruikbaar voor C#, VB.NET, C++ én Python. De skill noemt 2020 t/m 2027. Geen
tegenspraak — beide gaan over hetzelfde onvolledig gedocumenteerde bereik — maar
het is de moeite waard te weten dat de site ook ver terug reikt bij een oud
project.

De site linkt door naar het **Revit API Forum**, het **Dynamo Forum** en de
**Building Coder Blog**. Die eerste is in de praktijk waar echte werkende code
staat: de codefragmenten in `rebar-api-parameters.md` §1 komen daarvandaan, niet
uit de documentatie.

**ArchiLabs** wordt op die site gepromoot als AI-gestuurd CAD-platform waarin
elementen programmeerbaar zijn in Python of natuurlijke taal. Advertentie, geen
aanbeveling — hier vermeld zodat niemand het voor documentatie aanziet.

**Dynamo Dictionary** (`DynamoDS/DynamoDictionary`) is de doorzoekbare database
van alle Dynamo-nodes, open source, met wijzigingen via Pull Request. De
aanvulling op de Dynamo Primer.

---

## 2. pyRevit en Python-automatisering

**Erik Frits** is het kanaal dat volledig op pyRevit en Python in Revit zit.

Twee dingen die hij levert:

- **EF-pyRevit StarterKit** — een pakket om binnen enkele minuten een eigen
  extensie en knoppenbalk op te zetten.
- **EF-Tools** — gratis extensie met 50+ productiviteitstools: sheets dupliceren
  over Revit-versies heen, CAD-links sneller openen of herladen, batch-hernoemen
  van views, sheets, types en teksten.

EF-Tools staat al in `sci-bim-context` §2 als onderdeel van de tech stack. Wat
daar niet staat is dat er een StarterKit achter zit, en dat de auteur ook
`rvtdocs.com` maakt — een van de bronnen uit de skill `revit-api-docs`. Dezelfde
persoon zit dus achter drie dingen die hier gebruikt worden.

### Het P.R.O.C.E.S.S.-kader

Een zeven-stappenmethode van Erik Frits voor het bouwen van Revit-tools:

| Stap | Wat |
|---|---|
| **P**lan | doel bepalen en controleren of Revit dit niet al native kan |
| **R**esearch | online zoeken naar bestaande code of API-methoden |
| **O**utline | de logica structureren |
| **C**ode | snel een eerste werkende versie |
| **E**dit | refactoren en optimaliseren |
| **S**tress-test | testen onder extreme scenario's en fouten |
| **S**hip | opleveren aan het team |

**Stap P is woordelijk de tweede werkafspraak van SCI.** `sci-bim-context` §1
zegt: *"Niet overcompliceren. Check eerst of een native Revit-functie het probleem
al oplost (bv. 'Filter by Sheet' bestaat al)."* Dat een onafhankelijke bron tot
dezelfde eerste stap komt, is de sterkste onderbouwing die die huisregel tot nu
toe heeft.

De stappen **Stress-test** en **Ship** lopen parallel aan de fase-eisen uit de
skill `bimtools-promotie` (testmatrix, dan promoveren naar `02_Beta`). Research
sluit aan op `revit-api-docs`: opzoeken vóór schrijven, niet erna.

[ONBEVESTIGD] Of stap **E** (refactoren) in de SCI-praktijk gebeurt.
`bimtools-promotie` beschrijft de fasegang wel, maar noemt geen refactorstap.

---

## 3. IFC en openBIM

**BIM me up!** behandelt IFC-structuren en openBIM-workflows:

- de hiërarchie en default eigenschappen van `IfcProject`, `IfcSite` en
  `IfcBuilding` in Revit;
- hoe Revit-Levels naar IFC vertaald worden;
- IFC Common Property Sets exporteren en klantspecifieke Property Sets aanmaken;
- IFC Shared Parameters beheren via Revit **Key Schedules**;
- **IFC5**, gepresenteerd door Léon van Berlo en Angel Velez.

Dat laatste is het opvolgen waard: SCI's IFC-exportscripts
(`sci-bim-context`, `references/scripts-en-skills.md`) leunen op de huidige
IFC-versie en `Autodesk.IFC.Export.UI`.

**Power BI.** Zowel het koppelen van IFC-data aan Power BI als de *Autodesk Data
Exchange Power BI Connector* voor ACC-data. [ONBEVESTIGD] Of SCI Power BI of ACC
gebruikt — beide staan niet in `sci-bim-context` §2.

---

## 4. Kanalen, per gebruiksmoment

Geen ranglijst, maar een wegwijzer.

| Kanaal | Waarvoor |
|---|---|
| **Erik Frits** | pyRevit, Python, eigen tools bouwen |
| **Skillmax Academy** | constructief beton en staal, rebar-modellering, belastingcombinaties, Advance Steel |
| **BIM me up!** | IFC, openBIM, Power BI |
| **The Revit Kid** (Jeff Pinheiro) | houtconstructies, Toposolids, 3D-laserscannen naar Revit, visualisatie |
| **BIM Pure** | Revit-basis, templates, coördinatensysteem, view ranges, central versus local |
| **Balkan Architect** | architectuur, en foutafhandeling |
| **Man and Machine** | breed CAD/BIM, ook AutoCAD Electrical, Vault, Inventor |

### Twee foutmeldingen die het waard zijn te onthouden

Uit Balkan Architect, en dit is het concreetste dat uit sectie 5 van de dump komt:

- **"Error — Can't Be Ignored"** — veroorzaakt door geometrieconflicten of
  ongeldige constraints.
- **"Revit encountered a serious error"** — veroorzaakt door corrupte geometrie of
  incompatibele add-ins, met audit-protocollen om eruit te komen.

Die tweede raakt direct het eigen werk: een pyRevit-extensie is een add-in. Zie
`mcp-revit-koppeling.md` §5 voor de faalpunten aan de MCP-kant.

Verder benadrukt datzelfde kanaal Shared Parameters voor consistente BIM-data en
het vermijden van grafische overrides ten gunste van view templates en filters.
Dat sluit aan op de SCI-praktijk: `sci-bim-context` §3 schrijft browser-organisatie
via shared parameters voor, en de template werkt al met filters
(zie `rebar-documentatie-en-staten.md` §2).

**BIM Pure** heeft ook materiaal over Claude Code voor BIM-processen. Dat is nu
wél bekeken en verwerkt in `mcp-versus-custom-tools.md`: de vergelijking met de
officiële Autodesk 2027-server en drie waarnemingen van Claude Code op de
pyRevit-brug (warnings oplossen, gegenereerde code als ribbon-knop, materiaal
opruimen met bevestiging).
