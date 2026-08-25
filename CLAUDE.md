# mcp-server-for-revit-python — projectinstructies

**Werktaal: Nederlands.** Antwoord standaard in het Nederlands, bondig en to-the-point.

## Wat deze repo is

Fork van de open-source MCP-server voor Revit
(`github.com/mcp-servers-for-revit/mcp-server-for-revit-python`, MIT, auteurs
Juan D. Rodriguez / Jean-Marc Couffin). De keten is:

```
Claude → MCP-protocol → main.py → HTTP localhost:48884 → pyRevit Routes (in Revit) → Revit API
```

- `main.py` — de MCP-server (FastMCP), draait buiten Revit
- `tools/` — MCP-toolregistratie per domein, draait op CPython 3.13
- `revit_mcp/` — de Routes-handlers, draaien **binnen** Revit op IronPython 2.7
- `startup.py` + `extension.json` — pyRevit-extensieregistratie
- `LLM.txt` — upstream contextdocument (architectuur + pyRevit Routes API)

**Upstream-code niet aanpassen zonder aanleiding.** Wijzigingen aan `main.py`,
`tools/`, `revit_mcp/` en `tests/` lopen uit de pas met upstream en maken elke
volgende merge duurder.

## Kennisbank

Onder `kennisbank/` staat een kennisbank voor het Revit-/BIM-/SCI-werk.

**Lees `kennisbank/CLAUDE.md` zodra:**

- een vraag gaat over SCI-conventies, bestaande scripts, of eerder opgeloste problemen;
- er iets in `kennisbank/raw/` is gedumpt dat verwerkt moet worden;
- er om een analyse of rapport wordt gevraagd dat bewaard moet blijven;
- een van de `/kb-*`-commands wordt aangeroepen.

Dat bestand beschrijft de mapstructuur, de schrijfregels en hoe de kennisbank zich
verhoudt tot de SCI-skills.
