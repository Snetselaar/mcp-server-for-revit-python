# Index

Kaart van `wiki/`. Bijgewerkt door `/kb-verwerk` en `/kb-check`.

**Stand:** 14 artikelen, 2026-08-31. Laatste health check:
[2026-08-31](outputs/2026-08-31-healthcheck.md), driemaal gedraaid dezelfde
dag — eerste run vond bevindingen (actieplan uitgevoerd), herhaalde run vond
vier gemiste propagaties uit dat actieplan (inmiddels ook gerepareerd), de
derde run vond niets nieuws meer. Daarvoor:
[2026-08-28](outputs/2026-08-28-healthcheck.md) (0 kapotte kruisverwijzingen,
coverage volledig, geen stijlovertredingen), en
[2026-08-25](outputs/2026-08-25-healthcheck.md) met een
[opvolging van 2026-08-26](outputs/2026-08-25-healthcheck.md#opvolging-2026-08-26).

---

## Wapening

| Artikel | Status | Bijgewerkt | Waarover |
|---|---|---|---|
| [rebar-3d-modelleren.md](wiki/rebar-3d-modelleren.md) | concept | 2026-08-26 | Kolom-, balk- en vloerwapening, free form, splices — met een versietabel 2024–2027 |
| [rebar-documentatie-en-staten.md](wiki/rebar-documentatie-en-staten.md) | concept | 2026-08-28 | Partitions, filters, tags, Multi-Rebar Annotation, buigstaten en Bending Details |
| [rebar-api-parameters.md](wiki/rebar-api-parameters.md) | concept | 2026-08-28 | De acht BuiltInParameters, live geverifieerd op Revit 2025: alle namen bestaan, alleen CLEAR_COVER's beschrijving is fout |

## MCP en gereedschap

| Artikel | Status | Bijgewerkt | Waarover |
|---|---|---|---|
| [mcp-revit-koppeling.md](wiki/mcp-revit-koppeling.md) | concept | 2026-08-31 | De keten Claude → MCP → pyRevit Routes → Revit API: opbouw, tools, endpoints en faalpunten (execute_revit_code op 31-08 verwijderd) |
| [mcp-eigen-tools-toevoegen.md](wiki/mcp-eigen-tools-toevoegen.md) | concept | 2026-08-31 | Een twintigste tool bouwen: route-module, tool-module, twee registraties en de MCP Inspector |
| [mcp-versus-custom-tools.md](wiki/mcp-versus-custom-tools.md) | concept | 2026-08-31 | Wanneer de AI-brug en wanneer een gewone knop; risico's, het Erik Frits-advies (nu met een tweede onafhankelijke bron: Gavin Nicholls) en de Autodesk 2027-server |
| [revit-bronnen-en-communities.md](wiki/revit-bronnen-en-communities.md) | concept | 2026-08-31 | Waar Revit-kennis vandaan komt: API-docs, pyRevit, IFC, kanalen, het P.R.O.C.E.S.S.-kader |
| [ai-tools-voor-pyrevit-ontwikkeling.md](wiki/ai-tools-voor-pyrevit-ontwikkeling.md) | concept | 2026-08-31 | Gratis Claude Code via OpenRouter (Ox Alpha) en Erik Frits' browser-based WPF Form Builder |
| [ai-brain-kennisorganisatie-pyrevit.md](wiki/ai-brain-kennisorganisatie-pyrevit.md) | concept | 2026-08-31 | Erik Frits' raw/wiki/skills-kennisdatabase voor de Revit API, gebaseerd op Karpathy's LLM Wiki-concept — vrijwel identieke opzet als deze kennisbank |
| [appartementdata-genereren-met-ai.md](wiki/appartementdata-genereren-met-ai.md) | concept | 2026-08-31 | Claude Code + pyRevit MCP: afstanden, ramen, buren en plafondhoogte per appartement berekenen, wegschrijven naar Area-parameters, en er een vaste `Unit Data`-knop van maken |

## Tools en plugins van derden

| Artikel | Status | Bijgewerkt | Waarover |
|---|---|---|---|
| [vyssuals-datavisualisatie.md](wiki/vyssuals-datavisualisatie.md) | concept | 2026-08-31 | Kleurgebaseerde data-analyse van Revit-modellen in de browser, met een eigen MCP-koppeling naar Claude Code |
| [batch-upgrade-en-conversie-revit-bestanden.md](wiki/batch-upgrade-en-conversie-revit-bestanden.md) | concept | 2026-08-31 | BIM Pure Plugin v0.4: RVT/RFA batchgewijs upgraden en family-eenheden converteren |

## Interoperabiliteit en standaarden

| Artikel | Status | Bijgewerkt | Waarover |
|---|---|---|---|
| [revit-robot-interoperabiliteit.md](wiki/revit-robot-interoperabiliteit.md) | concept | 2026-08-26 | De bidirectionele link met Robot, en de Pinned-Pinned-valkuil bij export |
| [nlrs-en-bim-standaarden.md](wiki/nlrs-en-bim-standaarden.md) | concept | 2026-08-26 | Alleen wat `sci-bim-context` niet dekt: USO, family guides, BIM Basis ILS, BEP/CDE |

## Revit API en versies

_Gedekt door de skills `revit-api-docs` en `pyrevit-codestijl`. Wat die niet
dekken staat in `rebar-api-parameters.md`._

## SCI-conventies en projecten

_Gedekt door de skill `sci-bim-context`._

## Scripts en het SCI-lint

_Gedekt door de skills `bimtools-promotie`, `bimtools-logging` en
`bimtools-actielijst`._

---

## Open vragen en gaten

Gevuld door `/kb-check` en `/kb-verwerk`. Elk punt is een kandidaat voor een
`/kb-vraag` of voor een dump in `raw/`.

### Vragen aan de skills — hier wijkt de kennisbank af van wat vastligt

- **`sci-bim-context` §C, de `execute_revit_code`-kwestie — opgelost (geüpload
  2026-08-31).** De `execute_revit_code`-rij is verwijderd uit
  `Snetselaar_BIM/sci-bim-context/references/template-en-mcp.md` §C, "twintig
  stuks" is "negentien stuks" geworden, de tekst herschreven met een
  verwijzing naar `wiki/mcp-revit-koppeling.md` §4 en de Nonica-connector als
  vervangende leesroute. Ingepakt met `pack_skill.ps1`, geüpload naar
  claude.ai en vastgelegd met `skill_uploads.ps1 -Mark sci-bim-context`
  (sha256 `97ec9542…`, commit `921994f`, 2026-08-31). Skill-in-gebruik en wiki
  lopen niet langer uiteen; het conflictblok in `wiki/mcp-revit-koppeling.md`
  §6 is daarmee historisch. Gevonden bij de health check van 2026-08-31
  (`outputs/2026-08-31-healthcheck.md` bevinding 1).
- **`sci-bim-context` §C, de acht-toolnamen-kwestie, is opgelost (geüpload 2026-08-28).** De acht toolnamen
  zijn vervangen door de twintig echte, samen met de repo-naam, de poort en de
  startwijze, in de skillbron
  `Snetselaar_BIM/sci-bim-context/references/template-en-mcp.md`. De skill is op
  2026-08-28 naar claude.ai geüpload en vastgelegd met `skill_uploads.ps1 -Mark`
  (sha256 `6513f443…`, commit `aec356d`). Skill-in-gebruik en wiki lopen niet
  langer uiteen; het conflictblok in `wiki/mcp-revit-koppeling.md` §6 is daarmee
  historisch. Toelichting in
  [outputs/2026-08-28-sci-bim-context-toolstabel.md](outputs/2026-08-28-sci-bim-context-toolstabel.md).
- **Diameterfilters bestaan al.** De bronnen-dump stelt voor filters op
  wapeningdiameter te bouwen; de SCI-template heeft ø6 t/m ø40 al. Onbekend is of
  dat stelsel ook `Structural Fabric Reinforcement` afdekt of alleen staven. Zie
  `wiki/rebar-documentatie-en-staten.md` §2.
- **Cadix-template versus SCI-template.** De dump beveelt Cadix aan; SCI heeft een
  eigen template. Openstaand is of onze template een sluitende set Rebar Shapes,
  Bars én Hooks bevat. Zie `wiki/rebar-3d-modelleren.md` §2.
- **De 2024-typewijziging staat niet in de cheatsheet.** In Revit 2024 werd
  `BuiltInParameter` van 32- naar 64-bit opgehoogd. Dat ontbreekt in de
  migratie-cheatsheet in `sci-bim-context` (`references/technische-issues.md` §A).
  Zie `wiki/rebar-api-parameters.md` §4.

### Uit te zoeken in Revit of op W:

- **De acht BuiltInParameters — bestaan afgehandeld (2026-08-28).** Alle acht
  namen gaven `True` op `Enum.IsDefined` in de live Revit 2025-API via het
  Routes-endpoint. `REBAR_SHAPE_IMAGE` blijkt tóch een BuiltInParameter. Rest
  open: de betekenis (drie beschrijvingen) en een spot-check op 2024/2027. Zie
  `wiki/rebar-api-parameters.md` §0 en §6.
- **Zijn 0/20/40 mm de SCI-dekkingswaarden** of generieke voorbeelden uit de bron?
- **Heeft SCI een conventie voor de Partition-parameter?** `sci-bim-context`
  beschrijft `hoofd_map` en `sub_map`, maar zegt niets over Partition.
- **Bestaat er een vastgelegde SCI-tagfamilie voor wapening?** Voor kolommen wel
  (`NLRS_28_TAG-SCOL_kolom-dec_SCI`), voor wapening onbekend.
- **Volgen de IFC-exportscripts de BIM Basis ILS-stappen?** Een export die
  technisch slaagt maar niet ILS-conform is, komt terug van de ontvanger.
- **Gebruikt SCI Robot Structural Analysis?** Staat niet in de tech stack. Zo nee,
  dan kan `wiki/revit-robot-interoperabiliteit.md` dun blijven.
- **Blijft de Routes Server aan tussen Revit-sessies?** De README spreekt
  zichzelf bijna tegen. Op 2026-08-26 stond `enabled = true` in `[routes]` van
  `pyRevit_config.ini`, dus de instelling wordt bewaard; of dat een herstart
  overleeft is niet nagemeten.
- **Routes-binding — opgelost en geverifieerd (2026-08-28).** De live socket
  stond op `0.0.0.0:48884`; `host = 127.0.0.1` gezet met
  `pyrevit configs "routes:host" 127.0.0.1`. Na een Revit-herstart bindt de socket
  op `127.0.0.1:48884` en werkt `/status/` — geverifieerd. De pyRevit-reload liep
  vast (bekend), de herstart was de weg. Zie `wiki/mcp-revit-koppeling.md` §2. (Het
  tutorial-commando `--host` bleek niet te bestaan in deze pyRevit.)
- **Draait er ergens pyRevit 6.5.3?** Die versie zou een Routes-bug hebben;
  6.4.0 is aangeraden. Onbevestigd, geen issuenummer, versie niet gemeten. Zie
  `wiki/mcp-revit-koppeling.md` §5 punt 7.
- **Welke Revit-versies draait SCI in productie?** Op 2026-08-28 draaide de
  werkplek **Revit 2025**. Of de rest van het bereik 2024/2026/2027 in productie
  is, bepaalt of de Autodesk 2027 MCP-server in beeld komt. Zie
  `wiki/mcp-versus-custom-tools.md` §4.

### Uit de health check van 2026-08-31 — alle vijf punten afgehandeld

- Vervangende leesroute vastgelegd: de **Nonica-connector**, bevestigd door de
  gebruiker op 2026-08-31. Zie `wiki/mcp-revit-koppeling.md` §4.
  [ONBEVESTIGD] blijft of die route ook kan schrijven.
- Sectie 6 van de 2026-08-31-bron is alsnog verwerkt: nieuw artikel
  `wiki/appartementdata-genereren-met-ai.md`.
- `mcp-versus-custom-tools.md` §3 gecorrigeerd naar "tweede SCI-werkafspraak".
- Alle zes eenzijdige kruisverwijzingen gerepareerd: twee ongegronde links uit
  `ai-brain-kennisorganisatie-pyrevit.md` verwijderd, de overige vier
  gereciproceerd.
- `rebar-api-parameters.md` §0 en §6 gemarkeerd met een gedateerde noot dat de
  live-`Enum.IsDefined`-methode sinds 2026-08-31 niet meer via deze repo
  beschikbaar is.

### Uit de herhaalde health check van 2026-08-31 — vier gemiste propagaties, alle vier afgehandeld

Dezelfde dag opnieuw gecontroleerd na uitvoering van het actieplan hierboven,
en dezelfde dag alsnog gerepareerd. Steeds hetzelfde patroon: het feit was
elders al gecorrigeerd, maar niet overal doorgevoerd. Zie
`outputs/2026-08-31-healthcheck.md`, sectie "Herhaalde run".

- `mcp-versus-custom-tools.md` sprak zichzelf tegen (intro "eerste", §3
  "tweede" SCI-werkafspraak) — intro gecorrigeerd naar "tweede".
- `mcp-revit-koppeling.md` §4 heette nog "De 20 tools" — kop neutraal gemaakt
  ("De tools en hun endpoints"), zodat een volgende telwijziging de kop niet
  opnieuw laat verouderen.
- §7 van datzelfde artikel verwees twee keer naar `execute_revit_code` als
  bestaande route — herschreven naar de negentien resterende endpoints en de
  Nonica-connector.
- `rebar-api-parameters.md` §0 en §6 zeiden nog "geen vervangende leesroute" —
  bijgewerkt met de Nonica-connector.

### Openstaand aan de kennisbank zelf

- **`use_transaction` in `execute_revit_code` — opgelost door verwijdering
  (2026-08-31).** De route zelf is verwijderd omdat willekeurige IronPython
  zonder sandbox of transactie tot een Revit-crash leidde; het dode
  `use_transaction`-veld bestaat daarmee niet meer. Zie `wiki/mcp-revit-koppeling.md`
  §4. Dit is buiten `/kb-verwerk` om gebeurd (een live-debugsessie, geen
  `raw/`-bestand); hier alsnog gelogd in `memory.md` omdat de wijziging anders
  geen spoor in het logboek had.
- **Alle veertien artikelen staan op `concept`.** Promotie naar een skill vraagt
  `stabiel` plus twee onafhankelijke bronnen (`CLAUDE.md` §4). De meeste
  rebar-artikelen leunen nog op één gecureerde samenvatting. Uitzondering sinds
  2026-08-28: `rebar-api-parameters.md` heeft er een tweede, onafhankelijke bron
  bij — de live `Enum.IsDefined`-meting op Revit 2025. Een tweede uitzondering
  sinds 2026-08-31: `mcp-versus-custom-tools.md` §3 heeft nu twee onafhankelijke
  bronnen voor "bouw met AI, niet autonoom" (Erik Frits/BIM Pure én Gavin
  Nicholls), plus een derde bevestiging in `vyssuals-datavisualisatie.md` §3.
- **Ox Alpha via OpenRouter is per definitie tijdelijk.** `wiki/ai-tools-voor-pyrevit-ontwikkeling.md`
  §1 beschrijft een gratis frontier-model dat naar verwachting van de bron zelf
  ooit betaald wordt. Bij hergebruik van dit artikel eerst verifiëren of het
  aanbod nog bestaat — een gedateerde claim die per ontwerp verloopt.
- **Alexander Gamkavoy's 77 pyRevit-skills en Juvenio Silva's materiaal —
  onvindbaar.** Genoemd in `wiki/ai-brain-kennisorganisatie-pyrevit.md` §6 zonder
  link of repository. Kandidaat voor een gerichte zoekopdracht als iemand dit
  ooit wil natrekken.
- **`W:` is onbereikbaar vanuit cloudsessies.** De extensies, `Actielijst
  lint.xlsm` en de logbestanden staan op de netwerkschijf. Structureel; begrenst
  wat een cloudsessie kan verwerken.
