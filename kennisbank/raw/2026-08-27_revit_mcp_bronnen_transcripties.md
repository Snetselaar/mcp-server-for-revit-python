# 2026-08-27 - Revit MCP Server: AI Bridge vs. Custom Tools

## Uitgebreide Transcripties en Synthese van de Bronnen

Dit document bevat een gedetailleerde, uitgebreide synthese en transcriptie-samenvatting van alle 10 bronnen in het notebook over de Revit MCP (Model Context Protocol) Server. Het document belicht de verschillen tussen een AI-gestuurde koppeling (AI Bridge) en traditionele custom tools (zoals pyRevit, C#, of Dynamo), de installatiestappen, het maken van eigen tools, en de strategische afwegingen.

---

## 1. Introductie & Wat is Revit MCP Server?
Het **Model Context Protocol (MCP)** is een open standaard (ontwikkeld door Anthropic) die fungeert als een universele brug tussen AI-modellen (Large Language Models, met name Claude) en lokale applicaties zoals Autodesk Revit. 

*   **De AI-Brug:** MCP stelt gebruikers in staat om in natuurlijke taal (bijv. Engels) vragen te stellen over een Revit-model of wijzigingen aan te vragen. De AI kan deze verzoeken begrijpen en vertalen naar specifieke acties met behulp van vooraf gedefinieerde "MCP-tools".
*   **De Organisatie-analogie (Erik Frits):** 
    *   **De Client (Klant):** De Revit-gebruiker die vraagt om wijzigingen (bijv. "hoeveel deuren zijn er op niveau 2?").
    *   **De Project Manager (AI/Claude):** Begrijpt het verzoek en maakt een plan om het uit te voeren.
    *   **De Workers (MCP Tools):** Lokale script-componenten met specifieke vaardigheden die door de Project Manager worden aangestuurd.
    *   **Het Project (Revit Model):** Wordt gelezen of gewijzigd door de workers, waarna de status wordt teruggekoppeld aan de Project Manager en uiteindelijk aan de klant.
*   **De Twee-Server Architectuur:** pyRevit MCP draait niet als één enkel blok, maar maakt gebruik van een keten van twee actieve servers:
    1.  **MCP Server (`main.py`):** Draait lokaal op Python 3 (FastMCP). Dit is de server die rechtstreeks met de LLM (bijv. Claude Desktop of Claude Code) praat via de MCP-standaard (stdio of HTTP).
    2.  **pyRevit Routes (REST API):** Dit is een lichtgewicht webserver die *binnen* het Revit-proces draait (geschreven in IronPython). Het luistert standaard op poort `48884` en voert de daadwerkelijke Revit API-commando's uit.

---

## 2. Infrastructuur & Architectuur van pyRevit MCP
Wanneer een AI-agent een actie uitvoert, verloopt de communicatie via de volgende keten:
```
Claude / AI Client
       │
       │ (Model Context Protocol via stdio of HTTP)
       ▼
  main.py (MCP Server op Python 3)
       │
       │ (HTTP POST/GET requests naar http://localhost:48884)
       ▼
  pyRevit Routes (REST API draaiend binnen Revit)
       │
       │ (Revit API Calls in IronPython)
       ▼
  Revit Applicatie (Grafische interface / model)
```

### Transport Modes van de MCP Server
De MCP-server (`main.py`) ondersteunt verschillende manieren om verbinding te maken met AI-clients:
*   **Stdio (Standaard):** Gebruikt standaard input/output. Dit is de standaardmodus voor Claude Desktop en Claude Code.
*   **SSE (Server-Sent Events):** Wordt gebruikt voor oudere clients.
*   **Streamable-HTTP:** Voor moderne HTTP-gebaseerde AI-koppelingen.
*   **Combined:** Start de server op (`http://127.0.0.1:8000`) met zowel SSE als HTTP-endpoints actief (`uv run --with "mcp[cli]" main.py --combined`).

### Bestaande / Ondersteunde Tools (Status overzicht)
De python-extensie bevat standaard al een rijke set aan ingebouwde tools:
*   `get_revit_status`: Controleert of de API actief is en reageert.
*   `get_revit_model_info`: Haalt algemene modelinformatie op (zoals bestandsnaam).
*   `list_levels`: Geeft alle niveaus met hun hoogtes (in feet) weer.
*   `get_revit_view` & `list_revit_views`: Exporteert een specifiek Revit-view als afbeelding naar de AI of toont alle exporteerbare views.
*   `place_family` & `list_families`: Familie-instanties plaatsen op specifieke locaties of lijsten opvragen (inclusief categorieën).
*   `execute_revit_code`: De krachtigste tool. Hiermee kan de AI rechtstreeks rauwe IronPython-code genereren en uitvoeren binnen Revit om ad-hoc problemen op te lossen.
*   `launch_revit` & `open_document`: Start Revit op afstand (met een specifiek bestand) en polt de status van de pyRevit Routes server tot deze gereed is.

---

## 3. Stap-voor-Stap Setup van pyRevit MCP
Erik Frits en BIM Pure schetsen een helder stappenplan om pyRevit MCP operationeel te krijgen op een lokale machine.

### Stap 1: Vereisten controleren
*   **Revit installatie:** Compatibel met elke versie vanaf Revit 2020 (pyRevit vereist). *Opmerking: Vermijd pyRevit versie 6.5.3 vanwege een bug in de Routes module; versie 6.4.0 wordt aangeraden.*
*   **AI-agent:** Claude Desktop, Claude Code, Cursor of een ander platform met MCP-ondersteuning (betaald account vaak noodzakelijk voor API-credits).
*   **Python & UV:** Python 3.10 of hoger. Installeer **UV** (Python package manager) voor een snelle, schone installatie.
*   **Admin-rechten:** Nodig om appdata-mappen te kunnen bewerken.

### Stap 2: pyRevit MCP Extensie installeren
1.  Open Revit, ga naar de **pyRevit tab**.
2.  Klik op **Extensions**.
3.  Scroll omlaag naar **MCP Server for Revit Python** en klik op **Install extension**.
4.  De extensie wordt standaard geïnstalleerd in `%APPDATA%\Roaming\pyRevit\Extensions`.

### Stap 3: Activeer de Routes Server
1.  Klik in pyRevit op **Settings**.
2.  Navigeer naar **Routes** en zet de schakelaar **Routes Server** aan. pyRevit start nu een interne HTTP-server op poort `48884`.

### Stap 4: Beveiliging instellen (Belangrijk!)
Standaard luistert de Routes-server op adres `0.0.0.0`. Dit betekent dat iedereen binnen hetzelfde netwerk (LAN of VPN) potentieel toegang heeft tot je Revit-model.
*   **Oplossing:** Beperk dit tot `localhost` via de pyRevit CLI.
*   Open de terminal (cmd) en voer het volgende commando uit:
    `pyrevit config routes --host localhost`
*   Herlaad pyRevit (**pyRevit > Reload**) om de wijziging toe te passen. Controleer in Settings > Routes of er nu `localhost` staat.

### Stap 5: Verbinding testen
Open je browser en ga naar:
`http://localhost:48884/revit_mcp/status/`
Als het werkt, krijg je een JSON-respons terug:
```json
{"status": "active", "health": "healthy", "revit_available": true, "document_title": "jouw_bestand_naam", "api_name": "revit_mcp"}
```

### Stap 6: AI-Agent Koppelen
Je kunt de absolute map-path van de geïnstalleerde extensie kopiëren. Geef deze map door aan je AI-client.
*   **Claude Desktop configureren:**
    Voeg de volgende configuratie toe aan het bestand `claude_desktop_config.json` (te vinden via Settings > Developer > Edit Config in de Claude app):
    ```json
    {
      "mcpServers": {
        "Revit Connector": {
          "command": "uv",
          "args": [
            "run",
            "--with",
            "mcp[cli]",
            "mcp",
            "run",
            "/absolute/path/to/main.py"
          ]
        }
      }
    }
    ```
*   **Claude Code (Terminal):**
    Voeg de server toe via de CLI:
    `claude mcp add -s user "Revit-Connector" -- uv run --with "mcp[cli]" mcp run /absolute/path/to/main.py`

---

## 4. Het maken van Custom pyRevit MCP Tools
Wanneer je complexere taken wilt automatiseren, is het verstandig om specifieke tools te schrijven in plaats van de AI alles via ad-hoc code te laten oplossen. Dit proces bestaat uit drie hoofdonderdelen.

### Deel 1: Maak de Route Module in Revit
Maak een nieuw Python-bestand aan in de Revit-extensie map onder `revit_mcp/` (bijv. `revit_mcp/selection.py`). Dit script draait binnen Revit onder IronPython:
```python
# -*- coding: UTF-8 -*-
from pyrevit import routes, revit, DB
import json
import logging

logger = logging.getLogger(__name__)

def register_selection_routes(api):
    # GET-endpoint: Haalt informatie op
    @api.route('/get_selection/', methods=["GET"])
    def get_selection(doc, uidoc):
        try:
            ids = [str(el_id.IntegerValue) for el_id in uidoc.Selection.GetElementIds()]
            return routes.make_response(data={"status": "success", "data": ids})
        except Exception as e:
            return routes.make_response(data={"error": str(e)}, status=500)

    # POST-endpoint: Wijzigt het model (vereist een Revit Transaction)
    @api.route('/set_selection/', methods=["POST"])
    def set_selection(doc, uidoc, request):
        try:
            data = json.loads(request.data) if isinstance(request.data, str) else request.data
            element_ids = data.get("element_ids", [])
            
            # Revit transactie starten voor modelwijzigingen
            t = DB.Transaction(doc, "Set Selection via MCP")
            t.Start()
            try:
                # Converteer strings naar ElementIds en selecteer ze
                from System.Collections.Generic import List
                net_list = List[DB.ElementId]()
                for id_str in element_ids:
                    net_list.Add(DB.ElementId(int(id_str)))
                uidoc.Selection.SetElementIds(net_list)
                t.Commit()
                return routes.make_response(data={"status": "success", "selected": len(element_ids)})
            except Exception as tx_err:
                if t.HasStarted() and not t.HasEnded():
                    t.RollBack()
                raise tx_err
        except Exception as e:
            return routes.make_response(data={"error": str(e)}, status=500)
```

### Deel 2: Maak de MCP Tool Module
Maak het bijbehorende Python-bestand voor de Python 3 MCP-server in de map `tools/` (bijv. `tools/selection_tools.py`):
```python
# -*- coding: utf-8 -*-
from mcp.server.fastmcp import Context
from .utils import format_response

def register_selection_tools(mcp, revit_get, revit_post, revit_image=None):
    @mcp.tool()
    async def get_revit_selection(ctx: Context) -> str:
        """
        Haalt de Element IDs op van de elementen die momenteel geselecteerd zijn in de Revit UI.
        """
        response = await revit_get("/get_selection/", ctx)
        return format_response(response)

    @mcp.tool()
    async def set_revit_selection(element_ids: list[str], ctx: Context = None) -> str:
        """
        Selecteert specifieke Element IDs in de actieve Revit weergave.
        Args:
            element_ids: Een lijst met Element ID-strings om te selecteren.
        """
        payload = {"element_ids": element_ids}
        response = await revit_post("/set_selection/", payload, ctx)
        return format_response(response)
```
*Opmerking: De docstring (`"""..."""`) onder de `@mcp.tool()` decorator is van cruciaal belang. Dit is de omschrijving die de AI leest om te bepalen of deze tool geschikt is voor de taak.*

### Deel 3: Registreer de nieuwe modules
1.  **Revit-zijde (`startup.py`):** Importeer `register_selection_routes` en voer deze uit binnen de hoofdregistratie-functie.
2.  **MCP-zijde (`tools/__init__.py`):** Importeer `register_selection_tools` en voer deze uit om de tools aan te melden bij de FastMCP-server.

### Ingebouwde Logging-functionaliteit toevoegen
Erik Frits demonstreert het belang van een audit-trail door een logging-functie in te bouwen. Door een lokaal logbestand bij te houden (bijv. in `%APPDATA%/pyRevit/pyrevit_mcp.log`), kan de beheerder precies zien welke tools door de AI zijn aangeroepen, op welk tijdstip, en welke elementen zijn beïnvloed. Dit is essentieel voor kwaliteitscontroles bij automatische modelbewerkingen.

---

## 5. Inspecteren en Debuggen via de MCP Inspector
Om er zeker van te zijn dat je custom tools naar behoren functioneren voordat je de AI ermee laat werken, kun je de **MCP Inspector** gebruiken.

1.  Open de terminal in de extensiemap van pyRevit MCP (waar `main.py` staat).
2.  Start de debugger met het commando:
    `mcp dev main.py`
3.  Dit start een lokale web-omgeving op (standaard `http://127.0.0.1:6274`).
4.  In dit verborgen controlepaneel kun je:
    *   De volledige lijst met actieve tools bekijken.
    *   Tools handmatig triggeren en de JSON-respons direct inspecteren.
    *   Zien of argumenten correct worden meegegeven en of foutmeldingen netjes worden afgevangen.
    *   De `execute_revit_code` tool testen door handmatig IronPython-code in te voeren (bijv. `from Autodesk.Revit.UI import TaskDialog; TaskDialog.Show("Hello", "Hello BIM World")`).

---

## 6. Officiële Revit 2027 MCP Server vs. pyRevit MCP
In Revit 2027 heeft Autodesk een officiële, ingebouwde **Autodesk Public MCP Server** (Technical Preview / Beta) geïntroduceerd. BIM Pure (Nick) vergelijkt deze officiële versie met de open-source pyRevit-oplossing.

### Autodesk MCP Server (Revit 2027):
*   **Voordelen:** Directe, officiële integratie ondersteund door Autodesk (beschikbaar via de Autodesk Access / Product Updates pagina onder "MCP Server retools technical preview").
*   **Beperkingen:** 
    *   Werkt uitsluitend in Revit 2027 of hoger.
    *   Is momenteel zeer beperkt in functionaliteit (zo heeft de beta geen toegang tot model-warnings en kunnen veel elementen niet worden bewerkt of weggeschreven).
*   **Gebruik met Claude Co-work:** BIM Pure toont hoe Claude via de co-work modus (waarbij lokale bestanden worden bewerkt) een HTML-dashboard genereert van alle model-elementen (gesorteerd op categorie, familie en type). Dit dashboard kan vervolgens automatisch worden opgemaakt in de huisstijl van de gebruiker door simpelweg een PDF met branding guidelines naar Claude te uploaden.

### pyRevit MCP Server:
*   **Voordelen:** Werkt op vrijwel alle Revit-versies (vanaf 2020), is volledig open-source en heeft dankzij de community veel meer actieve functies (inclusief het oplossen van warnings en schrijven van data).
*   **Conclusie (BIM Pure):** Op dit moment is de pyRevit- of Nonica Tab-oplossing superieur aan de officiële Autodesk MCP server, omdat deze breder inzetbaar is en veel meer diepgaande interactie met het model toestaat.

---

## 7. BIM Pure Workflow: pyRevit MCP + Claude Code (Terminal)
BIM Pure laat zien hoe de combinatie van **pyRevit MCP** en **Claude Code** (de terminalversie van Claude) momenteel de krachtigste AI-setup vormt voor BIM-engineers.

*   **Rauwe Code Uitvoeren via `execute_revit_code`:** De AI is niet beperkt tot vaste knoppen. Claude kan live een Python-script schrijven om bijvoorbeeld ad-hoc alle Revit-sheetnamen naar het Frans te vertalen.
*   **Warnings Oplossen:** Claude kan zelfstandig de warnings in een Revit-project analyseren. In een test slaagde Claude erin om 20 van de 86 actieve model-warnings automatisch op te lossen (bijvoorbeeld dubbele elementen of eenvoudige verbindingsfouten). Voor complexere overlappingen (zoals overlappende wanden) vroeg de AI netjes om menselijke tussenkomst.
*   **Gegenereerde Code als Knop op de Ribbon Pushen:** Als een door de AI gegenereerd script goed werkt, kun je Claude Code rechtstreeks vragen om hier een fysieke knop voor te maken in de Revit-interface. Claude maakt dan automatisch de benodigde pyRevit mappenstructuur aan en voegt een nieuwe tab of knop toe aan de Revit Ribbon (bijv. een "Pamphlets" tab met custom tools).
*   **Materiaal Opruimen (Case Study):** In een demonstratie schoont Claude een rommelige materialenlijst op. De AI identificeert inconsistenties in naamgeving (zoals prefixes met een underscore versus een dash), vraagt de gebruiker om bevestiging over de gewenste prefix (dash), en voegt dubbele materialen op een intelligente manier samen zonder de geometrie te beschadigen.

---

## 8. Strategische Afweging: MCP (AI Bridge) vs. Custom Tools
Een belangrijk terugkerend thema in de video's van Erik Frits is de nuchtere, strategische vergelijking tussen AI-gestuurde MCP-servers en traditionele, handgeschreven custom tools (Dynamo, pyRevit, C#).

| Aspect | Custom Tools (Dynamo / pyRevit / C#) | MCP / AI-gestuurde Bridge |
| :--- | :--- | :--- |
| **Voorspelbaarheid** | 100% voorspelbaar. Dezelfde input geeft altijd exact dezelfde output. | Variabel. AI-modellen kunnen hallucineren of opdrachten verschillend interpreteren. |
| **Snelheid** | Extreem snel. Code start direct op met één druk op de knop. | Trager. Vereist communicatie over en weer (AI denkt na, selecteert tool, voert uit). |
| **Schaalbaarheid** | Uitstekend geschikt voor bulk-processing (bijv. 10.000 elementen tegelijk). | Beperkt. AI heeft de neiging om 'lui' te worden bij grote datasets (stopt halverwege). |
| **Kosten** | Eenmalige ontwikkeltijd, daarna volledig gratis te draaien. | Kosten per token (API-verbruik). Grote contexten leiden tot hoge maandelijkse rekeningen. |
| **Flexibiliteit** | Star. Werkt alleen voor de exact geprogrammeerde logica. | Extreem flexibel. Kan ad-hoc vage of unieke vragen analyseren en beantwoorden. |
| **Toepassing** | Repetitieve taken, kwaliteitscontroles, geometrische bulkbewerkingen. | Modelanalyse, data-export, ad-hoc vragen stellen aan het model, snelle prototyping. |

### Risico's van AI-Automatisering
Erik Frits waarschuwt nadrukkelijk voor de gevaren van AI in live Revit-modellen:
1.  **Slechte of dubbelzinnige prompts:** Mensen formuleren instructies vaak vaag. Het hernummeren van deuren "van 1 tot 10" kan door de AI worden geïnterpreteerd als: "pak deur 1 en verander het nummer in 10", in plaats van een opeenvolgende hernummering.
2.  **Destructieve acties zonder bevestiging:** Er zijn praktijkvoorbeelden (zoals in Cursor) waarbij een AI-tool op basis van een verkeerd begrepen prompt een complete database en back-ups heeft verwijderd in 9 seconden. Binnen Revit kan een AI onbedoeld cruciale modelonderdelen of views verwijderen.
3.  **Gebrek aan controle:** AI-neurale netwerken zijn een 'black box'. Je weet nooit 100% zeker welke logica is toegepast.

### Conclusie & Advies van Erik Frits:
Hoewel MCP-servers spectaculaire LinkedIn-demo's opleveren, keert de praktijk na de demo vaak snel terug naar handmatige controle of traditionele scripts. MCP is momenteel deels overgehyped. 
*   **Het Advies:** Richt je focus niet primair op het volledig autonoom laten draaien van een MCP Server in productie. Richt je in plaats daarvan op **het schrijven van custom tools *met behulp van* AI**. Op die manier gebruik je de kracht van AI om snel code te genereren, maar behoud je als BIM-ontwikkelaar de volledige controle over de werking, de snelheid en de voorspelbaarheid van de knoppen in je Revit-toolbar. Mocht MCP in de toekomst de standaard worden, dan heb je met deze benadering alvast de perfecte basis gelegd wat betreft Python- en Revit API-kennis.
