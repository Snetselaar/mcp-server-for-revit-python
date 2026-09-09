---
titel: Hulpmiddelen om zelf pyRevit-tools te bouwen met AI
status: concept
laatst-bijgewerkt: 2026-08-31
bronnen:
  - "raw/2026-08-31-uitgebreide-transcriptie-ai-bim-revit-automation-.md §3 en §4"
verwant:
  - mcp-eigen-tools-toevoegen.md
  - mcp-versus-custom-tools.md
  - revit-bronnen-en-communities.md
  - appartementdata-genereren-met-ai.md
skill: pyrevit-codestijl
---

# Hulpmiddelen om zelf pyRevit-tools te bouwen met AI

`mcp-eigen-tools-toevoegen.md` beschrijft hoe je een tool toevoegt aan **deze**
MCP-repo. Dit artikel gaat over twee losse hulpmiddelen van Erik Frits om
pyRevit-tools in het algemeen sneller met AI te bouwen: gratis toegang tot
Claude Code, en een browser-tool die het WPF/XAML-handwerk vervangt.

## 1. Claude Code gratis via OpenRouter — tijdelijk, [ONBEVESTIGD] hoe lang

Erik Frits demonstreert hoe Claude Code zonder kosten te draaien is door de
standaard-API van Anthropic te vervangen door **OpenRouter**
(`raw/2026-08-31-uitgebreide-transcriptie-ai-bim-revit-automation-.md` §3). Zelf
verbruikte hij op deze manier 126 miljoen tokens voor $0.

Stappen:

1. Account en API-key aanmaken op `openrouter.ai` (tabblad API Keys → Create
   Key).
2. Een model kiezen dat op dat moment gratis staat. Op 2026-08-31 was dat
   **`ox-alpha`** ("Ox Alpha"), een niet nader genoemd frontier-model met een
   contextvenster van 1 miljoen tokens, vermoedelijk gepositioneerd naast
   OpenAI's o1/GPT-5-klasse.
3. In de projectmap een `.claude/settings.json` aanmaken die de base-URL
   overschrijft naar `https://openrouter.ai/api/v1`, de OpenRouter-key erin
   zet, `default_model`/`opus_model`/`sonnet_model`/`haiku_model` vervangt door
   de exacte modelnaam, en `max_context_tokens` op 1.000.000 zet.

> **[ONBEVESTIGD] — houdbaarheid.** Een gratis frontier-model op OpenRouter is
> per definitie een promotieactie; de bron zelf verwacht dat `ox-alpha` na de
> introductieperiode betaald wordt. Alternatieve gratis modellen (Poolside,
> Gemma) liepen bij de bronmaker al tegen een HTTP 429 aan
> ("exceeded free models per day usage"), met een eis van $10 aan credits om
> 1.000 gratis verzoeken per dag te ontgrendelen. Voor gebruik bij SCI eerst
> verifiëren of `ox-alpha` (of een opvolger) nog gratis is — deze paragraaf
> raakt gedateerd door het karakter van het aanbod, niet door een fout erin.

Dit raakt `mcp-versus-custom-tools.md` §1: de kostenkolom "per token; grote
context wordt een maandrekening" geldt hier tijdelijk niet, wat de
kosten-batenafweging voor experimenteren met AI-tools verschuift zolang het
aanbod bestaat.

## 2. Erik's browser-based WPF Form Builder

Een browser-applicatie die het traditionele WPF-ontwikkelproces voor
pyRevit-formulieren vervangt
(`raw/2026-08-31-uitgebreide-transcriptie-ai-bim-revit-automation-.md` §4). De
skill `pyrevit-codestijl` beschrijft de WPF-dialoogopbouw met een inline
XAML-string als SCI-conventie; deze tool is een extern hulpmiddel dat het
handwerk daaromheen automatiseert, geen vervanging van die conventie.

Het probleem dat de tool oplost: Visual Studio genereert WPF-boilerplate in
C#, die je vervolgens handmatig naar Python moet vertalen, met property- en
event-namen die je synchroon moet houden tussen `.py` en `.xaml`. .NET is
bovendien niet gebouwd voor de browser, dus een live-preview leek onmogelijk.

Functionaliteit:

- **Live previewer.** XAML plakken toont direct een interactieve preview;
  schaal past zich aan en elementen lichten op bij hover.
- **Eigenschappen en events in de UI.** Een event als `click = UI_Click`
  genereert direct de bijbehorende Python-code.
- **Kant-en-klare Python-boilerplate** in een apart tabblad.
- **Sync-knop.** Wijst naar een pyRevit-ontwikkelmap (bijvoorbeeld
  `dev_panel`), maakt de push-buttonmap aan met `script.py`, `bundle.yaml` of
  `script.xaml` en een `icon.png`, en schrijft wijzigingen direct terug naar
  schijf. Een `Reload` in Revit toont het resultaat.
- **Automatische back-up vóór overschrijven.** Wordt lokaal handmatig
  geavanceerde logica aan `script.py` toegevoegd, dan waarschuwt de tool bij
  sync dat het bestand lokaal gewijzigd is, met de keuze om alleen de XAML te
  syncen of toch te overschrijven — in dat laatste geval altijd eerst een
  back-up van het lokale bestand.

[ONBEVESTIGD] Toegang: de bron noemt de tool exclusief beschikbaar voor
studenten van Erik Frits' 90-dagen-training, samen met een Brand Key
Generator, een pyRevit Debugger en een Revit API-documentatie-app. Geen
publieke naam of URL genoemd; niet te controleren of hij los verkrijgbaar is.
