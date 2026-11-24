# mcp-server-for-revit-python — projectinstructies

**Werktaal: Nederlands.** Antwoord standaard in het Nederlands, bondig en to-the-point.

## Wat deze repo is

Fork van de open-source MCP-server voor Revit
(`github.com/mcp-servers-for-revit/mcp-server-for-revit-python`, MIT, auteurs
Juan D. Rodriguez / Jean-Marc Couffin). De keten is:

```
Claude → MCP-protocol → main.py → HTTP localhost:<Routes-poort> → pyRevit Routes (in Revit) → Revit API
```

De Routes-poort is 48884 als basis, maar ligt niet vast — gemeten op 2026-08-26
luisterde Revit op 48885. Instelbaar met de omgevingsvariabelen `REVIT_HOST` en
`REVIT_PORT`, in `.mcp.json` gezet onder `env`. Zie
`kennisbank/wiki/mcp-revit-koppeling.md` §2.

- `main.py` — de MCP-server (FastMCP), draait buiten Revit
- `tools/` — MCP-toolregistratie per domein, draait op CPython 3.13
- `revit_mcp/` — de Routes-handlers, draaien **binnen** Revit op IronPython 2.7
- `startup.py` + `extension.json` — pyRevit-extensieregistratie
- `LLM.txt` — upstream contextdocument (architectuur + pyRevit Routes API)

**Upstream-code niet aanpassen zonder aanleiding.** Wijzigingen aan `main.py`,
`tools/`, `revit_mcp/` en `tests/` lopen uit de pas met upstream en maken elke
volgende merge duurder.

Bewuste afwijkingen van upstream, bij te houden bij elke volgende:

| Datum | Bestand | Wijziging | Waarom |
|---|---|---|---|
| 2026-08-26 | `main.py:21-25` | `REVIT_HOST`/`REVIT_PORT` uit omgevingsvariabelen, default onveranderd `localhost:48884` | de Routes-poort ligt niet vast; hardgecodeerd 48884 brak de verbinding. Kandidaat voor een PR bij upstream. |
| 2026-09-07 | `revit_mcp/code_execution.py`, `tools/code_execution_tools.py`, `tests/unit/` | de route `/execute_code/` en de bijbehorende MCP-tool verwijderd, inclusief de tests die ze aanriepen | de route liet Revit crashen. Bewust *geen* PR-kandidaat: dit is onze keuze, niet een upstream-defect. |

## Claude-opzet in deze repo

Onder `.claude/` staat wat een sessie hier automatisch meekrijgt:

- **Hook** `hooks/ipy_compile.ps1` (ingehangen in `settings.json`, na elke
  `Write`/`Edit`): compileert een bewerkt `.py` binnen een `.extension`-map
  onder IronPython 2.7.12 en meldt een syntaxfout direct terug. Vangt alleen
  syntax, geen API-verschillen tussen Revit-versies.
- **Subagents** in `agents/`, alle drie alleen-lezen. Besteed uit in plaats van
  het zelf in de hoofdsessie te doen:
  - `lint-verkenner` — zoeken, tellen en diffen in werkmap en gedeelde Lint-map;
  - `ironpython-reviewer` — review van een knop tegen `pyrevit-codestijl`;
  - `kb-checker` — leeswerk in de kennisbank, ook voor `/kb-check`.
- **Skill** `skills/annotatie-autopilot` en de `/kb-*`-commands in `commands/`.

De zeven SCI-skills (`pyrevit-codestijl`, `bimtools-*`, `sci-bim-context`,
`revit-api-docs`, `update-github-bimtools`) staan niet hier maar in de repo
`Snetselaar_BIM` en komen via claude.ai binnen.

Voor Revit uitlezen: de eigen Lees-MCP (`revit-lezen`). De Routes-koppeling
(`revit`) niet gebruiken om het model te lezen of te wijzigen.

## Kennisbank

Onder `kennisbank/` staat een kennisbank voor het Revit-/BIM-/SCI-werk.

**Lees `kennisbank/CLAUDE.md` zodra:**

- een vraag gaat over SCI-conventies, bestaande scripts, of eerder opgeloste problemen;
- er iets in `kennisbank/raw/` is gedumpt dat verwerkt moet worden;
- er om een analyse of rapport wordt gevraagd dat bewaard moet blijven;
- een van de `/kb-*`-commands wordt aangeroepen.

Dat bestand beschrijft de mapstructuur, de schrijfregels en hoe de kennisbank zich
verhoudt tot de SCI-skills.
