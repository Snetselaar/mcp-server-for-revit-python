# Index

Kaart van `wiki/`. Bijgewerkt door `/kb-verwerk` en `/kb-check`.

**Stand:** 9 artikelen, 2026-08-28. Laatste health check:
[2026-08-28](outputs/2026-08-28-healthcheck.md) (0 kapotte kruisverwijzingen,
coverage volledig, geen stijlovertredingen). Daarvoor:
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
| [mcp-revit-koppeling.md](wiki/mcp-revit-koppeling.md) | concept | 2026-08-28 | De keten Claude → MCP → pyRevit Routes → Revit API: opbouw, tools, endpoints en faalpunten |
| [mcp-eigen-tools-toevoegen.md](wiki/mcp-eigen-tools-toevoegen.md) | concept | 2026-08-28 | Een eenentwintigste tool bouwen: route-module, tool-module, twee registraties en de MCP Inspector |
| [mcp-versus-custom-tools.md](wiki/mcp-versus-custom-tools.md) | concept | 2026-08-28 | Wanneer de AI-brug en wanneer een gewone knop; risico's, het Erik Frits-advies en de Autodesk 2027-server |
| [revit-bronnen-en-communities.md](wiki/revit-bronnen-en-communities.md) | concept | 2026-08-26 | Waar Revit-kennis vandaan komt: API-docs, pyRevit, IFC, kanalen, het P.R.O.C.E.S.S.-kader |

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

- **`sci-bim-context` §C is opgelost (geüpload 2026-08-28).** De acht toolnamen
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
- **Routes-binding — gemeten en gecorrigeerd (2026-08-28), reload nodig.** De
  live socket stond op `0.0.0.0:48884`; `host = 127.0.0.1` is nu onder `[routes]`
  gezet met `pyrevit configs "routes:host" 127.0.0.1`. Actief na een
  pyRevit-reload of Revit-herstart; tot dan blijft de binding `0.0.0.0`.
  Verifiëren met de `Get-NetTCPConnection`-query. Zie `wiki/mcp-revit-koppeling.md`
  §2. (Het tutorial-commando `--host` bleek niet te bestaan in deze pyRevit.)
- **Draait er ergens pyRevit 6.5.3?** Die versie zou een Routes-bug hebben;
  6.4.0 is aangeraden. Onbevestigd, geen issuenummer, versie niet gemeten. Zie
  `wiki/mcp-revit-koppeling.md` §5 punt 7.
- **Welke Revit-versies draait SCI in productie?** Op 2026-08-28 draaide de
  werkplek **Revit 2025**. Of de rest van het bereik 2024/2026/2027 in productie
  is, bepaalt of de Autodesk 2027 MCP-server in beeld komt. Zie
  `wiki/mcp-versus-custom-tools.md` §4.

### Openstaand aan de kennisbank zelf

- **`use_transaction` in `execute_revit_code` doet niets.** Gedocumenteerd in de
  docstring, nergens uitgelezen. Kandidaat voor een issue bij upstream. Zie
  `wiki/mcp-revit-koppeling.md` §4.
- **Alle negen artikelen staan op `concept`.** Promotie naar een skill vraagt
  `stabiel` plus twee onafhankelijke bronnen (`CLAUDE.md` §4). De meeste
  rebar-artikelen leunen nog op één gecureerde samenvatting. Uitzondering sinds
  2026-08-28: `rebar-api-parameters.md` heeft er een tweede, onafhankelijke bron
  bij — de live `Enum.IsDefined`-meting op Revit 2025 — en komt daarmee dichter
  bij de promotiedrempel voor het bestaan van de namen (niet voor de semantiek).
- **`W:` is onbereikbaar vanuit cloudsessies.** De extensies, `Actielijst
  lint.xlsm` en de logbestanden staan op de netwerkschijf. Structureel; begrenst
  wat een cloudsessie kan verwerken.
