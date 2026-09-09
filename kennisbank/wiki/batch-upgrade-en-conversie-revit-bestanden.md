---
titel: Batchgewijs Revit-bestanden upgraden en family-eenheden converteren — BIM Pure Plugin v0.4
status: concept
laatst-bijgewerkt: 2026-08-31
bronnen:
  - "raw/2026-08-31-uitgebreide-transcriptie-ai-bim-revit-automation-.md §2"
verwant:
  - rebar-api-parameters.md
  - revit-bronnen-en-communities.md
---

# Batchgewijs Revit-bestanden upgraden en family-eenheden converteren

De **BIM Pure Plugin**, versie 0.4, voegt een tool **Upgrade Revit Files** toe
en repareert een bug in **Convert Family Units**
(`raw/2026-08-31-uitgebreide-transcriptie-ai-bim-revit-automation-.md` §2). Dit
raakt de versiespanning die elders in de kennisbank terugkomt — zie
`rebar-api-parameters.md` §4 over de omschakeling van `BuiltInParameter` naar
64-bit in Revit 2024 — maar dan aan de bestandskant in plaats van de API-kant.

## 1. Upgrade Revit Files

Batchgewijs RVT- en RFA-bestanden (mix toegestaan) upgraden naar een hogere
Revit-versie, zonder Revit handmatig te openen:

1. Bestanden toevoegen via "Add Files"; de tool toont per bestand de
   gedetecteerde huidige versie.
2. **Workshared/centrale bestanden worden geweigerd** — die upgrade moet
   handmatig. **Downgrades worden automatisch overgeslagen** ("skipped"); een
   Revit 2025-bestand upgraden naar 2023 kan sowieso niet.
3. De tool herkent zelf welke Revit-versies lokaal geïnstalleerd staan; je
   kiest doel(versies) en een uitvoermap.
4. Bij uitvoeren opent een controlevenster en een command-line-proces: de
   plugin opent de benodigde Revit-versies op de achtergrond, voert de upgrade
   uit en sluit de sessies weer zelf af.
5. Uitvoerbestanden krijgen de jaargang van de release achter de
   bestandsnaam, bijvoorbeeld `_R23` of `_R24`.

[ONBEVESTIGD] Of dit compatibel is met SCI's eigen bestandsnaamconventie
(`NLRS_16_...`, `NLRS_28_...`) — de gesuffixte jaargang komt ná de bestaande
naam, niet ervoor; niet getoetst of dat botst met een vaste lengte- of
parseregel elders in het lint.

## 2. Bugfix: Convert Family Units

Zet maateenheden in een family om van imperiaal naar metrisch of andersom, met
een optie om dimensies af te ronden (tegen vreemde breuken) en om geneste
families mee te nemen. Vóór v0.4 kon die afrondingsfunctie bij complexe
families met veel parameters en formules de interne formules beschadigen. In
v0.4 is dat opgelost: dimensies, inclusief die van geneste onderdelen, worden
correct afgerond zonder dat de formules stukgaan.

## 3. Toegang

Exclusief voor leden van de BIM Pure Membership (`bimpure.com`), die ook
toegang geeft tot cursussen, live masterclasses, templates en
family-collecties. Geen aanwijzing dat SCI hier lid van is.
[ONBEVESTIGD] of een dergelijk lidmaatschap voor SCI interessant is — buiten
het bereik van deze kennisbank om te beoordelen.
