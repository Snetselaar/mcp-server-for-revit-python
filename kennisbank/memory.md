# Verwerkingslogboek

laatst-verwerkt: 2026-08-26

Wat is wanneer verwerkt en wat is daardoor veranderd. `/kb-verwerk` leest dit
bestand om te bepalen welke bestanden in `raw/` nog open staan, en schrijft er
een regel bij. Handmatig bijwerken hoeft niet.

| Datum | Bron | Geraakte artikelen | Toelichting |
|---|---|---|---|
| 2026-08-25 | (opzet) | `wiki/mcp-revit-koppeling.md` | Kennisbank aangelegd. Eerste artikel geschreven uit de repo zelf (`README.md`, `main.py`, `startup.py`, `revit_mcp/`, `tools/`) om de pijplijn te bewijzen. Nog niets uit `raw/` verwerkt — die map is leeg. Twee bevindingen: de tools in skill `sci-bim-context` §C matchen deze repo niet, en `use_transaction` in `execute_revit_code` wordt nooit uitgelezen. |
| 2026-08-25 | `/kb-check` (eerste health check) | `wiki/mcp-revit-koppeling.md`, `index.md` | Rapport in `outputs/2026-08-25-healthcheck.md`. Vier ongemarkeerde claims gerepareerd, `LLM.txt` uit de frontmatter, peildatum bij de toolstabel. Openstaand: welke Revit-MCP-server draait er echt. |
| 2026-08-26 | `2026-08-25-samenvatting-revit-structure-rebar.md` | `rebar-3d-modelleren.md`, `rebar-documentatie-en-staten.md`, `rebar-api-parameters.md`, `revit-robot-interoperabiliteit.md`, `nlrs-en-bim-standaarden.md` | Verdeeld over vijf artikelen. De tabel met acht BuiltInParameters is nagelopen: `CLEAR_COVER` is verkeerd omschreven, `REBAR_SHAPE_IMAGE` is vermoedelijk geen BuiltInParameter, twee namen blijven onbevestigd. Vondst naast de tabel: 2024 hoogt de enum op van 32 naar 64 bit. |
| 2026-08-26 | `2026-08-25 samenvatting-bronnen.md` | `rebar-3d-modelleren.md`, `rebar-documentatie-en-staten.md`, `revit-bronnen-en-communities.md` | Het stappenplan 3D-wapenen is samengevoegd met de rebar-dump; de bronnen- en kanalensecties zijn een eigen artikel geworden. Twee conflictblokken: de Cadix-templateaanbeveling en de voorgestelde diameterfilters, die de SCI-template al heeft. |
| 2026-08-26 | `2026-08-25 zelfverbeterende-kennisbank-claude.md` | geen wiki-artikel — `.claude/commands/kb-check.md`, `kennisbank/CLAUDE.md` | **Afwijkende behandeling, bewust.** Valt buiten het bereik uit `CLAUDE.md` §1 (alleen Revit/BIM/SCI), dus geen wiki-artikel. Wel gebruikt om het systeem te verbeteren: `/kb-check` uitgebreid van vijf naar zeven controles (kapotte kruisverwijzingen, coverage) plus een actieplan-slotsectie, en de terugkoppellus toegevoegd aan `CLAUDE.md` §7. Niet opnieuw verwerken. |
| 2026-08-26 | meting in draaiend Revit (PID 30312, model `S-9132_R25`) + `pyRevit_config.ini` | `wiki/mcp-revit-koppeling.md`, `index.md`, `../CLAUDE.md` | Routes luistert op **48885**, niet op 48884, en geeft `api_name: revit_mcp` — daarmee staat vast dat déze repo draait en is actie 1 van de health check afgehandeld. Twee reparaties: `main.py` leest de poort nu uit `REVIT_HOST`/`REVIT_PORT` (default 48884), en `.mcp.json` wees naar een pad zonder `main.py` en `.venv`. Ook vastgelegd als faalpunt 6: Revit laadt de extensie uit `%APPDATA%\pyRevit\Extensions\`, niet uit de repo. Opvolging bijgeschreven in `outputs/2026-08-25-healthcheck.md`. |
