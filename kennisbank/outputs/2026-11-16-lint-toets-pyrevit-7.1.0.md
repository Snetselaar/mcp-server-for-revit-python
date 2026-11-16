---
datum: 2026-11-16
vraag: "toets het lint tegen pyRevit 7.1.0"
bronnen:
  - "pyrevitlib 7.1.0.26319+1907, geïnstalleerd in %APPDATA%\\pyRevit-Master (pyrevit --version, 2026-11-16)"
  - "pyrevitlib 7.0.0.26278+2233 uit github.com/pyrevitlabs/pyRevit, tag v7.0.0.26278+2233"
  - "lint: gedeelde Snetselaar.extension (234 .py) + AWO 01_SCI (153), 02_Beta (20), 03_R&D (205)"
---

# Lint tegen pyRevit 7.1.0

**Uitkomst: geen breuk gevonden.** Elke pyrevit-API die het lint gebruikt, bestaat
nog in 7.1.0 met een verenigbare signatuur. De engine blijft IronPython 2.7.12
(`Engine: DEFAULT (2712)` in `pyrevit env`). De toets tegen 7.0.0 (04-11-2026)
blijft dus geldig. Hieronder staat alleen wat tussen 7.0.0 en 7.1.0 veranderde.

## Methode

Dit is een statische toets. Een script verzamelt alle `from pyrevit… import`, `import pyrevit…`
en `<module>.<naam>`-gebruik in het lint (48 namen) en controleert per naam
of die in 7.1.0 bestaat. Daarna vergelijkt het de AST van 7.0.0 met die van
7.1.0. Methodes van het outputvenster (`output.print_md` enz.) zijn apart
vergeleken. Het script staat niet in de repo, het was eenmalig.

Vijf namen gaf de scan als "ontbrekend". Bij nalezen zijn het allemaal valse
meldingen:
- `revit.doc` en `revit.uidoc` zijn properties van de `RevitWrapper` die
  `pyrevit.revit` in `sys.modules` zet;
- `from pyrevit import Autodesk` komt uit de .NET-namespace;
- `pyrevit.__file__` en `script.py` zijn een modulekenmerk en een bestandsnaam
  in een string.

## Gewijzigd tussen 7.0.0 en 7.1.0, en wat het lint ervan merkt

| API | Wijziging | Gevolg voor het lint |
|---|---|---|
| `revit.events.add_handler` / `remove_handler` | koppelen nu via CLR `EventInfo` en geven de delegate terug | AutoSave (01_SCI) gebruikt precies dat contract (delegate bewaren, later meegeven). Geen actie. |
| `script.get_logger` | geeft `get_bound_logger(...)`, dezelfde klasse `LoggerWrapper` | dezelfde methodes. Geen actie. |
| `revit.Transaction` | nieuw optioneel argument `failures_preprocessor` | additief. Geen actie. |
| `forms.SelectFromList` | checkbox reageert op `Click` i.p.v. `Checked`/`Unchecked`, dubbele items worden ontdubbeld | het lint subclasst het niet en gebruikt geen `check_selected`. Gedrag voor de gebruiker gelijk. |
| `forms.CommandSwitchWindow` | breedte en teksten per taal | cosmetisch. |
| `forms.WPFWindow` contrastlogica | via een style-setter i.p.v. een directe Foreground | cosmetisch; dialogen met een eigen Foreground blijven ongemoeid. |
| `output.linkify` / `linkmaker.make_link` | lijsten langer dan 2000 tekens krijgen een token-link | **verbetering**: de klik-limiet van ~110 elementen vervalt op 7.1. Werkt alleen als het team op 7.1 zit. |
| `EXEC_PARAMS` | zoekt de waarde eerst in de scope van het draaiende script | AutoSave en Lees_MCP gebruiken `EXEC_PARAMS.exec_id` als `__namespace__`. Dat is onder IronPython zonder effect. Geen actie. |
| outputvenster | nieuw: `on_message`, `post_message`, `supports_messages` | additief. |

## Wat niet getoetst is

- **Live:** op 7.1.0 draaiden vandaag alleen beide startup.py's (pyRevit-versiecheck,
  CSV-regels 07:42 en 07:49) en de Lees-MCP-knop. Geen modelbewerkende knop,
  geen dialoog, geen AutoSave.
- C#-runtimewijzigingen (ScriptExecutor, IronPythonEngine, WebView2-renderer)
  vallen buiten een statische Python-toets.
