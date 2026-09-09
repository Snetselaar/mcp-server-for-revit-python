---
titel: NLRS en BIM-standaarden — aanvullingen op de skill
status: concept
laatst-bijgewerkt: 2026-08-26
bronnen:
  - "raw/2026-08-25-samenvatting-revit-structure-rebar.md §3 en §4"
verwant:
  - rebar-documentatie-en-staten.md
skill: sci-bim-context
---

# NLRS en BIM-standaarden

**Dit artikel is met opzet dun.** De SCI-laag bovenop NLRS staat in de skill
`sci-bim-context` §3: naamgeving `NLRS_##_CATEGORIE_..._SCI`, de
categorie-conventies, de browser-organisatie via `hoofd_map` en `sub_map`, de
eenheden. Die skill is de bron van waarheid en wordt hier niet herhaald.

Hieronder alleen wat daar niet in staat.

---

## 1. Onderdelen van NLRS die nog nergens beschreven zijn

De NLRS wordt beheerd door Stichting Revit Standards. Naast naamgeving bevat hij
Object Styles (lijndikten, kleuren, arceringen), Shared Parameters, mappingregels
en modelleerrichtlijnen.

Drie onderdelen die in `sci-bim-context` niet voorkomen:

**USO — Uniforme Sparingsopgave.** Een werkwijze binnen de NLRS om
sparingsverzoeken discipline-overstijgend te coördineren en uit te wisselen, op
basis van gedeelde parameters en IFC-classificaties. Relevant voor het federatieve
model met ±30 gekoppelde modellen dat in `sci-bim-context` §4 staat — daar is
sparingscoördinatie per definitie een thema. [ONBEVESTIGD] Of SCI de USO gebruikt.

**Family Guide Doors.** Richtlijnen voor deuren, ramen en overige openingen,
inclusief vliesgevels: oriëntatie, nulpunt-bepaling, parametergebruik.

**MEP Family Guide.** Richtlijnen voor installatiecomponenten, inclusief
connectorgeometrie en parameters.

Die laatste twee zijn architectuur- en installatiewerk. Voor een constructief
bureau vermoedelijk randgebied, maar in een federatief model kom je ze tegen als
je andermans families moet beoordelen.

---

## 2. BIM Basis ILS

De NLRS bevat een stapsgewijze handleiding voor een IFC-export die voldoet aan de
Nederlandse **BIM Basis Informatieleveringsspecificatie**.

`sci-bim-context` (`references/scripts-en-skills.md`) beschrijft de bestaande
IFC-exportscripts en de kernpatronen daarachter. [ONBEVESTIGD] Of die scripts de
BIM Basis ILS-stappen volgen, of dat ze een eigen route hebben. Dat is een
concrete vraag die het waard is uitgezocht te worden: een export die technisch
slaagt maar niet ILS-conform is, wordt door de ontvanger teruggestuurd.

---

## 3. Drie termen die vastliggen

Uit de BIM Dictionary (BIMe Initiative), een open-source databank met
gestandaardiseerde definities. Opgenomen omdat ze in bestekken en BIM-protocollen
terugkomen en dan precies bedoeld worden:

**BIM** — een set technologieën, processen en beleidsregels die stakeholders in
staat stelt gezamenlijk gebouwen te ontwerpen, construeren en beheren in een
virtuele omgeving.

**BEP — BIM Execution Plan** — het document dat beschrijft hoe de
informatiemanagement-aspecten van een opdracht concreet worden uitgevoerd.

**CDE — Common Data Environment** — de overeengekomen centrale informatiebron voor
een project of asset, voor het verzamelen, beheren en verspreiden van documenten
en data. Conform **ISO 19650**.

[ONBEVESTIGD] Welke CDE SCI gebruikt, en of er per project een BEP ligt. Staat
nergens vastgelegd.
