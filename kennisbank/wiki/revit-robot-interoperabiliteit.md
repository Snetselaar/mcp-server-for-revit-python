---
titel: Revit en Robot Structural Analysis — de bidirectionele link
status: concept
laatst-bijgewerkt: 2026-08-26
bronnen:
  - "raw/2026-08-25-samenvatting-revit-structure-rebar.md §2"
verwant:
  - rebar-3d-modelleren.md
skill: sci-bim-context
---

# Revit ↔ Robot Structural Analysis

De koppeling tussen het fysieke model in Revit en het rekenmodel in Robot.

**Eén bron, gecureerd.** Alles hieronder steunt op één AI-samenvatting met
niet-herleidbare bronverwijzingen. Behandel het als een startpunt, niet als
werkinstructie.

[ONBEVESTIGD] Of SCI Robot überhaupt gebruikt. `sci-bim-context` §2 noemt bij de
tech stack pyRevit, EF-Tools en DiRoots, en verder Bluebeam voor tekenproductie —
Robot staat er niet bij. Uitzoeken voordat hier tijd in gaat.

---

## 1. De cyclus

1. **Fysiek model** in Revit, opgebouwd door de modelleur.
2. **Analytisch model** wordt gelijktijdig gegenereerd. Dat bevat randvoorwaarden
   (*Boundary Conditions*), knooppunt-releases (*Member End Releases*) en
   belastingen (*Loads*).
3. **Naar Robot** voor de berekening.
4. **Terug naar Revit**: profielwijzigingen en de theoretisch benodigde wapening
   (*Required Reinforcement*) werken het fysieke model bij.

Het punt is dat 2 en 1 náást elkaar bestaan. Het analytische model is een
vereenvoudiging, geen afgeleide die je achteraf maakt.

---

## 2. De valkuil: Member End Releases

Dit is het enige echt operationele punt uit de bron, en het is er een die je een
middag kost als je hem niet kent.

**Verbindingen staan in Revit standaard op `Pinned-Pinned`.** Wordt dat
ongewijzigd naar Robot gestuurd, dan levert de berekening
**instabiliteitsfouten** op.

Twee uitwegen:

- de releases in Revit correct definiëren, zodat de engineering intent in het
  model zit;
- bij de eerste export kiezen voor **"Do not use Revit Settings"** en de releases
  handmatig in Robot beheren.

De eerste is de betere: dan staat de aanname in het model in plaats van in het
hoofd van degene die exporteerde.

---

## 3. Content Generator Extension

Autodesk adviseert constructieve elementen (balken, kolommen) aan te maken met de
**Content Generator Extension**, op basis van regionale industrie-standaard staal-
en betonprofielen. Die profielen sluiten aan op de database van Robot.

Reden: profielen die Revit kent maar Robot niet, of andersom, breken de
uitwisseling. Dit raakt de NLRS-naamgeving uit `sci-bim-context` §3 — daar staan
staalprofielen als HEA/HEB/IPE/UNP onder de `_SCO_`-conventie. [ONBEVESTIGD] Of de
Content Generator profielen oplevert die aan die conventie voldoen, of dat er een
hernoemslag tussen zit.

---

## 4. Wapening heen en weer

Wapening die in Robot is ontworpen voor **kolommen, balken en poeren** (*spread
footings*) kan bidirectioneel worden uitgewisseld.

De bron adviseert Revit Extensions te gebruiken voor het genereren van
wapeningspatronen, om parametrische consistentie te behouden.

**Let op de categorie-conventie.** `sci-bim-context` §5 legt vast: palen zijn
*Structural Foundation*, funderingsvormen zijn *Structural Framing*. De bron
spreekt hier over "poeren / spread footings" zonder die scheiding te maken. Welke
Revit-categorie daar bij SCI bij hoort, volgt uit de huisregel, niet uit deze
bron.

Wapening die uit Robot komt, komt niet als Shape Driven of Free Form Rebar binnen
zoals beschreven in `rebar-3d-modelleren.md` §6 — [ONBEVESTIGD] in welke vorm dan
wel, zegt de bron niet.
