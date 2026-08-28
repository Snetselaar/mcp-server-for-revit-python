---
type: skill-correctie
datum: 2026-08-26
doel: skill `sci-bim-context`, `references/template-en-mcp.md` §C
status: klaar om te plakken, nog niet doorgevoerd
---

# Toolstabel in `sci-bim-context` §C vervangen

Plaktekst voor claude.ai. Skills worden daar bewerkt, niet op schijf
(`kennisbank/CLAUDE.md` §3 regel 3), dus dit bestand is het eindproduct — er is
geen bestandswijziging die dit afrondt.

## Waarom

§C noemt onder "Veelgebruikte Revit-MCP-tools (en geobserveerde ID's)" zeven
tools:

```
get_active_view_in_revit          get_all_project_units
get_all_workset_information       get_category_by_keyword
get_all_warnings_in_the_model     get_parameter_value_for_element_ids
get_all_used_families_in_model
```

Geen van die zeven bestaat in de server die hier draait. Dat is op 2026-08-25
gevonden en op 2026-08-26 afgemaakt: de health check op
`http://localhost:48885/revit_mcp/status/` gaf `"api_name": "revit_mcp"`, de
API-naam die `startup.py` van deze repo registreert. Het staat daarmee vast dat
de fork `Snetselaar/mcp-server-for-revit-python` de draaiende server is en dat
de zeven namen ergens anders bij horen.

De blokkade uit `kennisbank/CLAUDE.md` §3 regel 2 — de skill wint bij twijfel —
gold zolang niet vaststond wélke server draaide. Die twijfel is weg.

## Wat je vervangt, en wat je laat staan

**Vervangen:** alleen de subsectie met de zeven toolnamen.

**Laten staan:** de categorie- en parameter-ID's die verderop in dezelfde §C
staan. Die gaan niet over de MCP-server en zijn niet nagelopen. De regel dat
`hoofd_map` en `sub_map` altijd op naam worden opgezocht en nooit op ID blijft
ook staan.

## Plaktekst

De twintig namen hieronder zijn op 2026-08-26 uit `tools/*.py` gelezen met een
AST-parser, niet overgetypt. De omschrijvingen komen uit de docstrings.

---

### Revit-MCP-tools

De server die bij SCI draait is de fork
`github.com/Snetselaar/mcp-server-for-revit-python`. Hij registreert twintig
tools; nagelopen tegen `tools/*.py` op 2026-08-26.

| Tool | Doet | Revit nodig |
|---|---|---|
| `get_revit_status` | health check van de koppeling | ja |
| `get_revit_model_info` | overzicht van het actieve model | ja |
| `get_current_view_info` | gegevens van de actieve view | ja |
| `get_current_view_elements` | elementen zichtbaar in de actieve view | ja |
| `list_revit_views` | alle exporteerbare views | ja |
| `get_revit_view` | één view als afbeelding exporteren | ja |
| `list_levels` | alle levels in het model | ja |
| `list_families` | platte lijst van familietypes | ja |
| `list_family_categories` | alle familiecategorieën | ja |
| `place_family` | familie-instantie plaatsen op een locatie | ja |
| `list_category_parameters` | beschikbare parameters van een categorie | ja |
| `color_splash` | elementen kleuren op parameterwaarde | ja |
| `clear_colors` | kleuroverrides opheffen | ja |
| `open_document` | een bestand openen in het draaiende Revit | ja |
| `close_document` | het actieve document sluiten | ja |
| `save_document` | het actieve document opslaan | ja |
| `sync_with_central` | synchroniseren met central | ja |
| `execute_revit_code` | willekeurige IronPython in de Revit-context | ja |
| `list_revit_installations` | geïnstalleerde Revit-versies opsporen | nee |
| `launch_revit` | Revit starten, eventueel met een bestand erbij | nee |

Voor worksets, warnings, project units en parameterwaarden per element-id
bestaat géén eigen tool. Dat gaat allemaal door `execute_revit_code`, de
ontsnappingsklep die IronPython uitvoert met `doc`, `uidoc`, `DB` en `revit` al
in de namespace. Twee dingen om te onthouden bij die tool:

- **Er is geen automatische transactie**, ondanks wat de docstring over
  `use_transaction` beweert — dat veld wordt nergens uitgelezen. Modelwijzigende
  code opent zijn eigen transactie, volgens het patroon uit `pyrevit-codestijl`.
- `print` wordt opgevangen en teruggegeven. Dat is het debugkanaal.

De Routes-poort is 48884 als basis maar ligt niet vast: op 2026-08-26 luisterde
Revit op 48885. Instelbaar met de omgevingsvariabele `REVIT_PORT`. Endpoints,
timeouts en faalpunten staan in `kennisbank/wiki/mcp-revit-koppeling.md`.

---

## Nog één afwijking in dezelfde §C

Kleiner, en geen fout — wel twee opstellingen die door elkaar heen
gedocumenteerd staan. §C beschrijft starten in combined HTTP-modus:

```
uv run --with "mcp[cli]" main.py --combined
```

met de client op `http://localhost:8000/mcp`. Maar `.mcp.json` in de repo
configureert **stdio**: de venv-Python roept `main.py` aan zonder vlaggen, en
zonder vlaggen is het transport `stdio` (`main.py:115` en `main.py:127`). Beide
werken. Wie §C toch openheeft, kan er een zin bij zetten dat stdio de
standaardopstelling is en `--combined` de uitzondering.

## Daarna

Zodra dit in de skill staat, kan de regel in `index.md` onder "Vragen aan de
skills" weg. Tot die tijd blijft hij staan, want de skill en de wiki spreken
elkaar tegen zolang de tabel niet vervangen is.
