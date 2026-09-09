# Zelfverbeterende Kennisbank met Claude: Een Strategische Gids

**Datum:** 25 augustus 2026
**Auteur:** Gecureerd door Gemini Notebook
**Bron:** YouTube-video "Build A Claude Knowledge Base That Self-Improves!" (Systems Made Better)

---

## 1. Introductie: Waarom een Zelf-Lernend "Second Brain"?

Het traditionele model van een persoonlijk kennissysteem (zoals Obsidian met tientallen plugins of complexe Notion-databases) vereist dat de gebruiker continu de rol van **bibliothecaris** op zich neemt. Je moet handmatig tags toewijzen, mappen indelen, backlinks leggen en verbanden leggen. Dit kost zoveel tijd en energie dat de meeste systemen na een tijdje verwateren en ongebruikt blijven.

Het zelf-verbeterende kennissysteem lost dit op door **Claude** de rol van bibliothecaris te geven. Jij focust je uitsluitend op het verzamelen en consumeren van informatie; de AI regelt de structuur, de onderlinge verbanden, de indexering en de kwaliteitsbewaking.

*   **Dag 1:** Je kennisbank is nog relatief eenvoudig en basic.
*   **Dag 100:** Het is uitgegroeid tot een uniek en onvervangbaar bedrijfsmiddel ("company asset") dat jouw persoonlijke perspectief, specifieke bronnen en verfijnde oordelen bevat.

---

## 2. De Systeemarchitectuur

Het volledige systeem is uiterst elegant in zijn eenvoud. Het vereist geen complexe databases, API's of vector stores (RAG). Het bestaat simpelweg uit **drie mappen** en **één centraal instructiebestand** op je computer waar Claude toegang toe heeft:

```text
kennisbank/
├── Claude.md                 # Het schema en de instructies voor de AI-bibliothecaris
├── raw/                      # De "rommella" voor ongestructureerde input
├── wiki/                     # De door AI gegenereerde en georganiseerde kennisartikelen
└── outputs/                  # Rapportages en briefings gegenereerd op basis van jouw vragen
```

### De Componenten in Detail:
1.  **`Claude.md` (Het Schema):** Dit is het belangrijkste bestand. Het bevat de regels voor hoe de AI-bibliothecaris moet omgaan met nieuwe bestanden, hoe de wiki-bestanden gestructureerd moeten worden, en welke specifieke focusgebieden (zoals productiviteit, energiesystemen, deep work) prioriteit hebben.
2.  **`raw/` (De Rommella):** Dit is de opvangbak voor al je ruwe informatie. Denk aan PDF's, transcripties van video's, screenshots, ruwe notities, artikelen of e-mails. Je hoeft hier niets te structureren; alles mag er ongesorteerd in.
3.  **`wiki/` (De Georganiseerde Kennis):** Dit is de gestructureerde database die volledig door Claude wordt beheerd en geschreven. Jij bewerkt deze map **nooit** handmatig. Claude leest de `raw/`-map en vertaalt deze naar thematische Markdown-bestanden in de `wiki/`-map, gekoppeld aan een centrale `index.md`.
4.  **`outputs/` (De Resultaten):** Wanneer je Claude specifieke vragen stelt over je kennis, schrijft de AI diepgaande rapporten, samenvattingen of actielijsten weg in deze map.

---

## 3. Het Vijf-Stappen Framework

Het systeem draait in een continue, zelfversterkende cyclus die uit vijf stappen bestaat:

### Stap 1: Systeemopzet (Setup)
Maak de mappenstructuur aan en schrijf de eerste versie van `Claude.md`. Definieer hierin de kernonderwerpen waar jij je mee bezighoudt. Voeg optioneel een **geheugenbestand** (`change_log.md`) toe waarin de AI bijhoudt wanneer er voor het laatst acties zijn uitgevoerd, zodat hij efficiënt te werk gaat en weet wat nieuw is.

### Stap 2: De Informatiedump (The Dump)
Verzamel al je huidige documenten, boekfragmenten, Notion-pagina's en artikelen en plaats ze in de `raw/`-map. Je kunt hierbij gebruikmaken van tools zoals Xcode (voor snelle Markdown-bestanden op Mac) of browser-extensies zoals de gratis *Obsidian Web Clipper* om internetpagina's met één klik om te zetten in schone Markdown-bestanden.

### Stap 3: De Wiki Bouwen (Build the Wiki)
Geef Claude de opdracht:
> *"Lees alle bestanden in de `raw/`-map en bouw een gestructureerde wiki in de `wiki/`-map volgens de regels in `Claude.md`. Maak eerst een `index.md` aan en creëer vervolgens één Markdown-bestand per belangrijk thema, inclusief onderlinge links."*

*Tip:* Gebruik een **Anti-AI Writing Style Guide** (gebaseerd op de schrijfrichtlijnen van Wikipedia). Dit dwingt Claude om clichés, jargon en wollig taalgebruik te vermijden, waardoor de wiki-artikelen scherp, feitelijk en prettig leesbaar blijven.

### Stap 4: Vragen Stellen & Compounding (Ask & Compound)
Wanneer je Claude een complexe vraag stelt (bijv. *"Wat zijn volgens mijn kennisbank de beste manieren om focus te behouden zonder burn-out te riskeren?"*), leest de AI de meest relevante wiki-pagina's en genereert een diepgaand antwoord in de `/outputs`-map.
**De compounding-kracht:** Als je zo'n gegenereerde output waardevol vindt, verplaats of kopieer je deze terug naar `/raw`. Claude integreert deze nieuwe inzichten vervolgens weer in de wiki. Hierdoor wordt de kennisbank bij elke interactie slimmer.

### Stap 5: De Maandelijkse Health Check (Audit)
Eenmaal per maand voer je een grondige audit uit om de kwaliteit van de kennisbank te bewaken. Claude controleert de gehele structuur op basis van een 7-fasen controlelijst:
1.  **Contradictions:** Opsporen van tegenstrijdigheden tussen artikelen.
2.  **Broken Backlinks:** Repareren van kapotte links of weesreferenties.
3.  **Source Provenance:** Controleren of claims in de wiki direct herleidbaar zijn naar bronnen in de `raw/`-map.
4.  **Coverage:** Controleren of alle recent toegevoegde raw-bestanden volledig en correct zijn geassimileerd.
5.  **Stale Articles:** Identificeren van verouderde artikelen (ouder dan 90 dagen) die een update nodig hebben.
6.  **Suggested New Articles:** Aanbevelen van nieuwe thematische artikelen op basis van losse flarden in de rommella.
7.  **Action Plan:** Claude stelt een menu met actiepunten voor dat je met één klik of prompt kunt laten uitvoeren om de wiki te updaten.

---

## 4. Conclusie & Lange-Termijn Voordeel

De ware kracht van dit systeem is dat het met je meecomponeert. Omdat de AI de zware last van het organiseren en onderhouden op zich neemt, blijft het systeem schaalbaar en leuk om te gebruiken. Na verloop van tijd ontstaat er een diepgaand, gecureerd netwerk van informatie dat volledig is afgestemd op jouw manier van denken en jouw unieke bronnen—een bezit dat voor niemand anders te reproduceren is.
