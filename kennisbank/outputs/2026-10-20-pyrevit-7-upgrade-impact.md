---
type: analyse
datum: 2026-10-20
onderwerp: Impact van een upgrade pyRevit 6.5.5 -> 7.0.0 op het SCI-lint en de MCP-koppeling, met testlijst
status: niet getest; analyse op release-notes en kennisbank, de scripts op W: zijn niet doorzocht
---

# pyRevit 7.0.0: upgrade-impact en testlijst — 2026-10-20

Vraag van de gebruiker: breekt een upgrade naar pyRevit 7.0.0 onze bestaande
scripts en architectuur, en is dat makkelijk recht te trekken? Het hele team
draait op 6.5.5 en dat wordt hard gecontroleerd (melding gebruiker,
2026-10-20).

## Bronnen en hun grenzen

- Release-notes v7.0.0, tag `v7.0.0.26278+2233`, uitgebracht op 06-10-2026 als
  stabiele release ("Latest"):
  https://github.com/pyrevitlabs/pyRevit/releases/tag/v7.0.0.26278%2B2233
- De notes zijn gelezen via een samenvatting van de pagina, niet woordelijk.
  Details zoals standaardwaarden van instellingen moeten tegen de echte tekst
  of de installatie geverifieerd worden.
- Deze repo: `revit_mcp/*.py` en `startup.py`, doorzocht op 20-10-2026.
- Kennisbank: `wiki/modeless-venster-persistente-engine.md`,
  `wiki/routes-thread-veiligheid.md`, `wiki/lees-mcp-koppeling.md`.
- **Niet doorzocht:** de lintscripts in 01_SCI, 02_Beta en 03_R&D op W:. Die
  zijn vanuit deze sessie niet bereikbaar. Alles wat over de lintscripts gezegd
  wordt, is dus een te toetsen risico en geen bevinding.

## Wat 7.0.0 ongemoeid laat

| Onderwerp | Stand in 7.0.0 | Bron |
|---|---|---|
| Revit-versies | 2021 t/m 2027 ondersteund, integratietests op 2022-2027. Onze 2024-2027 vallen erbinnen. | release-notes, #3585 |
| IronPython | 2.7.12 blijft de engine; 3.4.2 komt erbij. De actieve engine volgt de gekoppelde. | release-notes, #3637 |
| Bundle-metadata | `bundle.yaml` en inline `__dunder__`-metadata werken allebei, inline "at least through v8" | release-notes |
| Upgrade | 6.x wordt ter plekke bijgewerkt. De agent-runtime staat uit (`[agent] enabled = false`). | release-notes, migratienotities |
| Routes | Routes en de poort blijven bestaan na een sessie-reload (#3691). Serverfouten worden afgevangen en gelogd via `mlogger` (#3620). | release-notes |
| `__revit__` | Scripts krijgen altijd een echte `UIApplication` (#3682) | release-notes |

De MCP-fork in deze repo gebruikt van pyRevit alleen `routes`,
`routes.make_response`, `revit` en `DB` (`revit_mcp/views.py:7`,
`revit_mcp/status.py:7`, `revit_mcp/placement.py:8`, `revit_mcp/utils.py:2`).
Over geen van die vier melden de notes een wijziging. `to_net_list` en
`HOST_APP` komen in deze repo niet voor.

## Wat kan breken

| # | Wijziging in 7.0.0 | Raakt ons | Inschatting | Herstel |
|---|---|---|---|---|
| 1 | Versienummer 7.0.0 | De harde versiecontrole op 6.5.5 | Zeker raak | Check verruimen naar een lijst toegestane versies of ≥ 6.5.5. Waar de check zit, is in deze sessie niet ingezien. |
| 2 | `to_net_list` verwijderd, vervangen door `to_clr_list` (#3709) | Elk lintscript of elke lib die het aanroept | Onbekend; niet in deze repo | Zoeken op W:, dan vervangen |
| 3 | Eén gedeelde IronPython-engine voor preload, startup-scripts en postload, waar 6.5 per `startup.py` een eigen engine bouwde (#3655) | De `startup.py` van SCI, Beta, RnD en de MCP-extensie draaien nu in dezelfde engine | [ONBEVESTIGD] Als dat ook een gedeelde `sys.modules` betekent, kan een lib met dezelfde naam in meerdere extensies (bijv. `toollog`) bij de verkeerde extensie vandaan komen. Hetzelfde geldt voor globale namen die een `startup.py` achterlaat. | Testen (T4). Bij botsing: lib-modules per extensie een unieke naam geven. |
| 4 | Persistente engines houden hun scope nu vast, "Rocket Mode" (#3673) | ProjectNotitie (modeless, `persistent: true`) en de MCP-knop (ExternalEvent, AppDomain-data) | Klein. Het patroon van ProjectNotitie 1.8 (state op het handler-object, imports in de methode) werkt met en zonder scope-opruiming (`modeless-venster-persistente-engine.md`). | Testen (T5) |
| 5 | Output-venster rendert met WebView2 (Chromium) in plaats van de IE WebBrowser-control (#3592) | Scripts die eigen HTML, CSS of JS in het outputvenster zetten | [ONBEVESTIGD] Of lintscripts dat doen, is niet nagekeken. Gewone `print` en `output.print_table` lijken niet geraakt; de notes noemen `print_html` niet. WebView2 moet als runtime op de werkplek staan; op Windows 10/11 meestal al aanwezig. | Visueel nalopen (T6) |
| 6 | Inline metadata wordt bij het scannen van bundles standaard niet geparsed (snelheidskeuze); `[core] read_script_metadata` staat standaard op `true` | Knoptitels, tooltips, `__min_revit_ver__` uit inline `__title__`/`__doc__` | [ONBEVESTIGD] De samenvatting van de notes is hier tegenstrijdig. Kan betekenen dat een titel of tooltip in het lint anders wordt. | Lint vergelijken voor en na (T3); desnoods `bundle.yaml` gebruiken |
| 7 | Instellingen naar een getypeerde C#-configuratieservice (#3450, #3683) | Scripts die `script.get_config()` of `pyrevit.userconfig` lezen of schrijven, en de Routes-instellingen in `pyRevit_config.ini` | [ONBEVESTIGD] De notes noemen geen API-breuk, wel strengere regels voor aliassen | Testen (T7) |

Het meeste kost minuten: punt 1, 2 en 6 zijn zoeken en vervangen of één
instelling. Echt werk kan alleen uit punt 3 komen, en alleen als lib-namen
tussen de extensies botsen.

## Testlijst

Uitvoeren op één werkplek (AWO) voordat het team overgaat. Per test minimaal
Revit 2024 en 2027; 2025 en 2026 draaien ook in productie. Vóór de upgrade
schermafdrukken maken van de drie tabbladen (01_SCI, 02_Beta, 03_R&D) voor T3.

| # | Test | Hoe | Geslaagd als |
|---|---|---|---|
| T1 | Versiecontrole | Eerst de check aanpassen, dan pyRevit 7.0.0 installeren en Revit starten | Geen blokkade of waarschuwing; pyRevit → About toont 7.0.0 |
| T2 | `to_net_list` | Op W: zoeken naar `to_net_list` in alle `.py` onder de drie extensies, inclusief `lib` en `hooks` | Nul treffers, of alle treffers vervangen door `to_clr_list` |
| T3 | Lint compleet | Alle drie de tabbladen vergelijken met de schermafdrukken van vóór de upgrade | Elke knop staat er, met dezelfde titel, tooltip en versieregel |
| T4 | Gedeelde engine, libs | Per extensie een knop draaien die een gedeelde lib gebruikt (bijv. een knop met `toollog`), en in `Gebruikslog.csv` nakijken of de regel klopt. Daarna in de RevitPythonShell of de nieuwe Python Shell `import toollog; print(toollog.__file__)` | Elke knop logt correct; het pad van de lib past bij de extensie of is overal hetzelfde bestand |
| T5 | Persistente engine | ProjectNotitie openen, tekst typen, Opslaan, venster sluiten via het kruisje, opnieuw openen. Daarna de MCP-knop starten en een lees- en een `dry_run`-schrijfaanroep doen | Geen crash; notitie bewaard; de MCP-knop antwoordt |
| T6 | Outputvenster | De scripts draaien die het meest in het outputvenster schrijven (tabellen, links, gekleurde regels, bijv. Plot met de rode regels uit 2.15) | Opmaak en klikbare element-links werken |
| T7 | Instellingen | Een knop met eigen instellingen (`get_config`) openen, wijzigen, Revit herstarten | Instelling is bewaard |
| T8 | MCP-fork (deze repo) | `/status/` aanroepen op de ingestelde poort (`REVIT_PORT`, 48884 of 48885), daarna pyRevit → Reload en opnieuw `/status/` | HTTP 200 voor en na de reload; Revit loopt niet vast |
| T9 | Opstarttijd | Tijd van Revit starten tot het lint geladen is, voor en na | Ter informatie; de notes beloven fors sneller herladen |
| T10 | Reload na modeless gebruik | ProjectNotitie gebruiken, dan pyRevit → Reload | Ter informatie: in 6.5.5 liep Revit hier vast (`modeless-venster-persistente-engine.md`). Gaat het nu goed, dan die waarschuwing in het artikel bijwerken. |

T1, T2 en T3 zijn blokkerend. T4 t/m T8 bepalen of het team kan overstappen.
T9 en T10 zijn alleen ter informatie.

## Buiten deze vraag

7.0.0 levert een eigen MCP-server mee (`pyrevit mcp install claude`, de
agent-runtime, gemarkeerd als experimenteel). Wijzigingen lopen standaard via
goedkeuring in Revit en opslaan of synchroniseren is geblokkeerd tijdens een
run (release-notes). Dat raakt direct aan de keuze tussen deze fork, de
Lees-MCP en Nonica (`routes-thread-veiligheid.md` §6). Het is een aparte
afweging en hoort niet in de upgrade-test.
