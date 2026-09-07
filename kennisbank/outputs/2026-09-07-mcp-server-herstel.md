---
type: herstelverslag
datum: 2026-09-07
onderwerp: MCP-server startte niet meer
status: keten werkend, twee tests open
---

# MCP-server hersteld — 2026-09-07

## Map die je moet openen

```
C:\Users\S-WOU1A\OneDrive - Snetselaar Constructieve Ingenieurs\Documenten\GitHub\mcp-server-for-revit-python
```

Dit is de git-clone met `main.py`, `pyproject.toml` en `.mcp.json`. **Niet**
`C:\Users\S-WOU1A\Documents\GitHub\mcp-server-for-revit-python` — dat is de
pyRevit-extensiemap die via een symlink in
`%APPDATA%\pyRevit\Extensions\mcp-server-for-revit-python.extension` geladen
wordt. Daar staan geen `main.py` en `pyproject.toml`.

## Wat er kapot was — vier oorzaken, niet twee

1. **`requirements.txt` was onoplosbaar.** `mcp==1.23.0` eist
   `typing-inspection>=0.4.1`, maar die stond gepind op `0.4.0`. Gefixt op de
   PR-branch; lokaal geverifieerd (`uv sync` in 1,4s, mcp 1.29.1,
   typing-inspection 0.4.4; `requirements.txt` ook oplosbaar via het pip-pad).
2. **`.mcp.json` wees naar een hardgecodeerd `.venv`-pad.** Vervangen door
   `uv run --directory`, dat de omgeving zelf uit `uv.lock` opbouwt.
3. **De pyRevit Routes-server stond uit.** `pyRevit_config.ini` is op
   2026-09-07 om 07:36 herschreven en verloor daarbij `[routes]`,
   `[environment]` (clones-registratie), de extensie-sectie, en `tab_colors`
   ging van 10 naar 4 kleuren. Oorzaak van die reset onbekend.
4. **De extensie werd niet geladen.** `extension.json` bevat
   `"default_enabled": "False"`. Zonder een expliciete sectie
   `[mcp-server-for-revit-python.extension]` met `disabled = false` draait
   `startup.py` nooit, en dan antwoordt de Routes-server wel maar met
   `RouteHandlerNotDefinedException`. `pyrevit extensions enable` vindt deze
   extensie niet (hij ziet de symlink niet) — sectie handmatig in de ini
   zetten en Revit herstarten.

Oorzaak 3 en 4 waren onzichtbaar voor de cloud-sessie: die kreeg
"All connection attempts failed" en schreef dat toe aan het ontbreken van
Revit. Lokaal, met Revit open, gaf het exact dezelfde fout.

## Herstel dat is uitgevoerd

- `pyrevit configs routes enable` + `coreapi enable`
- `host = "127.0.0.1"` **mét** aanhalingstekens (de CLI schrijft ze niet;
  de bewezen werkende backup had ze wel)
- Sectie `[mcp-server-for-revit-python.extension]` met `disabled = false`
  handmatig toegevoegd
- Twee Revit-herstarts
- Backups: `pyRevit_config.ini.bak-voor-routes-20260907` en
  `.bak-voor-extensie-20260907` in `%APPDATA%\pyRevit\`

## Wat aantoonbaar werkt

| Onderdeel | Uitkomst |
|---|---|
| `uv --version` | 0.11.28, staat op PATH |
| `uv sync` | 1,4s, 38 packages |
| Unit tests | 65 passed |
| MCP-handshake via `uv run` | 20 tools, incl. `get_revit_status` |
| Routes | luistert op `127.0.0.1:48884`, niet op `0.0.0.0` |
| `get_revit_status` | `status: active`, `health: healthy`, modeltitel |

Volledige keten Claude → MCP-server → pyRevit Routes → Revit is dus voor het
eerst end-to-end bewezen.

## Wat nog getest moet worden

### 1. Integratietests tegen een wegwerpmodel

De ronde van 2026-09-07 gaf 4 passed / 5 failed, maar die uitslag is
**onbruikbaar**: de tests openden zelf `test.rvt` en het geopende centrale
model S-9464 Apartementen viel daarbij dicht. De omgeving was tijdens de
laatste tests dus al verstoord.

> **Waarschuwing.** Draai `tests/integration/` nooit terwijl er een echt
> projectmodel open staat. Het is niet alleen `test_document_lifecycle.py` —
> ook `test_views.py` en `test_families.py` roepen `open_document(test.rvt)`
> aan. `close_document` gebruikt `save: False`, dus daar is onopgeslagen werk
> echt weg. De route doet
> `uiapp.OpenAndActivateDocument(model_path, open_options, False)` met in de
> code de comment "False = don't close the existing active document"; die
> aanname klopt niet voor een workshared central file.

Aanpak: Revit openen met een wegwerpmodel (of zonder model), dan vanuit de
clone:

```
uv run -m pytest tests/integration -q
```

Statisch gecontroleerd bestaan alle endpoints die de tests aanroepen wél in
de live extensie, dus een schone ronde zou beter moeten scoren dan 4/9.

### 2. CI van PR #1

Niet af te lezen op deze machine — `gh` is niet geïnstalleerd. De laatste
commit raakt alleen `.mcp.json`, dus groen is te verwachten maar niet gemeten.
https://github.com/Snetselaar/mcp-server-for-revit-python/pull/1

### 3. `get_revit_status` via de echte `.mcp.json`

Alle metingen hierboven zijn gedaan door de server handmatig als subprocess te
starten. De weg via Claude Code's eigen `.mcp.json` is nog niet gelopen —
daarvoor moet Claude Code op de OneDrive-map draaien. Dat is de eerste
controle voor de volgende sessie.

## Gepushte commits

| Branch | Commit | Inhoud |
|---|---|---|
| `claude/revit-mcp-health-check-5cdi72` (PR #1) | `59ccdb0` | pad in `.mcp.json` naar de echte clone; `REVIT_PORT` terug |
| `claude/self-improving-knowledge-base-euds0l` | `7c4dd44` | route `/selection_info/` alsnog in versiebeheer |

Het kennisbank-werk in de werkboom staat nog ongecommit en is niet aangeraakt.

## Losse observatie

`revit_mcp/views.py` liep in de live extensiemap 104 regels vóór op git — de
route `/selection_info/` van 2026-08-31 was nooit gecommit. Nu wel. De rest
van de extensiemap was byte-identiek aan de werkboom. Het blijft een risico
dat de live map en de clone uiteenlopen zonder dat iets dat signaleert.
