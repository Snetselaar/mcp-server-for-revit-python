---
titel: Revit 2027 — .NET 10, verplaatste add-in-map, BoundaryConditions en WebView2
status: concept
laatst-bijgewerkt: 2026-10-27
bronnen:
  - "raw/2026-10-27-externe-bronnen-revit-ifc-scia-tekla.md §A1-A4 en §F (zoekrondes 21-27 okt 2026, zelf ongeverifieerd)"
  - https://blog.autodesk.io/revit-2027-sdk-net-10-api-changes-and-additions/
  - https://blog.autodesk.io/webview2-landxml-refplane-and-revision/
  - https://github.com/pyrevitlabs/pyRevit/releases
  - "W:\\4 - Tijdelijk en verwijderen\\AWO\\Extensions\\03_R&D\\RnD.extension\\mcp_lezen\\api_snapshots\\revit_api_<jaar>_<build>.json.gz, gelezen 2026-10-27 (builds 24.3.60.12, 25.4.60.9, 26.5.0.55, 27.2.0.39)"
  - "skill revit-api-docs, SKILL.md §5 (runtime-tabel)"
  - "memory pyrevit-standaardversie (team op 6.5.5 sinds 02-10-2026)"
verwant:
  - zoek-revit-api.md
  - mcp-versus-custom-tools.md
  - modeless-venster-persistente-engine.md
  - externe-bronnen-ronde-okt2026.md
  - rebar-api-parameters.md
skill: revit-api-docs
---

# Revit 2027: runtime- en API-wijzigingen

Wat de zoekronde van oktober 2026 opleverde over compatibiliteit 2024-2027. De
bron is een bronnenlijst uit zoekresultaten; alleen §3 is in deze verwerking tegen
de echte API getoetst. De rest blijft `[ONBEVESTIGD]` tot de genoemde URL gelezen
is.

## 1. .NET 10

Revit 2027 draait op .NET 10; dat staat al in skill `revit-api-docs` §5, met 2025
en 2026 op .NET 8. De zoekronde voegt twee punten toe:

- [ONBEVESTIGD] Autodesk plant Revit 2025 en 2026 ook naar .NET 10 te migreren
  en heeft daarvoor een call for preview testing uitgeschreven. Microsoft stopt
  de support voor .NET 8 op 10-11-2026.
- [ONBEVESTIGD] Voorbeeld van breuk: de add-in AVAIL verliest drag-and-drop zodra
  de .NET 10-builds van 2025/2026 uitkomen.

> **Mogelijk conflict met skill `revit-api-docs`:** de skill noemt 2025 en 2026
> vast als .NET 8. Komt de migratie er, dan geldt die tabel alleen nog voor de
> huidige builds. Niet aangepast: de bron is ongeverifieerd. Te onderbouwen door
> de Autodesk-blog (`blog.autodesk.io/tag/net-10/`) te lezen.

Voor de pyRevit-scripts zelf verandert er niets; de runtime raakt gecompileerde
DLL's (skill `revit-api-docs` §5). Wel geraakt kunnen zijn: `clr.AddReference`
naar eigen DLL's, en WinForms- of WPF-gedrag dat per .NET-versie verschilt. De
scan daarop (de opdracht uit de bron) is nog niet gedaan.

## 2. All-users add-in-map verplaatst

[ONBEVESTIGD] In 2027 verhuist de map voor all-users add-ins van
`C:\ProgramData\Autodesk\Revit\Addins\20XX` naar
`C:\Program Files\Autodesk\Revit\Addins\20XX`, en `Application.AllUsersAddinsLocation`
verandert mee. pyRevit 6.4.0 zou de manifest-fix al bevatten.

`AllUsersAddinsLocation` bestaat als property in de 2027-momentopname; de waarde
is niet gemeten. Een grep op 27-10-2026 over de `.py`-bestanden onder
`W:\4 - Tijdelijk en verwijderen\AWO\Extensions` vond geen hardcoded
`ProgramData\...\Addins`-pad in het lint. De enige treffers zitten in
API-stubs van EF Tools (`save_DWGs.pushbutton\Autodesk\Revit\ApplicationServices.py`).
Installatiedocumenten zijn niet doorzocht.

## 3. BoundaryConditions: deprecated, niet verwijderd

Geverifieerd op 27-10-2026 in de lokale API-momentopnames (zie `zoek-revit-api.md`):

| Methode | 2024 | 2025 | 2026 | 2027 |
|---|---|---|---|---|
| `Creation.Document.NewPoint/Line/AreaBoundaryConditions` | ja | ja | ja | ja, **deprecated** |
| `BoundaryConditions.CreatePoint/Line/AreaBoundaryConditions` (static) | nee | nee | nee | ja |
| `BoundaryConditions.CanCreatePoint/Line/AreaBoundaryConditions` (static) | nee | nee | nee | ja |

De Obsolete-tekst in 2027: "This method is deprecated in Revit 2027 and may be
removed in a future version of Revit. Please use the
BoundaryConditions.CreatePointBoundaryConditions method instead." De bron zei
"vervangen"; dat is te sterk. Oude code blijft in 2027 werken.

Wie het nodig heeft: versie-switch op `hasattr(BoundaryConditions,
"CreatePointBoundaryConditions")`, niet op versienummer. Het lint gebruikt de oude
methodes niet: een grep op 27-10-2026 over alle bestanden onder
`W:\4 - Tijdelijk en verwijderen\AWO\Extensions` vond alleen de API-stub
`Creation.py` van EF Tools (`save_DWGs.pushbutton`). Geen actie nodig.

[ONBEVESTIGD] Dezelfde whats-new-pagina noemt ook wijzigingen in IFC-API, Rebar,
Energy en "Extended Properties" (externe data aan elementen hangen). Niet gelezen.

## 4. pyRevit-versie

De bron noemt als laatst geziene releases 6.4.0 (manifest-fix 2027), 6.5.0
(2027-compat) en 6.5.3. Het team draait sinds 02-10-2026 op 6.5.5 (memory
`pyrevit-standaardversie`); de bron loopt daar dus achter.

**pyRevit 7.0 is niet bevestigd.** Claims over een ingebouwde MCP, WebView2 en
snellere laadtijd kwamen uit een Gemini-samenvatting en staan niet op de
releasepagina. Niet op bouwen. Issue #2124 (IronPython deprecaten ten gunste van
CPython) is een open discussie zonder besluit; alleen volgen.

## 5. WebView2

[ONBEVESTIGD] Volgens de Autodesk-blog bevatten ontwikkelversies van Revit
WebView2 met de evergreen-runtime; oudere versies hadden problemen met de
cachemap en een vereiste herstart. Het demo-project
`zahmadsaleem/revit-webview2-demo` (2021, C#/WPF) heeft open bugs (zwart scherm in
een dockpanel, fatale fout) en is alleen bruikbaar als patroon voor
JS↔C#-berichten (`postMessage` / `ExecuteScriptAsync`).

Dat raakt elk HTML-paneel. Het pyRevit-outputvenster is een WinForms
WebBrowser met IE11-gedrag (memory `pyrevit-outputvenster-ie11`), dus geen
WebView2. Een eigen paneel op WebView2 moet eerst op 2024, 2025, 2026 en 2027
getest worden.
