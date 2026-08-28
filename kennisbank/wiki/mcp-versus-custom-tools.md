---
titel: MCP versus custom tools — wanneer welke, en de Autodesk 2027-server
status: concept
laatst-bijgewerkt: 2026-08-28
bronnen:
  - "raw/2026-08-27_revit_mcp_bronnen_transcripties.md §6, §7 en §8"
  - skill sci-bim-context §1
verwant:
  - mcp-revit-koppeling.md
  - mcp-eigen-tools-toevoegen.md
  - revit-bronnen-en-communities.md
skill: sci-bim-context
---

# MCP versus custom tools

`mcp-eigen-tools-toevoegen.md` beschrijft *hoe* je een MCP-tool bouwt. Dit
artikel gaat over de vraag ervóór: *wanneer* je de AI-brug inzet en wanneer een
gewone pyRevit-knop beter is. De afweging komt van Erik Frits en BIM Pure
(`raw/2026-08-27_revit_mcp_bronnen_transcripties.md` §8), en valt vrijwel samen
met de eerste SCI-werkafspraak.

---

## 1. De afweging

| Aspect | Custom tools (Dynamo / pyRevit / C#) | MCP / AI-brug |
|---|---|---|
| Voorspelbaarheid | Zelfde input, zelfde output. | Variabel; het model kan hallucineren of anders interpreteren. |
| Snelheid | Direct bij één klik. | Trager; heen-en-weer tussen AI en tool. |
| Schaal | Geschikt voor bulk (10.000 elementen). | Beperkt; de AI stopt geregeld halverwege grote datasets. |
| Kosten | Eenmalige bouwtijd, daarna gratis. | Per token; grote context wordt een maandrekening. |
| Flexibiliteit | Star; alleen de geprogrammeerde logica. | Hoog; vangt ad-hoc en vage vragen op. |
| Toepassing | Repetitief werk, kwaliteitscontrole, geometrische bulk. | Modelanalyse, export, ad-hoc vragen, prototyping. |

De twee kolommen zijn geen concurrenten maar een verdeling. Bulk en herhaling
horen bij een knop, verkennen en eenmalige vragen bij de brug.

## 2. De risico's van AI in een live model

Erik Frits waarschuwt voor drie dingen
(`raw/2026-08-27_revit_mcp_bronnen_transcripties.md` §8):

- **Dubbelzinnige prompts.** "Hernummer de deuren van 1 tot 10" kan de AI lezen
  als "pak deur 1, maak er 10 van" in plaats van een oplopende hernummering.
- **Destructieve acties zonder bevestiging.** Er is een praktijkgeval (Cursor)
  waarin een AI-tool op een verkeerd begrepen prompt een complete database met
  back-ups in negen seconden wiste. In Revit kan dat views of modelonderdelen
  raken.
- **Black box.** Een neuraal netwerk toont zijn logica niet; je weet nooit zeker
  welke stappen zijn toegepast.

Dit raakt direct de brug uit `mcp-revit-koppeling.md`. Twee faalpunten daar zijn
de technische kant van precies deze risico's: `execute_revit_code` opent geen
eigen transactie (§4) en een timeout annuleert de lopende bewerking niet (§3). De
AI kan dus modelwijzigende code sturen zonder omhullende transactie, en bij een
timeout niet wéten dat de wijziging tóch doorliep.

## 3. Het advies — bouw tools *met* AI, niet autonome MCP

Na de demo keert de praktijk vaak terug naar handmatige controle of gewone
scripts; MCP is deels overgehypet
(`raw/2026-08-27_revit_mcp_bronnen_transcripties.md` §8). Het advies van Erik
Frits: richt je niet op een volledig autonome MCP-server in productie, maar op
**het schrijven van custom tools met behulp van AI**. Dan gebruik je de snelheid
van AI om code te genereren, en houd je de controle over werking, snelheid en
voorspelbaarheid van de knoppen.

**Dit is woordelijk de eerste SCI-werkafspraak.** `sci-bim-context` §1: niet
overcompliceren, check eerst of Revit het native kan, houd de controle bij de
ontwikkelaar. Een onafhankelijke bron komt tot dezelfde conclusie. Het versterkt
ook stap **P** uit het P.R.O.C.E.S.S.-kader in `revit-bronnen-en-communities.md`
§2, en het verklaart waarom deze repo een pijplijn van *custom tools* is
(twintig vaste endpoints, §4 van `mcp-revit-koppeling.md`) met `execute_revit_code`
als uitzondering, en niet andersom.

## 4. De officiële Autodesk MCP-server in Revit 2027

Autodesk heeft in Revit 2027 een eigen ingebouwde **Autodesk Public MCP Server**
uitgebracht als Technical Preview
(`raw/2026-08-27_revit_mcp_bronnen_transcripties.md` §6). Beschikbaar via Autodesk
Access / Product Updates onder "MCP Server technical preview".

Voordeel: een officiële, door Autodesk ondersteunde integratie.

Beperkingen, stand van de beta per de bron (2026-08-27):

- werkt alleen in Revit 2027 of hoger;
- geen toegang tot model-warnings;
- veel elementen kunnen niet worden bewerkt of weggeschreven.

De vergelijking met de open-source pyRevit MCP (deze repo) valt volgens BIM Pure
uit in het voordeel van pyRevit: dat werkt vanaf Revit 2020, is open source, en
kan dankzij de community méér, waaronder warnings oplossen en data wegschrijven.
Conclusie van BIM Pure: op dit moment is de pyRevit- of Nonica-Tab-oplossing
superieur aan de officiële server.

Dit raakt de versiespanning die door de hele kennisbank loopt (2024 t/m 2027, zie
`rebar-api-parameters.md` §4). De officiële server verschuift de MCP-vraag naar
een Revit-versie die SCI grotendeels nog niet draait; tot dan blijft de brug uit
`mcp-revit-koppeling.md` de werkbare weg. [ONBEVESTIGD] Welke Revit-versies SCI in
productie draait staat niet in `sci-bim-context` §2; dat bepaalt of de Autodesk
2027-server op afzienbare termijn überhaupt in beeld komt.

## 5. Wat Claude Code met de brug kan — drie waarnemingen

BIM Pure demonstreert de combinatie pyRevit MCP + Claude Code
(`raw/2026-08-27_revit_mcp_bronnen_transcripties.md` §7). Drie concrete
waarnemingen, als ijkpunt voor wat haalbaar is:

- **Warnings.** Claude loste in een test **20 van de 86** actieve model-warnings
  zelf op (dubbele elementen, eenvoudige verbindingsfouten) en vroeg bij
  complexere overlappingen om menselijke tussenkomst. Warnings oplossen kan alleen
  via `execute_revit_code`; een eigen tool ervoor bestaat in deze repo niet (§4
  van `mcp-revit-koppeling.md`).
- **Gegenereerde code als ribbon-knop.** Werkt een script goed, dan kan Claude
  Code er een pyRevit-knop van maken: het maakt de mappenstructuur aan en voegt
  een tab of knop toe. Dat is de brug tussen "ad-hoc via MCP" en "vaste tool",
  precies de richting die §3 aanraadt.
- **Materiaal opruimen.** Claude schoonde een rommelige materialenlijst op,
  herkende inconsistente prefixes (underscore versus dash), **vroeg de gebruiker
  om de gewenste prefix** en voegde daarna dubbele materialen samen. Het
  bevestigingsmoment is het verschil tussen bruikbaar en gevaarlijk (zie §2).

Deze drie zijn demonstraties uit video's, geen metingen op een SCI-model.
[ONBEVESTIGD] Of dezelfde resultaten gelden op de zwaardere SCI-projectmodellen;
dat is niet nagemeten.
