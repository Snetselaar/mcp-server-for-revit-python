# Verwerkingslogboek

laatst-verwerkt: 2026-08-25

Wat is wanneer verwerkt en wat is daardoor veranderd. `/kb-verwerk` leest dit
bestand om te bepalen welke bestanden in `raw/` nog open staan, en schrijft er
een regel bij. Handmatig bijwerken hoeft niet.

| Datum | Bron | Geraakte artikelen | Toelichting |
|---|---|---|---|
| 2026-08-25 | (opzet) | `wiki/mcp-revit-koppeling.md` | Kennisbank aangelegd. Eerste artikel geschreven uit de repo zelf (`README.md`, `main.py`, `startup.py`, `revit_mcp/`, `tools/`) om de pijplijn te bewijzen. Nog niets uit `raw/` verwerkt — die map is leeg. Twee bevindingen: de tools in skill `sci-bim-context` §C matchen deze repo niet, en `use_transaction` in `execute_revit_code` wordt nooit uitgelezen. |
| 2026-08-25 | `/kb-check` (eerste health check) | `wiki/mcp-revit-koppeling.md`, `index.md` | Rapport in `outputs/2026-08-25-healthcheck.md`. Vier ongemarkeerde claims gerepareerd, `LLM.txt` uit de frontmatter, peildatum bij de toolstabel. Openstaand: welke Revit-MCP-server draait er echt. |
