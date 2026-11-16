---
titel: De MCP-Revit-koppeling — historiek van execute_revit_code en de skillconflicten
status: concept
laatst-bijgewerkt: 2026-11-16
bronnen:
  - "mcp-revit-koppeling.md tot 2026-11-16 (afgesplitst, inhoud ongewijzigd)"
  - "revit_mcp/code_execution.py en tools/code_execution_tools.py, stand 2026-08-25 (verwijderd 09-09-2026, commit d695d83; terug te lezen met git show d695d83~1:revit_mcp/code_execution.py)"
  - "KNOWN_ISSUES.md (repo-root, 2026-09-09)"
  - "Snetselaar_BIM/sci-bim-context/references/template-en-mcp.md §C (stand 2026-08-25 t/m 2026-08-31)"
  - outputs/2026-08-28-sci-bim-context-toolstabel.md
  - outputs/2026-08-31-healthcheck.md
  - "gemeten 2026-08-26: Revit PID 30312, model S-9132_R25, luisterpoort 48885"
verwant:
  - mcp-revit-koppeling.md
  - routes-thread-veiligheid.md
  - rebar-api-parameters.md
skill: sci-bim-context
---

# De MCP-Revit-koppeling — historiek

Afgesplitst van `mcp-revit-koppeling.md` op 2026-11-16, omdat dat artikel ruim
480 regels telde (`kennisbank/CLAUDE.md` §5). Hier staat wat niet meer geldt maar
als bronketen bewaard blijft: de verwijderde route `execute_revit_code` en de
twee opgeloste conflicten met de skill `sci-bim-context`. De huidige keten staat
in `mcp-revit-koppeling.md`; de oorzaak van de crashes in
`routes-thread-veiligheid.md`. De meting met `Enum.IsDefined` die via deze route
liep, staat in `rebar-api-parameters.md` §0.

## 1. `execute_revit_code`, de verwijderde ontsnappingsklep

> **Deze route en tool bestaan niet meer.** De verwijdering ging in twee
> stappen. Eind augustus 2026 ging de registratie van `/execute_code/` uit
> `startup.py`; `KNOWN_ISSUES.md` dateert de crashes op 28-08-2026, terwijl de
> route die dag ook nog een geslaagde meting deed (`rebar-api-parameters.md`
> §0). Het besluit is in deze kennisbank gelogd op 31-08-2026. De bestanden
> `revit_mcp/code_execution.py` en `tools/code_execution_tools.py` zijn pas op
> **09-09-2026** verwijderd (commit `d695d83`). Tot dan stond de MCP-tool nog
> geregistreerd en gaf hij een 404; de handshake van 07-09 telde daarom nog
> twintig tools (`outputs/2026-09-07-mcp-server-herstel.md`).
>
> Reden: de route `exec()`te willekeurige IronPython in het levende Revit-proces
> zonder schema, sandbox of transactie. De verklaring van de crash is sindsdien
> verbreed: ook de read-only route `/selection_info/` crashte Revit, dus het
> probleem zit in model-toegang vanaf de Routes-thread, niet alleen in `exec()`.
> Zie `routes-thread-veiligheid.md`.
>
> De beschrijving hieronder blijft staan als verantwoording van het besluit.
> De regelverwijzingen naar `code_execution.py` wijzen naar een bestand dat niet
> meer bestaat; ze gelden voor de stand van 2026-08-25.

Voert IronPython uit binnen de Revit-context met `doc`, `uidoc`, `DB` en `revit`
al in de namespace (`revit_mcp/code_execution.py:53-58`). `print` wordt
opgevangen in een `StringIO` en teruggegeven, dus printen is het debugkanaal
(`revit_mcp/code_execution.py:49-61`).

De handler geeft nuttige foutafhandeling terug: bij `AttributeError`,
`NullReferenceException` en `InvalidOperationException` komt er een gerichte hint
mee (`revit_mcp/code_execution.py:93-116`), plus de volledige traceback.

Dit is de tool die alles kon wat de andere negentien niet kunnen. Dat hij het
model kon slopen, deelt hij met elke route die het model aanraakt
(`routes-thread-veiligheid.md`).

### `use_transaction` doet niets

De docstring documenteert een payload-veld `use_transaction` met default true,
"set false for UI ops like switching the active view"
(`revit_mcp/code_execution.py:29`). **Dat veld wordt nergens uitgelezen.**
Gecontroleerd op 2026-08-25: `use_transaction` komt in het hele bestand van 140
regels alleen in die docstring voor, en het woord `Transaction` alleen nog in een
hint-string op regel 115. De handler doet niets meer dan `exec(code_to_execute,
namespace)` (`revit_mcp/code_execution.py:65`).

**Gevolg: er is geen automatische transactie.** Modelwijzigende code moet zijn
eigen transactie openen, precies zoals het transactiepatroon uit de skill
`pyrevit-codestijl` voorschrijft:

```python
# IronPython 2.7
t = DB.Transaction(doc, "beschrijving")
t.Start()
try:
    # wijzigingen
    t.Commit()
except Exception:
    t.RollBack()
    raise
```

Zonder eigen transactie faalt modelwijzigende code met een
`InvalidOperationException`; de handler geeft dan zelf de hint om een transactie
te openen (`revit_mcp/code_execution.py:112-116`). Dat is meteen de bevestiging
dat er geen omhullende transactie is.

## 2. De conflicten met de skill `sci-bim-context`

> **Conflict met skill `sci-bim-context`:** `references/template-en-mcp.md` §C
> noemt onder "Veelgebruikte Revit-MCP-tools (en geobserveerde ID's)" acht
> tools: `get_active_view_in_revit`, `get_all_workset_information`,
> `get_all_warnings_in_the_model`, `get_all_used_families_in_model`,
> `get_all_project_units`, `get_category_by_keyword`,
> `get_elements_by_category`, `get_parameter_value_for_element_ids`.
> (De health check van 2026-08-25 telde er zeven en sloeg
> `get_elements_by_category` over; op 2026-08-28 nageteld in de skillbron
> `Snetselaar_BIM/sci-bim-context/references/template-en-mcp.md`.)
>
> **Geen van die acht namen komt voor in deze repo.** Gecontroleerd tegen de
> twintig tools in `tools/*.py` (§4). De dichtstbijzijnde equivalenten heten
> hier anders: `get_current_view_info` in plaats van `get_active_view_in_revit`,
> `list_families` in plaats van `get_all_used_families_in_model`. Voor worksets,
> warnings en project units bestaat hier **geen** tool; die zijn alleen via
> `execute_revit_code` te benaderen.

**Vastgesteld op 2026-08-26: het is déze repo die in Revit draait.** De health
check op `http://localhost:48885/revit_mcp/status/` gaf:

```json
{"health": "healthy", "revit_available": true,
 "document_title": "S-9132_R25 - versie drie kappen",
 "api_name": "revit_mcp", "status": "active"}
```

`api_name: "revit_mcp"` is de API-naam die `startup.py` van deze repo
registreert. De acht toolnamen uit de skill horen dus bij een andere server.

**Welke server, vastgesteld op 2026-09-17: de Nonica-connector.** De
MCP-connector `Revit` (Nonica) biedt precies deze acht namen aan, naast andere:
`get_active_view_in_revit`, `get_all_workset_information`,
`get_all_warnings_in_the_model`, `get_all_used_families_in_model`,
`get_all_project_units`, `get_category_by_keyword`, `get_elements_by_category` en
`get_parameter_value_for_element_ids` (toollijst van de connector in een
Claude Code-sessie). De skill beschreef dus niet verzonnen tools, maar die van
de verkeerde server. De eigen Lees-MCP neemt de meeste van die namen over
(`lees-mcp-koppeling.md` §4).

**Stand 2026-08-28:** de tabel is vervangen door de twintig namen uit §4, in de
skillbron `Snetselaar_BIM/sci-bim-context/references/template-en-mcp.md`. Ook de
repo-naam, de poort en de startwijze in die sectie zijn gelijkgetrokken. De rem
uit `../CLAUDE.md` §3 regel 2 gold zolang niet vaststond welke server draaide;
dat staat nu vast.

**Opgelost 2026-08-28.** De gecorrigeerde skill is die dag naar claude.ai
geüpload en vastgelegd met `skill_uploads.ps1 -Mark sci-bim-context` (sha256
`6513f443…`, commit `aec356d`). Wat Claude in een gesprek leest komt nu overeen
met §4. Het conflictblok hierboven is daarmee historisch — het beschrijft de
skill zoals hij tot 2026-08-28 luidde en is bewaard als bronketen, niet als een
openstaande tegenspraak.

> **Conflict met skill `sci-bim-context`, gevonden bij de health check van
> 2026-08-31 — opgelost dezelfde dag.** `references/template-en-mcp.md` §C
> telde nog "Twintig stuks" tools en noemde `execute_revit_code` —
> "Willekeurige IronPython in de Revit-context" — als bestaande rij, inclusief
> de zin dat worksets, warnings, project units en per-element-parameters daar
> allemaal doorheen gingen. Die route bestond op dat moment al niet meer (zie
> hierboven); de skillbron was dus opnieuw stale, drie dagen na de vorige
> correctie. Zie `outputs/2026-08-31-healthcheck.md` bevinding 1.
>
> **Opgelost 2026-08-31.** De skillbron is bijgewerkt (rij verwijderd,
> "Twintig" → "Negentien", de tekst over de ontsnappingsklep herschreven met de
> Nonica-connector als vervangende leesroute), ingepakt met `pack_skill.ps1`,
> geüpload naar claude.ai en vastgelegd met `skill_uploads.ps1 -Mark
> sci-bim-context` (sha256 `97ec9542…`, commit `921994f`). Wat Claude in een
> gesprek leest komt weer overeen met §4 hierboven.
