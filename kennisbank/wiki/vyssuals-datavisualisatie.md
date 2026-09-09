---
titel: Vyssuals — kleurgebaseerde data-analyse van Revit-modellen in de browser
status: concept
laatst-bijgewerkt: 2026-08-31
bronnen:
  - "raw/2026-08-31-uitgebreide-transcriptie-ai-bim-revit-automation-.md §7"
verwant:
  - mcp-versus-custom-tools.md
  - revit-bronnen-en-communities.md
  - mcp-revit-koppeling.md
---

# Vyssuals — kleurgebaseerde data-analyse van Revit-modellen

**Vyssuals** is een tool van Iskar Chindel die een Revit-model via een lokale
tweerichtingsverbinding in de browser laadt en kleurt op basis van
parameterwaarden
(`raw/2026-08-31-uitgebreide-transcriptie-ai-bim-revit-automation-.md` §7).
Ontstaan uit een ziekenhuisproject van 5.500 kamers in San Francisco, waar
Revit + Power BI wél inzicht gaf maar een gevonden fout omslachtig terug naar
Revit te herleiden was.

## 1. Werking

Een kleine Revit-addin maakt de verbinding; een startknop (vergelijkbaar met
Enscape) opent de browser met het volledige model erin geladen.

1. Categorie kiezen (bijvoorbeeld "Rooms") toont direct alle beschikbare
   parameters, met het percentage ingevulde waarden per parameter.
2. Een parameter aanklikken (bijvoorbeeld "Occupancy") genereert een
   staafdiagram van de verdeling én kleurt het 3D-model in de browser op basis
   van diezelfde waarden.
3. "Coloring in Revit" schrijft de kleuring terug naar het model in Revit
   zelf.

Alle verwerking is **lokaal**: geen data gaat over het internet tenzij
expliciet naar Cloud Models geüpload wordt. Voor projecten met strikte
dataprivacy-eisen is dat relevant, ook voor SCI-projecten met
vertrouwelijkheidsafspraken.

## 2. Gebruiksscenario's

- **Fouten opsporen.** Een outlier in het staafdiagram (bijvoorbeeld een
  buitenruimte met de kleur van een binnenruimte) valt op, ook als de
  betreffende ruimte diep in het model verstopt zit en in 3D niet opvalt.
- **Rapporteren zonder Revit.** Een geversioneerde cloud-upload genereert een
  weblink met dezelfde interactieve 3D- en diagram-interface, te delen met
  projectmanagers of klanten die geen Revit hebben.
- **Modelcontrole in drie stappen** (relevant voor MEP/BIM-managers): eerst
  "exists %" — bestaat de parameter op de elementen; dan "value %" — is hij
  ingevuld; dan een lijst toegestane waarden invoeren om de inhoud te toetsen.
  Controle-indelingen zijn op te slaan als persoonlijke of firmabrede
  sjablonen.
- **Change proposals tussen partijen.** Een externe adviseur (bijvoorbeeld een
  constructeur) opent een gedeelde cloud-link, vult waarden in een
  vereenvoudigde tabel-interface in en dient dat in als wijzigingsvoorstel. De
  BIM-manager ziet oude versus voorgestelde waarde, accepteert of weigert per
  voorstel, en pas dan wordt er naar het echte Revit-model geschreven.

## 3. AI/MCP-integratie — geen ingebouwde AI

Vyssuals bouwt bewust geen AI in de eigen software in. In plaats daarvan
verbindt een externe agent (Claude Code) via een eigen Model Context Protocol
met Vyssuals, dezelfde constructie als de pyRevit MCP-brug in
`mcp-revit-koppeling.md`. De AI kan het model inspecteren en wijzigingen
voorstellen; die voorstellen komen eerst zichtbaar in het dashboard te staan
(met highlight-kleuren) voordat een BIM-manager ze goedkeurt en ze pas dán
naar Revit worden geschreven.

Dat mens-in-de-lus-patroon is dezelfde conclusie als `mcp-versus-custom-tools.md`
§3: bouw AI-ondersteuning met een bevestigingsmoment, niet als autonome
uitvoering. Vyssuals is hiermee een derde, onafhankelijke bevestiging van dat
uitgangspunt, naast Erik Frits/BIM Pure (§2-3 van dat artikel) en Gavin
Nicholls' pleidooi voor deterministische automatisering
(zie `mcp-versus-custom-tools.md` §2).

## 4. Technische opzet en snelheid

Geen IFC: te traag voor deze toepassing volgens de bron. Vyssuals gebruikt in
plaats daarvan het **BOS**-concept (BIM Open Schema, Christopher Diggins),
waarbij geometrie- en parameterdata strikt gescheiden zijn en via
Parquet-bestanden worden opgeslagen. Een model van meer dan 1 GB laadt volgens
de demo in circa 2 seconden. [ONBEVESTIGD] Deze snelheid is een claim uit een
demo, niet onafhankelijk gemeten op een SCI-model.

Gratis proefperiode van 30 dagen via `vyssuals.com`.
