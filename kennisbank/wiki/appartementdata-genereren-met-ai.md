---
titel: Appartementdata genereren en wegschrijven met Claude Code + pyRevit MCP
status: concept
laatst-bijgewerkt: 2026-08-31
bronnen:
  - "raw/2026-08-31-uitgebreide-transcriptie-ai-bim-revit-automation-.md §6"
verwant:
  - mcp-versus-custom-tools.md
  - ai-tools-voor-pyrevit-ontwikkeling.md
  - rebar-api-parameters.md
---

# Appartementdata genereren en wegschrijven met Claude Code + pyRevit MCP

Een vierde waarneming naast de drie in `mcp-versus-custom-tools.md` §5, met
genoeg eigen stappen om apart te staan: Nick (BIM Pure) gebruikt Claude Code +
de pyRevit MCP om per appartement een reeks afgeleide gegevens te berekenen en
terug te schrijven in Revit-parameters, en laat daarna Claude Code er een
blijvende pyRevit-knop van maken
(`raw/2026-08-31-uitgebreide-transcriptie-ai-bim-revit-automation-.md` §6).

## 1. De voorbereiding en de prompt

Voorwaarde in Revit: een **Area Plan** voor het te analyseren niveau (in de
bron **Level 4**), met **Area Boundary Lines** en één **Area** per appartement
— de Areas zijn tegelijk startpunt en opslagplek voor de nieuwe parameters.

De prompt aan Claude Code vraagt vier afgeleide waarden per appartement op
Level 4: de afstand tot de dichtstbijzijnde lift en trap, het aantal ramen en
het totale glasoppervlak, het aantal buren op dezelfde verdieping, en de
hoogste plafondhoogte. Claude moet zelf de bijbehorende **project-parameters**
op de Area-categorie aanmaken met het juiste datatype: *Length* voor afstanden
en hoogtes, *Integer* voor aantallen ramen en buren, *Area* voor glasoppervlak.

## 2. Interactieve verduidelijking — zonder daarom gevraagd te zijn

Nick vergat in de eerste prompt te vermelden dat Claude moest doorvragen bij
onduidelijkheid; Claude deed dat toch, uit zichzelf. Drie vragen, met de
antwoorden die de definitie voor dit specifieke model vastleggen:

- **Afstandsberekening** — mag de **Path of Travel-tool** gebruikt worden?
  Bevestigd als meest nauwkeurige methode.
- **Wat is een buur** — appartementen die een **gemeenschappelijke muur**
  delen.
- **Glasoppervlak** — berekenen op de **ruwe sparingmaat** ("rough opening"),
  voorlopig.

Dat laatste is meteen de belangrijkste beperking die Claude zelf meldt bij de
resultaten: de glasoppervlakte houdt geen rekening met glaslatten of
profielen. Hoekappartementen hebben daardoor logischerwijs meer ramen en
glasoppervlak dan tussenliggende units — geen fout, een verwacht effect van de
locatie.

## 3. Een bekende meetfout: de Path of Travel-marge

De Path of Travel-tool laat bij de afstandsmeting naar lift en trap een gat
van ongeveer **1 foot 6 inches (± 45 cm)**, door hoe start- en eindpunt
geplaatst worden. Nick's correctie: handmatig revisietrajecten tekenen via het
tabblad **Analyze**, het appartementnummer aan een custom veld koppelen, en
die preciezere data terugvoeren naar Claude.

Dit is dezelfde soort systematische meetfout als de ~45 cm-marge zelf: een
tool die intern een aanname doet over start-/eindpunten, zonder dat in de
resultaten te vermelden. Vergelijkbaar met de constatering in
`rebar-api-parameters.md` §2 dat dekking per vlak geldt en niet per element —
in beide gevallen is de valkuil dat een enkel getal een aanname verbergt.

## 4. Van ad-hoc analyse naar vaste knop: `Unit Data`

Prompt: *"Create a tool in the pamphlets extension for the windows, window
square footage, neighbors, and ceiling height to automatically fill up the
values in areas."* Binnen enkele minuten genereert Claude Code een nieuwe
knop **Unit Data** (`unit_data`) in de `pamphlets`-extensie — dat is Nick's
eigen extensie, geen SCI-naam.

Werking van de knop:

1. Klikken op **Unit Data** op de ribbon.
2. Het juiste **area scheme** kiezen.
3. Aanvinken welke parameters berekend moeten worden.
4. **Filteren** welke ramen meetellen (bijvoorbeeld metalen panelen of dichte
   delen uitsluiten).
5. **Calculate**, resultaten controleren, dan **Write to areas** om de data
   definitief in de Area-parameters te zetten.

Dit is exact de tweede waarneming uit `mcp-versus-custom-tools.md` §5 in
uitgewerkte vorm: een script dat via de MCP-brug goed werkt, wordt een vaste
pyRevit-knop. Het sluit ook aan op het advies in §3 van datzelfde artikel —
bouw tools *met* AI, niet een blijvende afhankelijkheid van de chatsessie. Het
is ook een tweede, onafhankelijke illustratie van wat `ai-tools-voor-pyrevit-ontwikkeling.md`
beschrijft: AI die zelf de pyRevit-mappenstructuur en de `script.py`/`bundle.yaml`-combinatie
opzet, hier op basis van één prompt in plaats van een los hulpmiddel.

## 5. Exporteren en verzoenen met een extern bestand

Vanuit de Area-data kan Claude direct een **Excel-bestand** genereren, of een
gewone Revit **Area Schedule**. Sterker: Claude kan de Revit-data vergelijken
en verzoenen ("reconcile") met een spreadsheet die een projectontwikkelaar of
externe partner aanlevert, en discrepanties direct aanwijzen.

## 6. Twee aanbevelingen, allebei bevestiging van bestaand advies

- **Verifieer AI-data altijd handmatig.** Complexe modelgeometrie kan fouten
  laten insluipen, ook al is de AI snel. Dezelfde strekking als het
  bevestigingsmoment in `mcp-versus-custom-tools.md` §2-3.
- **Beheer tokenverbruik.** Dezelfde zware MCP-analyse herhaaldelijk via
  Claude Code draaien is duur; **eenmalig een pyRevit-tool laten schrijven en
  lokaal uitrollen** is de goedkopere weg. Dit is dezelfde afweging als de
  kosten-/schaalkolom in `mcp-versus-custom-tools.md` §1 ("bulk hoort bij een
  knop, verkennen bij de brug"), hier met een concreet getal erbij: een tool
  bouwen kost eenmalige tijd, herhaald gebruik via de chatbrug loopt op.

[ONBEVESTIGD] Of dit patroon (Area-analyse → parameters → vaste knop →
reconciliatie) iets is waar SCI een concrete toepassing voor heeft — de bron
demonstreert het op een generiek appartementengebouw, niet op een SCI-project.
