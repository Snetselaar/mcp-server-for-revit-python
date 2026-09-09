# Merge-plan: `Renaming-repo-and-org` bijwerken (opgesteld 09-09-2026)

Voorbereiding, nog niet uitgevoerd. Alles hieronder is gemeten met
`git merge-tree` (droge merge, werkboom onaangeroerd).

## Conclusie vooraf: merge NIET `origin/master`

Er zijn vier werklijnen in deze repo, niet twee:

| Branch | Positie |
|---|---|
| `Renaming-repo-and-org` (hier) | 4 commits die nergens anders zitten |
| `origin/master` | 50 commits vooruit op ons |
| `origin/claude/self-improving-knowledge-base-euds0l` | **16 vooruit op master, 0 achter** |
| `origin/claude/revit-mcp-health-check-5cdi72` | zit al in master (PR #1) |

De knowledge-base-branch is een strikte superset van `master`. Die is dus het
integratiedoel. Dat scheelt niet alleen commits maar vooral conflicten:

| Doel | Conflicten | Resultaat |
|---|---|---|
| `origin/master` | 2 (`.gitignore`, `revit_mcp/views.py`) | **stil kapot**, zie hieronder |
| `origin/claude/self-improving-knowledge-base-euds0l` | 1 (`.gitignore`) | correct |

### Waarom `master` stil kapot gaat

Bij een merge van `master` levert `startup.py` géén conflict maar wel een fout
resultaat: git plakt onze `register_document_routes` en die van master naast
elkaar, zodat de document-routes **twee keer** geregistreerd worden. Dat is
precies het soort mis-merge dat je pas in Revit merkt. Bij de KB-branch komt
`startup.py` er correct uit.

## Wat de KB-branch meebrengt dat wij missen

- `tests/` — unit + integratie, plus `pytest`-config en `tests/test.rvt`
- `.github/workflows/ci.yml` — bewaakt `requirements.txt`, `pip check`,
  unit tests op Windows/Ubuntu × Python 3.11/3.13, en of `uv.lock`,
  `requirements.txt` en `pyproject.toml` het onderling eens zijn
- `tools/document_tools.py` — de MCP-tools bij onze vier document-routes
  (dit was punt 3 van de doorloop; niet zelf gebouwd, komt hiermee mee)
- `tools/launch_tools.py` — Revit starten en bestanden beheren
- `.mcp.json`, herstelde `pyproject.toml`/`requirements.txt`,
  `REVIT_HOST`/`REVIT_PORT` uit de omgeving
- dependency-bumps: mcp 1.9.0 → 1.23.0, starlette, idna, python-multipart

## Wat wij meebrengen dat de KB-branch mist

Onze vier commits: de `model_info`-uitbreiding (Structural Columns/Foundations,
volledige `view_breakdown`) en de fork-snapshot met de fixes in `status.py`,
`colors.py`, `placement.py`, `utils.py` en `views.py`.

**Geverifieerd in de droge merge — deze blijven allemaal staan:**

| Bestand | Uitkomst |
|---|---|
| `revit_mcp/status.py` | onze eerlijke variant met `doc` in de signatuur en `api_context` |
| `revit_mcp/model_info.py` | onze uitbreiding blijft |
| `revit_mcp/views.py` | `selection_info` blijft (incl. de 501-guard van vandaag) |
| `startup.py` | correct, één registratie per module, geen `/execute_code/` |
| `revit_mcp/code_execution.py`, `tools/code_execution_tools.py` | blijven weg — de KB-branch heeft ze óók verwijderd |

## Uitvoering

1. Commit eerst het werk van vandaag (punten 1–4 van de doorloop) — de merge
   vereist een schone werkboom.
2. ```bash
   git merge origin/claude/self-improving-knowledge-base-euds0l
   ```
3. Los `.gitignore` op: neem de versie van de KB-branch en voeg onze regels toe.
   De samengevoegde inhoud hoort te zijn:
   ```
   # Python-generated files
   __pycache__/
   *.py[oc]
   build/
   dist/
   wheels/
   *.egg-info

   # Virtual environments
   .venv

   *TODO.md
   .env
   CLAUDE.md
   .claude/
   ```
4. Verwijder `tests/integration/test_code_execution.py`. Dat bestand test
   `POST /execute_code/`, een route die niet meer bestaat. Het draait niet in
   CI (`@pytest.mark.integration`), maar het is dode boel.
5. Controleer na afloop:
   ```bash
   uv run --with "mcp[cli]" python -c "import main, anyio; print(len(anyio.run(main.mcp.list_tools)))"
   ```
   ```bash
   uv run --with ".[test]" python -m pytest tests/unit -q
   ```
6. Herstart Revit en haal `http://localhost:48884/revit_mcp/status/` op. `startup.py`
   verandert door deze merge, en pyRevit laadt deze map rechtstreeks (zie hieronder).

## Twee dingen om vooraf te beslissen

**a. Deze map ís de live extensie.** `%APPDATA%\pyRevit\Extensions\mcp-server-for-revit-python.extension`
is een junction naar `C:\Users\S-WOU1A\Documents\GitHub\mcp-server-for-revit-python`.
Een merge hier verandert dus meteen wat Revit laadt. Doe het niet met een
productiemodel open.

**b. De MCP-server draait vanuit een ándere clone.** `.mcp.json` (komt mee met de
merge) wijst naar
`OneDrive - Snetselaar Constructieve Ingenieurs\Documenten\GitHub\mcp-server-for-revit-python`.
Die clone bestaat en staat nu op de KB-branch. Na de merge draait de routes-kant
(Revit) dus uit deze map en de client-kant (MCP-server) uit die andere — twee
werkkopieën die uit elkaar kunnen lopen. Kies één van beide:
- `.mcp.json` naar deze map laten wijzen, of
- de OneDrive-clone na de merge op dezelfde commit zetten.

**c. Integratietests openen documenten.** `tests/integration/` roept
`/open_document/` en `/close_document/` aan. Draai die nooit met een
productiemodel open; alleen tegen `tests/test.rvt`.
