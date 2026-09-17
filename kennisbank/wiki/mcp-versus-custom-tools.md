---
titel: MCP versus custom tools — wanneer welke, en de Autodesk 2027-server
status: concept
laatst-bijgewerkt: 2026-09-17
bronnen:
  - "raw/2026-08-27_revit_mcp_bronnen_transcripties.md §6, §7 en §8"
  - "raw/2026-08-31-uitgebreide-transcriptie-ai-bim-revit-automation-.md §1 en §7"
  - skill sci-bim-context §1
  - "waargenomen: projectmodellen S-9479_R25 (2026-09-15), S-9497_R27 (2026-09-16), S9475_R25 (2026-09-15)"
  - "KNOWN_ISSUES.md (repo-root, 2026-09-09)"
verwant:
  - mcp-revit-koppeling.md
  - mcp-eigen-tools-toevoegen.md
  - revit-bronnen-en-communities.md
  - vyssuals-datavisualisatie.md
  - ai-tools-voor-pyrevit-ontwikkeling.md
  - appartementdata-genereren-met-ai.md
  - rebar-api-parameters.md
  - routes-thread-veiligheid.md
  - lees-mcp-koppeling.md
skill: sci-bim-context
---

# MCP versus custom tools

`mcp-eigen-tools-toevoegen.md` beschrijft *hoe* je een MCP-tool bouwt. Dit
artikel gaat over de vraag ervóór: *wanneer* je de AI-brug inzet en wanneer een
gewone pyRevit-knop beter is. De afweging komt van Erik Frits en BIM Pure
(`raw/2026-08-27_revit_mcp_bronnen_transcripties.md` §8), en valt vrijwel samen
met de tweede SCI-werkafspraak.

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

Dit raakt direct de brug uit `mcp-revit-koppeling.md`. Twee faalpunten daar waren
de technische kant van precies deze risico's: `execute_revit_code` opende geen
eigen transactie en een timeout annuleert de lopende bewerking niet (§3). Het
eerste punt is eind augustus niet gerepareerd maar weggesneden — de route
bestaat niet meer, precies omdat modelwijzigende code zonder omhullende
transactie kon crashen (§4 van `mcp-revit-koppeling.md`). Het tweede,
timeout-risico, geldt onverkort voor de resterende routes. Daar kwam op
09-09-2026 een derde risico bij: model-aanrakende routes kunnen Revit laten
crashen omdat ze niet op de API-thread draaien (`routes-thread-veiligheid.md`).

## 3. Het advies — bouw tools *met* AI, niet autonome MCP

Na de demo keert de praktijk vaak terug naar handmatige controle of gewone
scripts; MCP is deels overgehypet
(`raw/2026-08-27_revit_mcp_bronnen_transcripties.md` §8). Het advies van Erik
Frits: richt je niet op een volledig autonome MCP-server in productie, maar op
**het schrijven van custom tools met behulp van AI**. Dan gebruik je de snelheid
van AI om code te genereren, en houd je de controle over werking, snelheid en
voorspelbaarheid van de knoppen.

**Dit is woordelijk de tweede SCI-werkafspraak.** `sci-bim-context` §1: niet
overcompliceren, check eerst of Revit het native kan, houd de controle bij de
ontwikkelaar. Een onafhankelijke bron komt tot dezelfde conclusie. Het versterkt
ook stap **P** uit het P.R.O.C.E.S.S.-kader in `revit-bronnen-en-communities.md`
§2, en het verklaart waarom deze repo een pijplijn van *custom tools* is
(negentien vaste tools, §4 van `mcp-revit-koppeling.md`). Tot eind augustus
was `execute_revit_code` de bewuste uitzondering op die regel; die uitzondering
is inmiddels zelf verwijderd (zie §2 hierboven), wat de kernstelling van dit
artikel eerder bevestigt dan tegenspreekt.

### Een tweede, onafhankelijke bron: Gavin Nicholls

`raw/2026-08-31-uitgebreide-transcriptie-ai-bim-revit-automation-.md` §1 (een
interview van BIM Pure met Gavin Nicholls) bevestigt hetzelfde standpunt vanuit
een andere hoek, zonder Erik Frits of `sci-bim-context` te kennen. Twee
punten die dit artikel versterken:

- **Marktverzadiging van AI-agents voor Revit.** Nick (BIM Pure) constateert
  dat vrijwel elke "nieuwe AI-agent voor Revit" die hem bereikt in wezen
  hetzelfde doet als de gratis pyRevit MCP-setup: een promptbalk die een knop
  aan de ribbon toevoegt. Zonder een écht onderscheidend kenmerk is daarvoor
  betalen zinloos — een marktargument náást het technische argument uit dit
  artikel.
- **Zelf bouwen versus een add-in kopen.** Volgens Gavin wordt het moeilijker om
  basisautomatisering voor duizenden dollars te verkopen als een bureau met AI
  intern een eenvoudiger versie bouwt; vaak volstaat een voortgangsbalk waar het
  product een uitgebreide tabel biedt. Nick noemt DiRoots als voorbeeld, en
  DiRoots staat in SCI's tech stack (`sci-bim-context` §2). Uitzondering volgens
  Gavin: producten met een eigen grafische engine of een complexe workflow.
  [ONBEVESTIGD] Of dat voor de DiRoots-tools die SCI gebruikt opgaat, is niet
  beoordeeld.
- **Klein bureau versus groot bureau.** Nick ziet Claude Code + pyRevit MCP als
  directe weg naar automatisering voor kleine teams zonder ontwikkelaars. Gavin
  vult aan dat grotere bureaus juist wegblijven van low-code, omdat versiebeheer
  en afhankelijkheden bij veel gebruikers zwaar worden. SCI zit daartussen: een
  eigen lint met promotiepijplijn (`bimtools-promotie`).
- **Determinisme als harde eis in productie.** Gavin: gebruikers in een
  professionele omgeving willen een tool die "exact doet wat hij belooft",
  niet een tool die gokt en achteraf blijkt dat er per ongeluk elementen
  verwijderd zijn zonder melding. Zijn conclusie: focus op deterministische
  automatisering en goede organisatorische dataschema's (een Markdown-bestand
  dat beschrijft hoe de AI door bedrijfsdata navigeert), zodat er een helder
  schema klaarligt zodra AI wél volledig betrouwbaar wordt.
- **Een deterministisch voorbeeld.** Gavin bouwt een add-in naar een blogpost uit
  2012 van Konrad Sobon (in de transcriptie gespeld als "Conrad"): een "listener" in Revit die voorkomt dat bepaalde
  elementen per ongeluk worden verwijderd, de gebruiker waarschuwt en de actie
  terugdraait. [ONBEVESTIGD] Met welk Revit-mechanisme (vermoedelijk een
  `IUpdater` of het `DocumentChanged`-event) staat niet in de bron; de blogpost
  is niet opgezocht.

Met deze tweede, onafhankelijke bron voldoet de kernstelling van dit artikel
aan de promotiedrempel uit `kennisbank/CLAUDE.md` §4 (twee onafhankelijke
bronnen). Het artikel als geheel blijft niettemin op `concept` staan: de
overige secties (Autodesk 2027-server, de drie Claude Code-waarnemingen)
leunen nog op de losse bron uit §6-7.

Een derde, eveneens onafhankelijke bevestiging van het mens-in-de-lus-patroon
staat in `vyssuals-datavisualisatie.md` §3: Vyssuals bouwt bewust geen AI in de
eigen software in en laat AI-voorstellen altijd eerst zichtbaar goedkeuren
voordat ze naar Revit worden geschreven.

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
Revit 2027 en hoger. **Stand 2026-09-17: SCI draait 2027 al in productie.**
Projectmodel `S-9497_R27` is op 2026-09-16 in Revit 2027 gemeten
(`ifc-import-verboden-tekens-in-namen.md` §4), naast 2025-modellen als
`S-9479_R25` en `S9475_R25`. De Autodesk-server is voor die projecten dus
bruikbaar. Hij dekt 2025 niet, en [ONBEVESTIGD] of 2024 en 2026 nog in productie
zijn, is niet gemeten. Zolang er naast 2027 oudere versies draaien, blijft een
versie-onafhankelijke leesroute nodig: de Nonica-connector of de eigen
Lees-MCP (`lees-mcp-koppeling.md`, aantoonbaar op 2025 en 2027).

## 5. Wat Claude Code met de brug kan — drie waarnemingen

BIM Pure demonstreert de combinatie pyRevit MCP + Claude Code
(`raw/2026-08-27_revit_mcp_bronnen_transcripties.md` §7). Drie concrete
waarnemingen, als ijkpunt voor wat haalbaar is:

- **Warnings.** Claude loste in een test **20 van de 86** actieve model-warnings
  zelf op (dubbele elementen, eenvoudige verbindingsfouten) en vroeg bij
  complexere overlappingen om menselijke tussenkomst. Dat liep in de demo via
  `execute_revit_code`. Die route is eind augustus uit deze repo verwijderd
  (`mcp-revit-koppeling.md` §4) omdat hij zonder sandbox of transactie kon
  crashen; warnings oplossen kan via deze repo dus **op dit moment helemaal
  niet meer**, gedemonstreerd of niet.
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

**Een vierde waarneming, uitgewerkt in een eigen artikel:** een complete
casus van BIM Pure waarin ad-hoc Area-analyse (afstanden, ramen, buren,
plafondhoogte) via de MCP-brug uitgroeit tot een vaste pyRevit-knop met
Excel-reconciliatie, inclusief een tokenbeheer-advies dat rechtstreeks
aansluit op de kosten-/schaalafweging in §1. Zie
`appartementdata-genereren-met-ai.md`.
