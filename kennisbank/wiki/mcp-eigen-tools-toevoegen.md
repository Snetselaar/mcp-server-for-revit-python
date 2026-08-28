---
titel: Een eigen MCP-tool toevoegen aan deze repo
status: concept
laatst-bijgewerkt: 2026-08-28
bronnen:
  - "raw/2026-08-27_revit_mcp_bronnen_transcripties.md §4 en §5"
  - startup.py, tools/__init__.py (deze repo)
  - skill pyrevit-codestijl
  - skill bimtools-logging
verwant:
  - mcp-revit-koppeling.md
  - mcp-versus-custom-tools.md
skill: sci-bim-context
---

# Een eigen MCP-tool toevoegen

`mcp-revit-koppeling.md` §4 somt de twintig bestaande tools op. Dit artikel gaat
over het bouwen van een eenentwintigste. Het patroon komt uit de transcripties
van Erik Frits en BIM Pure (`raw/2026-08-27_revit_mcp_bronnen_transcripties.md`
§4) en is hier gelegd naast de echte registratieplekken in deze repo.

Een tool bestaat altijd uit **twee helften plus twee registraties**, precies
omdat de koppeling twee servers heeft (`mcp-revit-koppeling.md` §1). De ene helft
draait binnen Revit op IronPython 2.7, de andere buiten Revit op CPython 3.13.
Vergeet je één van de vier stukken, dan verschijnt de tool niet of geeft hij 404.

---

## 1. De route-module — binnen Revit

Een nieuw bestand in `revit_mcp/` (bijvoorbeeld `revit_mcp/selection.py`). Dit
draait binnen het Revit-proces onder **IronPython 2.7**, dus de beperkingen uit
`pyrevit-codestijl` gelden: geen f-strings, geen `pathlib`, `.NET`-collections
via `System.Collections.Generic`.

De regel is: een **GET-endpoint leest**, een **POST-endpoint wijzigt** en opent
daarvoor zelf een `Transaction`. Dat sluit aan op de vaststelling in
`mcp-revit-koppeling.md` §4 dat `execute_revit_code` géén omhullende transactie
opent — een eigen endpoint moet dat dus ook zelf doen.

```python
# IronPython 2.7 — revit_mcp/selection.py
# -*- coding: UTF-8 -*-
from pyrevit import routes, revit, DB
import json

def register_selection_routes(api):
    @api.route('/get_selection/', methods=["GET"])
    def get_selection(doc, uidoc):
        try:
            ids = [str(el_id.IntegerValue)
                   for el_id in uidoc.Selection.GetElementIds()]
            return routes.make_response(data={"status": "success", "data": ids})
        except Exception as e:
            return routes.make_response(data={"error": str(e)}, status=500)

    @api.route('/set_selection/', methods=["POST"])
    def set_selection(doc, uidoc, request):
        data = json.loads(request.data) if isinstance(request.data, str) else request.data
        element_ids = data.get("element_ids", [])
        t = DB.Transaction(doc, "Set Selection via MCP")
        t.Start()
        try:
            from System.Collections.Generic import List
            net_list = List[DB.ElementId]()
            for id_str in element_ids:
                net_list.Add(DB.ElementId(int(id_str)))
            uidoc.Selection.SetElementIds(net_list)
            t.Commit()
            return routes.make_response(data={"status": "success", "selected": len(element_ids)})
        except Exception:
            if t.HasStarted() and not t.HasEnded():
                t.RollBack()
            raise
```

De endpoint-handlers krijgen `doc` en `uidoc` automatisch mee van pyRevit Routes;
een POST-handler krijgt er `request` bij. Dat is dezelfde injectie die de
bestaande handlers in `revit_mcp/` gebruiken.

> **Let op — het voorbeeld uit de bron gebruikt verouderde API.** De regel
> `el_id.IntegerValue` breekt vanaf Revit 2026: `ElementId.IntegerValue` is daar
> vervangen door `ElementId.Value` (skill `pyrevit-codestijl`, geverifieerde
> breaking changes 2024→2027; ook vastgelegd in de memory
> `revit-api-verifieren-lokaal`). Voor code die op 2024 t/m 2027 moet draaien:
> vang beide af, of zoek de juiste vorm per doelversie op met `revit-api-docs`.
> De skill gaat hier voor op de transcriptie.

## 2. De tool-module — buiten Revit

Een bijbehorend bestand in `tools/` (bijvoorbeeld `tools/selection_tools.py`),
op **CPython 3.13**. Dit is de kant die de LLM ziet.

```python
# CPython 3.13 — tools/selection_tools.py
# -*- coding: utf-8 -*-
from mcp.server.fastmcp import Context
from .utils import format_response

def register_selection_tools(mcp, revit_get, revit_post, revit_image=None):
    @mcp.tool()
    async def get_revit_selection(ctx: Context) -> str:
        """Haalt de Element IDs op van de nu geselecteerde elementen in Revit."""
        response = await revit_get("/get_selection/", ctx)
        return format_response(response)

    @mcp.tool()
    async def set_revit_selection(element_ids: list[str], ctx: Context = None) -> str:
        """Selecteert de opgegeven Element IDs in de actieve Revit-weergave.
        Args:
            element_ids: lijst met Element ID-strings om te selecteren.
        """
        payload = {"element_ids": element_ids}
        response = await revit_post("/set_selection/", payload, ctx)
        return format_response(response)
```

De **docstring onder `@mcp.tool()` is de tekst die de AI leest** om te beslissen
of de tool bij de taak past (`raw/2026-08-27_revit_mcp_bronnen_transcripties.md`
§4). Een vage docstring betekent een tool die de AI op het verkeerde moment kiest
of overslaat. Schrijf hem als een instructie, niet als een label.

## 3. De twee registraties

De tool bestaat pas als beide servers hem kennen. Dit bevestigt de noot in
`mcp-revit-koppeling.md` §4: "een nieuwe tool vereist een wijziging in beide".

| Kant | Bestand | Wat |
|---|---|---|
| Revit | `startup.py` | `register_selection_routes` importeren en aanroepen in de hoofdregistratie |
| MCP | `tools/__init__.py` | `register_selection_tools` importeren en aanroepen |

Na de Revit-kant is een pyRevit-reload nodig, soms een volledige herstart — zelfde
faalpunt als `mcp-revit-koppeling.md` §5 punt 3. En let op faalpunt 6 daar: de
extensie draait uit `%APPDATA%\pyRevit\Extensions\`, niet uit deze repo. Een nieuw
bestand in `revit_mcp/` in de repo doet in Revit niets tot het naar die map is
gekopieerd.

## 4. Testen met de MCP Inspector

Voordat de AI de nieuwe tool aanraakt, valt hij handmatig te testen met de **MCP
Inspector** (`raw/2026-08-27_revit_mcp_bronnen_transcripties.md` §5). Vanuit de
map met `main.py`:

```bash
mcp dev main.py
```

Dat start een lokale webomgeving op `http://127.0.0.1:6274`. Daar staat de
volledige toollijst, kun je een tool handmatig aanroepen en de rauwe JSON-respons
zien, en controleren of argumenten goed doorkomen en fouten netjes worden
afgevangen. Ook `execute_revit_code` is er handmatig te voeden met IronPython, wat
sneller debugt dan via een chatsessie.

## 5. Logging — via de SCI-conventie, niet die van de bron

Erik Frits demonstreert een audit-trail door elke tool-aanroep weg te schrijven
naar `%APPDATA%/pyRevit/pyrevit_mcp.log`
(`raw/2026-08-27_revit_mcp_bronnen_transcripties.md` §4). Het idee — vastleggen
welke tool wanneer welk element raakte — is juist, maar SCI heeft hier zijn eigen
stelsel voor. Haak een nieuwe tool aan op de logstromen uit de skill
`bimtools-logging` (toollog `Gebruikslog.csv`) in plaats van een los logbestand
te beginnen. Anders ontstaat er een tweede, parallelle logplek die niemand
naleest.
