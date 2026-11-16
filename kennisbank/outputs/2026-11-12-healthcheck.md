---
type: health check
datum: 2026-11-12
vorige: outputs/2026-09-17-healthcheck.md
bronnen:
  - alle 28 artikelen in wiki/, integraal gelezen
  - kennisbank/CLAUDE.md, stijlgids.md, index.md, memory.md
  - raw/ (8 bronbestanden, sectiekoppen naast de wiki gelegd)
  - outputs/ van 2026-10-07 t/m 2026-11-10
  - "skillbronnen in Snetselaar_BIM (grep op sci-bim-context, revit-api-docs, pyrevit-codestijl), 2026-11-12"
  - "memory pyrevit-standaardversie (Albert 7.0.0 sinds 04-11-2026), sci-staalsoort-structuralclass (S235 1.2, 14-10-2026)"
  - "zoek_revit_api op BuiltInParameter, lid REBAR_ en CLEAR_COVER, versie 2024,2027 (builds 24.3.60.12 en 27.2.0.39), 2026-11-12"
  - "scripts: kruisverwijzingen, frontmatter, bron- en coderegelverwijzingen, stijlwoorden, em-dashes"
---

# Health check 2026-11-12

- **Artikelen:** 28, alle op `concept`; geen ouder dan 90 dagen (oudste 78 dagen).
- **Bevindingen:** 43. Tegenstrijdigheden 6, claims zonder of met verlopen bron 6, gaten 8, veroudering 10, stijl 5, kruisverwijzingen 6, coverage 2.
- **Ernstigste:** de skill `sci-bim-context` en `mcp-revit-koppeling.md` noemen de Lees-MCP alleen-lezen, terwijl hij sinds 21-09-2026 kan schrijven (`lees-mcp-koppeling.md` §5).
- **Tweede:** `revit-2027-runtime-en-api-wijzigingen.md` §4 zegt "pyRevit 7.0 niet bevestigd, niet op bouwen"; Albert draait 7.0.0 sinds 04-11-2026.
- **Uitgevoerd tijdens de check:** de open 2024/2027-spotcheck van `rebar-api-parameters.md` §6. Alle acht namen bestaan in beide versies; 2027 hernoemt en schrapt wel andere `REBAR_*`-leden.

Niet gecontroleerd: of de URL's in de artikelen nog laden (geen argument `web`).

---

## 1. Tegenstrijdigheden

**T1. Lees-MCP schrijft wel. Ernst: hoog.**
- `mcp-revit-koppeling.md` §4 r. 263-264: "De Lees-MCP kan bewust niet schrijven." §7 r. 486: "Nonica kan ook schrijven via `set_*`-tools; de Lees-MCP niet."
- `lees-mcp-koppeling.md` §2 en §5: drie standen, schrijftools `zet_parameter`, `wijzig_type`, `verplaats_elementen` sinds knop 2.0 (21-09-2026), getest met 175 verzoeken.
- Skillbron `Snetselaar_BIM/sci-bim-context/references/template-en-mcp.md` r. 52 ("eigen alleen-lezen koppeling") en r. 94 ("De Lees-MCP kan niet ...") zeggen hetzelfde als het verouderde artikel.
- Keuze: `lees-mcp-koppeling.md`. Die bron is nieuwer en gemeten in een echt model. Volgens `CLAUDE.md` §3 regel 2 hoort er in `lees-mcp-koppeling.md` een conflictblok tot de skill is bijgewerkt en geüpload. Dat blok ontbreekt.

**T2. pyRevit 7.0 bestaat. Ernst: hoog.**
- `revit-2027-runtime-en-api-wijzigingen.md` §4 r. 94-97: "pyRevit 7.0 is niet bevestigd ... Niet op bouwen."
- `zoek-revit-api.md` r. 31: het idee komt uit "de agent-runtime van pyRevit 7.0 (`lookup_revit_api`, uitgebracht 6 oktober 2026)".
- Memory `pyrevit-standaardversie`: Albert op 7.0.0 sinds 04-11-2026, het lint statisch getoetst tegen 7.0, de modelleurs op 6.5.5.
- Keuze: `zoek-revit-api.md` plus de memory. §4 van het 2027-artikel is achterhaald (het is geschreven op 27-10, vóór de update).

**T3. Outputvenster: IE11 of WebView2. Ernst: middel.**
- `revit-2027-runtime-en-api-wijzigingen.md` §5 r. 108-110: het pyRevit-outputvenster is WinForms WebBrowser met IE11-gedrag, "dus geen WebView2".
- Memory `pyrevit-standaardversie`: in 7.0 is het outputvenster WebView2.
- Keuze: beide waar, per versie. Het artikel moet de versie noemen: IE11 op 6.5.5, WebView2 op 7.0. Bouw IE11-veilig zolang het team op 6.5.5 zit.

**T4. S235 en `Structural Material`. Ernst: middel.**
- `ifc-export-staalgewicht.md` §4 route 3 r. 114-116: "Botst met de afspraak dat S235 `Structural Material` bewust leeg laat vanwege de IFC-export (skill `sci-bim-context`)."
- Een grep op de skillbron `sci-bim-context` vindt geen S235-regel. Volgens memory `sci-staalsoort-structuralclass` vult S235 sinds versie 1.2 (14-10-2026) wél `Structural Material` = `SCI_Staal_S235`.
- Keuze: de memory. De zin schrijft de skill iets toe wat er niet in staat, en de afspraak is inmiddels veranderd. Route 3 botst daardoor minder dan het artikel zegt.

**T5. Autodesk Public MCP Server. Ernst: laag, al bekend.**
- `mcp-versus-custom-tools.md` §4 ("ingebouwd", "veel elementen niet bewerkbaar") tegenover `externe-bronnen-ronde-okt2026.md` §4 ("aparte add-on, alleen-lezen, 7 tools").
- Beide markeren het al als `[ONBEVESTIGD]`. Op te lossen door de Autodesk-blog van 17-06-2026 te lezen (vraagt `web`).

**T6. .NET 10 voor 2025/2026. Ernst: middel.**
- `revit-2027-runtime-en-api-wijzigingen.md` §1 (gemarkeerd als mogelijk conflict) tegenover skill `revit-api-docs` §5 r. 79 (2025 en 2026: .NET 8).
- De datum in het artikel is inmiddels verstreken: "Microsoft stopt de support voor .NET 8 op 10-11-2026."
- Keuze: de skill houden, maar de stand nu opzoeken (vraagt `web`).

## 2. Claims zonder bron, of met een bron die niet meer klopt

| # | Waar | Wat | Ernst |
|---|---|---|---|
| B1 | `appartementdata-genereren-met-ai.md` r. 110-111 | "hier met een concreet getal erbij". Er volgt geen getal, en de bron noemt er volgens dit artikel ook geen. | middel |
| B2 | `appartementdata-genereren-met-ai.md` r. 58 en r. 62 | "handmatig revisietrajecten tekenen" is vermoedelijk een vertaalfout (het gaat om looproutes). "dezelfde soort systematische meetfout als de ~45 cm-marge zelf" vergelijkt de marge met zichzelf. | laag |
| B3 | `ai-tools-voor-pyrevit-ontwikkeling.md` §1 r. 37-40 | de sleutels `default_model`, `opus_model`, `max_context_tokens` in `.claude/settings.json` staan alleen in de transcriptie en zijn geen bekende Claude Code-instellingen. Niet als `[ONBEVESTIGD]` gemarkeerd. | middel |
| B4 | `ai-brain-kennisorganisatie-pyrevit.md` r. 64 | de biografie van Karpathy ("voormalig hoofd AI bij Tesla, bedenker van de term vibe coding") staat er zonder bron. | laag |
| B5 | `mcp-eigen-tools-toevoegen.md` §1 r. 96 | het codevoorbeeld gebruikt `DB.ElementId(int(id_str))`. Volgens `zoek-revit-api.md` §5 bestaat de ctor `ElementId(Int32)` niet meer in 2026/2027. Het artikel waarschuwt alleen voor `IntegerValue`. | middel |
| B6 | `bluebeam-sets-revisies-automatisch.md` bron r. 10 | `...\01_SCI.tab\Printen.panel\Plot.pushbutton\script.py:1080-1108, 1274-1305, 1386-1407`. Volgens memory staat Plot nu in `Tools.panel` en is hij op 2.22, dus de regelnummers van 2.15 kloppen niet meer. | middel |

Bronbestanden: elk `raw/`- en `outputs/`-bestand waarnaar verwezen wordt, bestaat nog. De regelverwijzingen naar `main.py`, `status.py`, `views.py` en `utils.py` kloppen op 12-11-2026. De verwijzingen naar `revit_mcp/code_execution.py` wijzen naar een verwijderd bestand. Ze staan al expliciet als historisch gemarkeerd; noem er commit `d695d83~1` bij, dan blijven ze te volgen.

## 3. Gaten

| # | Gat | Waarom het telt |
|---|---|---|
| G1 | **De SCI-Viewer heeft geen artikel.** Er zijn alleen memory-notities en twee outputs (audit 3.23 en opvolging, 10-11-2026). | Het is een van de grootste lopende producten: de viewer leest Technosoft, SCIA, RVT en IFC rechtstreeks, met eigen formaatkennis die nu alleen in de memory staat. |
| G2 | `ifc-export-staalgewicht.md` §4 zegt "Geen van deze routes is uitgevoerd". Het stappenplan in `outputs/2026-10-12-stappenplan-staalgewicht-ifc.md` is niet teruggekoppeld. | Of het stappenplan is uitgevoerd, staat nergens. |
| G3 | `model-vergelijken-fase0-ifc-rvt-link.md` beschrijft alleen fase 0. De knop staat volgens memory op 1.4 (IFC-ruis van 1017 naar 168). | De uitkomst van de bouw ontbreekt. |
| G4 | `revit-robot-interoperabiliteit.md` en de index vragen of SCI Robot gebruikt. | Waarschijnlijk te beantwoorden: SCI rekent met Technosoft en SCIA (memory `rww-viewer-technosoft`, `externe-bronnen-ronde-okt2026.md` §3). Laat de gebruiker dat bevestigen; daarna kan het artikel dun blijven. |
| G5 | `rebar-documentatie-en-staten.md` §3 en de index: "Bestaat er een SCI-tagfamilie voor wapening?" In `externe-repos-kandidaten-en-afgevallen.md` §1 staat de 2D-wapeningstagger nog als openstaand. | Wapening Taggen 1.4 bestaat sinds 28-10-2026 (memory `wapening-taggen-uit-dynamo`); de tagfamilie is daar bekend. |
| G6 | `nlrs-en-bim-standaarden.md` §1: "Of SCI de USO gebruikt." | De knoppen Sparingen controle/fix (memory `sparingen-controle-fix-tool`, codes 21.21 en 22.21) zijn een aanknopingspunt. |
| G7 | Annotatie-autopilot, Plot/printen en de Ontwikkelstraat met changelogs staan alleen in memory of in de projectskill. | Valt binnen `CLAUDE.md` §1 (lint en werkafspraken), maar er is geen artikel. Lage prioriteit zolang een skill of memory het draagt. |
| G8 | Domein uit `CLAUDE.md` §1 zonder artikel en zonder skill: **DWG-export**. | Nergens beschreven. |

Nog open uit de index, ongewijzigd: waar `Level.ProjectElevation` vanaf meet, de placeholders in `SCI_template_2025.rte`, Revu Max en `ScriptEngine.exe`, 7850 kg/m³ in NEN-EN 1993-1-1, de .NET 10-scan, WebView2 per versie, `ifcdiff`, Partition-conventie en de dekkingswaarden 0/20/40 mm.

## 4. Veroudering

Geen artikel is ouder dan 90 dagen. Alle 28 staan op `concept`; `rebar-3d-modelleren.md` en `revit-robot-interoperabiliteit.md` zijn sinds 26-08 (78 dagen) niet geraakt. Inhoudelijk verschoven:

| # | Waar | Wat |
|---|---|---|
| V1 | `rebar-api-parameters.md` §0 en §6, index | De 2024/2027-spotcheck heet daar onuitvoerbaar. Met `zoek_revit_api` (sinds 08-10) kan hij wel, en hij is in deze check gedaan: alle acht namen en de zes `CLEAR_COVER*`-leden bestaan in 2024 en 2027 met dezelfde waarde. Nieuw in 2027: `REBAR_ELEM_HOOK_START/END_ORIENT` heet `REBAR_ELEM_TERMINATION_START/END_ORIENT` (zelfde waarde -1017007/-1017009), `REBAR_HOOK_ROTATION_AT_*` heet `REBAR_TERMINATION_ROTATION_AT_*`, en `REBAR_SHAPE_HOOK_START/END_TYPE`, `REBAR_SHAPE_ENDTREATMENT_START/END_TYPE` en `REBAR_FREE_FORM_HOOK_*_PLANE_ANGLE` zijn weg. `REBAR_CONSTRAINTS_STATUS` bestaat in 2027 (raakt de versietabel van `rebar-3d-modelleren.md` §1). 2025 en 2026 zijn niet bekeken, dus in welk jaar de hernoeming kwam, is open. |
| V2 | `bluebeam-sets-revisies-automatisch.md` | De stand is die van 17-09 tot 25-09: Plot 2.15, ps1 1.6, "testscript, nog niet uitgerold". Memory noemt Plot 2.22. |
| V3 | `mcp-revit-koppeling.md` §5 punt 7 | "Gemeten versies: 6.5.5 op de werkplek van AWO en 6.1.0 bij S-WUL1N." Nu: Albert 7.0.0, het team 6.5.5 als minimum (memory `pyrevit-standaardversie`, `pyrevit-versiecheck`). |
| V4 | `modeless-venster-persistente-engine.md` | Het risico van 6.1.0 is kleiner geworden door de standaard 6.5.5 en de versiecheck in `startup.py` (memory `pyrevit-versiecheck`). Het artikel noemt die maatregel niet. |
| V5 | `ai-tools-voor-pyrevit-ontwikkeling.md` §1 | De route Claude Code via OpenRouter is sinds de overstap naar Claude Team (12-11-2026, Premium-stoel) niet meer relevant voor SCI. |
| V6 | `mcp-versus-custom-tools.md` §1 | De kostenkolom "per token; grote context wordt een maandrekening" heeft geen datum en geldt niet meer gelijk onder een Team-abonnement. |
| V7 | `externe-repos-kandidaten-en-afgevallen.md` §1 | De lens "Openstaand bij SCI" (september) noemt 2D-wapening taggen en ModelCheck als open. Beide zijn inmiddels gebouwd. |
| V8 | `lees-mcp-koppeling.md` r. 34-35 | De intro zegt "Stand 2026-09-21: knop MCP, versie 2.1", terwijl de tabel in §7 tot 2.5 loopt. De index noemt nog 50 tools en de versies 1.0-2.4. |
| V9 | `index.md` | "Alle 22 artikelen staan op concept (geteld 2026-09-17)": het zijn er 28. In deze check rechtgezet. |
| V10 | `revit-2027-runtime-en-api-wijzigingen.md` §1 | De datum 10-11-2026 (einde .NET 8-support) is verstreken. Zie T6. |

## 5. Stijl

| # | Regel | Waar | Wat |
|---|---|---|---|
| S1 | (corruptie) | `bluebeam-sets-revisies-automatisch.md` r. 241, `lees-mcp-koppeling.md` r. 200 | `\t` is een tab geworden: `RnD.extension<TAB>est_matrix.md` en `RnD.extension<TAB>ools\check_api.ps1`. Hetzelfde mechanisme als de memory `bash-heredoc-backslash`. |
| S2 | 16 | `ifc-import-verboden-tekens-in-namen.md` §1, §3, §4, §5; `modeless-venster-persistente-engine.md` alle zes de koppen; `appartementdata-genereren-met-ai.md` §2 | Koppen zijn zinnen ("Het symptoom bedriegt", "De keerzijde blijft", "Dat een vlag in bundle.yaml staat, wil niet zeggen dat hij aankomt"). |
| S3 | 9 | `externe-patronen-revit-repos.md` (8 alinea's), `rebar-api-parameters.md` (4), `mcp-revit-koppeling.md` (3), `nlrs-en-bim-standaarden.md` (3) | Meer dan één em-dash per alinea. |
| S4 | `CLAUDE.md` §5 | `mcp-revit-koppeling.md` 486, `externe-patronen-revit-repos.md` 381, `lees-mcp-koppeling.md` 335, `rebar-api-parameters.md` 299, `bluebeam-sets-revisies-automatisch.md` 279, plus drie artikelen net boven de 200 | Over de grens van 200 regels. De splitsing van `mcp-revit-koppeling.md` (keten tegenover historiek) staat al open sinds 17-09. |
| S5 | 19 | `mcp-revit-koppeling.md` | Veel bold voor nadruk ("**Gemeten 2026-08-28 op de werkplek:**", "**Op 2026-08-28 ingesteld en geactiveerd.**"). |

Regel 6: geen treffers. "naadloos" in `outputs/2026-11-05-ontwerptools-staaltabellen-controle.md` r. 30 is de vakterm voor een buis (KW), geen vulwoord. Regel 7: geen treffers.

## 6. Kruisverwijzingen

| # | Soort | Waar |
|---|---|---|
| K1 | eenzijdig | `model-vergelijken-fase0-ifc-rvt-link.md` → `ifc-import-verboden-tekens-in-namen.md` (geen link terug) |
| K2 | eenzijdig | `model-vergelijken-fase0-ifc-rvt-link.md` → `lees-mcp-koppeling.md` |
| K3 | eenzijdig | `zoek-revit-api.md` → `externe-patronen-revit-repos.md` |
| K4 | wees | `bluebeam-sets-revisies-automatisch.md` en `structural-connection-blijft-hangen-na-kopie.md` (beide bekend, geen natuurlijke partner) |
| K5 | kapotte sectieverwijzing | `modeless-venster-persistente-engine.md` r. 53 verwijst voor de AppDomain-data naar `lees-mcp-koppeling.md` §7. §7 is de versiegeschiedenis; de AppDomain-data staat in §2 en §10. |
| K6 | ontbrekend verband | `revit-robot-interoperabiliteit.md` noemt het rekenmodel, maar linkt niet naar `externe-bronnen-ronde-okt2026.md` §3 (SCIA, SAF, Technosoft). |

Er zijn geen `verwant:`-doelen die niet bestaan.

## 7. Coverage

Alle acht bronbestanden in `raw/` staan in `memory.md`. Twee daarvan zijn bewust niet verwerkt (buiten het bereik), dus er is niets onverwerkt.

- **C1.** `raw/2026-08-27_revit_mcp_bronnen_transcripties.md`: §1 (de organisatie-analogie van Erik Frits) en het voorbeeld in §7 (sheetnamen naar het Frans vertalen via `execute_revit_code`) zijn nergens terug te vinden. De rest van §1 en §2 overlapt met wat `mcp-revit-koppeling.md` §1 uit de repo zelf haalt. Ernst: laag.
- **C2.** De terugkoppellus (`CLAUDE.md` §7) is sinds 17-09 niet gebruikt. `outputs/2026-10-12-stappenplan-staalgewicht-ifc.md` en de twee SCI-Viewer-outputs van 10-11 dragen kennis die in geen artikel staat (G1, G2). Alleen de gebruiker kan beslissen of ze standhielden.

`raw/2026-10-27-...` (A1-A4, B-F, volgorde), `raw/2026-08-31-...` (§1-§7), de rebar-dump (§1-§5) en de bronnen-dump (§1-§5) zijn volledig terug te vinden.

---

## Actieplan

Op volgorde van belang. **C** = kan Claude uitvoeren, **G** = vraagt een handeling of besluit van de gebruiker.

1. **C** — In `mcp-revit-koppeling.md` §4 r. 263-264 en §7 r. 486 "kan niet schrijven" vervangen door: schrijft sinds knop 2.0 in stand *Lezen en schrijven*, altijd eerst `dry_run`, zie `lees-mcp-koppeling.md` §5.
2. **C + G** — In de skillbron `sci-bim-context/references/template-en-mcp.md` r. 52 en r. 94 "alleen-lezen" en "kan niet schrijven" bijwerken, inpakken met `pack_skill.ps1`. **G**: uploaden naar het Team-account, daarna `skill_uploads.ps1 -Mark`. Tot de upload een conflictblok in `lees-mcp-koppeling.md`.
3. **C** — `revit-2027-runtime-en-api-wijzigingen.md` §4 en §5 herschrijven: pyRevit 7.0.0 bestaat (Albert sinds 04-11, het team op 6.5.5); het outputvenster is WebView2 in 7.0 en IE11 in 6.5.5.
4. **C** — De uitkomst van de spotcheck uit V1 in `rebar-api-parameters.md` §0 en §6 zetten, met een nieuwe sectie "2027-hernoemingen" (TERMINATION en de verdwenen leden). Daarna met `zoek_revit_api` versie 2025 en 2026 bekijken voor het jaar van de hernoeming, en de rij `REBAR_CONSTRAINTS_STATUS` toevoegen aan `rebar-3d-modelleren.md` §1.
5. **C** — `ifc-export-staalgewicht.md` §4 route 3: de S235-zin corrigeren (S235 1.2 vult sinds 14-10 `Structural Material`; de skill bevat die regel niet) en verwijzen naar `outputs/2026-10-12-stappenplan-staalgewicht-ifc.md`.
6. **C** — De twee tab-corrupties uit S1 herstellen.
7. **C** — `modeless-venster-persistente-engine.md` r. 53: §7 wordt §2 en §10. De drie eenzijdige links uit K1-K3 laten terugwijzen, en in `revit-robot-interoperabiliteit.md` een link naar `externe-bronnen-ronde-okt2026.md` §3 leggen.
8. **C** — `appartementdata-genereren-met-ai.md` r. 58, r. 62 en r. 110-111 rechtzetten (B1, B2). In `ai-tools-voor-pyrevit-ontwikkeling.md` §1 de settings-sleutels als `[ONBEVESTIGD]` markeren en een gedateerde noot over het Team-account toevoegen (B3, V5).
9. **C** — `mcp-eigen-tools-toevoegen.md` r. 96: een noot dat `ElementId(Int32)` in 2026+ niet bestaat, met `zoek-revit-api.md` §5 als bron.
10. **G** — Bevestigen dat SCI geen Robot gebruikt en rekent met Technosoft en SCIA. **C** daarna: de open vraag sluiten in `revit-robot-interoperabiliteit.md` en de index.
11. **G** — Beslissen of de SCI-Viewer een wiki-artikel krijgt. Zo ja: de twee audit-outputs van 10-11 (en eventueel een eigen notitie) naar `raw/` kopiëren en `/kb-verwerk` draaien.
12. **G** — Laten weten of het stappenplan staalgewicht van 12-10 is uitgevoerd. Zo ja, terugkoppelen via `raw/`.
13. **C** — In `bluebeam-sets-revisies-automatisch.md` en `lees-mcp-koppeling.md` de stand bijwerken (Plot 2.22, uitrolstatus; knop en server 2.5), de bronregel van Plot corrigeren (B6, V2, V8). **G**: bevestigen of Set bijwerken is uitgerold.
14. **C** — In `mcp-revit-koppeling.md` §5 punt 7 en in `modeless-venster-persistente-engine.md` de pyRevit-stand en de versiecheck bijwerken (V3, V4).
15. **C** — De koppen uit S2 omzetten naar onderwerpen.
16. **C** — `mcp-revit-koppeling.md` splitsen in de keten en de historiek van `execute_revit_code` en de skillconflicten. Overwegen voor `externe-patronen-revit-repos.md`.
17. **C met `web`** — De Autodesk-blog over de Public MCP Server lezen (T5) en de stand van .NET 10 voor 2025/2026 opzoeken (T6, V10).
18. **G in Revit** — De blijvende metingen: `Level.ProjectElevation` in een model met een verhoogd projectbasispunt, en de placeholders in `SCI_template_2025.rte`.
