# Index

Kaart van `wiki/`. Bijgewerkt door `/kb-verwerk` en `/kb-check`.

**Stand:** 7 artikelen, 2026-08-26. Laatste health check:
[2026-08-25](outputs/2026-08-25-healthcheck.md), met een
[opvolging van 2026-08-26](outputs/2026-08-25-healthcheck.md#opvolging-2026-08-26).

---

## Wapening

| Artikel | Status | Bijgewerkt | Waarover |
|---|---|---|---|
| [rebar-3d-modelleren.md](wiki/rebar-3d-modelleren.md) | concept | 2026-08-26 | Kolom-, balk- en vloerwapening, free form, splices — met een versietabel 2024–2027 |
| [rebar-documentatie-en-staten.md](wiki/rebar-documentatie-en-staten.md) | concept | 2026-08-26 | Partitions, filters, tags, Multi-Rebar Annotation, buigstaten en Bending Details |
| [rebar-api-parameters.md](wiki/rebar-api-parameters.md) | concept | 2026-08-26 | De acht BuiltInParameters uit de dump, nagelopen: vier houden stand, twee zijn fout |

## MCP en gereedschap

| Artikel | Status | Bijgewerkt | Waarover |
|---|---|---|---|
| [mcp-revit-koppeling.md](wiki/mcp-revit-koppeling.md) | concept | 2026-08-26 | De keten Claude → MCP → pyRevit Routes → Revit API: opbouw, tools, endpoints en faalpunten |
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

- **De toolstabel in `sci-bim-context` §C klopt niet.** Op 2026-08-26 gemeten
  dat déze repo in Revit draait (`api_name: revit_mcp`, poort 48885), dus de
  vraag wélke server draait is beantwoord. De zeven toolnamen in de skill horen
  ergens anders bij. De plaktekst met de twintig echte namen ligt klaar in
  [outputs/2026-08-26-sci-bim-context-toolstabel.md](outputs/2026-08-26-sci-bim-context-toolstabel.md).
  Nog niet in de skill doorgevoerd — dat gaat via claude.ai, niet op schijf.
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

- **De acht BuiltInParameters afmaken.** Vier van de acht zijn niet vastgesteld,
  want alle vier de documentatiebronnen uit `revit-api-docs` zijn vanuit een
  cloudsessie geblokkeerd. Dit moet vanaf de werkplek. Zie
  `wiki/rebar-api-parameters.md` §6.
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

### Openstaand aan de kennisbank zelf

- **`use_transaction` in `execute_revit_code` doet niets.** Gedocumenteerd in de
  docstring, nergens uitgelezen. Kandidaat voor een issue bij upstream. Zie
  `wiki/mcp-revit-koppeling.md` §4.
- **Alle zeven artikelen staan op `concept`.** Promotie naar een skill vraagt
  `stabiel` plus twee onafhankelijke bronnen (`CLAUDE.md` §4). De rebar-artikelen
  leunen alle op één gecureerde samenvatting, dus die drempel is nog ver weg.
- **`W:` is onbereikbaar vanuit cloudsessies.** De extensies, `Actielijst
  lint.xlsm` en de logbestanden staan op de netwerkschijf. Structureel; begrenst
  wat een cloudsessie kan verwerken.
