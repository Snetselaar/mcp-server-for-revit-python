# Uitgebreide Transcriptie en Reconstructie: The Future of AI, BIM, and Revit Automation

Dit document biedt een uiterst gedetailleerde, uitgebreide transcriptie en reconstructie van de zeven bronnen in deze notebook. Alle technische stappen, workflows, meningen, anekdotes en nuances van de sprekers zijn hierin vastgelegd, zodat er geen informatie verloren gaat.

---

## Inhoudsopgave
1. **AI for BIM, Dynamo’s Reckoning & the Future of Revit Automation | met Gavin Nicholls**
2. **Batch Upgrade Revit Files - BIM Pure Plugin v0.4**
3. **How To Use Claude Code For Free To Build pyRevit Tools?**
4. **I Made pyRevit Form WPF Builder (It Already Works...)**
5. **I've Build AI-Brain for pyRevit. Here's how it works**
6. **Revit + AI Tutorial | Generate & Extract Area Information**
7. **Vyssuals: Colorize & Analyze Revit Models**

---

## 1. AI for BIM, Dynamo’s Reckoning & the Future of Revit Automation | met Gavin Nicholls

### Introductie en de verschuiving van AI
**Nick (BIM Pure):** Welkom terug! Ik ben hier met de "ontwerpguru" Gavin Nicholls. Normaal gesproken doen we eens per jaar een controle van wat er gaande is in de industrie aan het einde van het jaar. Maar er gebeurt op dit moment zo ontzettend veel dat we dachten: waarom doen we niet een informele tussentijdse check-up? 

Gavin, sinds we elkaar zo'n zes of zeven maanden geleden voor het laatst spraken, is AI enorm vooruitgegaan. Hoe is dat voor jou veranderd?

**Gavin Nicholls:** De laatste keer dat we over AI spraken, waren we weliswaar niet sceptisch, maar het was nog in een fase waarin je er niet constant op kon vertrouwen. Het was destijds vooral nuttig om te ontdekken hoe je goed kon coderen. En dat is ook de hoek waarin AI de grootste impact op mij heeft gehad. 

Voorheen gebruikte ik het af en toe, een beetje experimenteren, maar ik ging er nooit volledig in op om het hele applicaties vanaf de grond te laten schrijven. Onlangs moest ik echter omschakelen en proberen om volledige softwaretoepassingen door AI te laten schrijven. 

Ongeveer twee weken geleden zag ik bijvoorbeeld dat iemand problemen had met een PDF-binder. Twee prompts later hadden we een functionerende PDF-binder gebouwd. Het verving Adobe Acrobat volledig en deed precies wat we wilden met specifieke functies. Het is echt bizar wat je kunt genereren met heel weinig input.

Mijn focus, en de focus van veel mensen in dit vakgebied, ligt nu op het verkrijgen van de beste kwaliteit en context voor de AI. De AI moet je systemen kennen, je manier van werken begrijpen en weten welke code je al hebt. Ik ben dus veel aan het experimenteren met de soorten bestanden, systemen en vaardigheden (skills) die ik aan de AI voer om een meer op maat gemaakt resultaat te krijgen. 

Veel mensen drukken nu nog op de "I'm feeling lucky"-knop en bouwen een losstaand stuk software dat ze vervolgens nooit kunnen integreren in hun volledige code-ecosysteem. Wij proberen daar echt verandering in te brengen. Waar ik werk hebben we inmiddels twee webontwikkelaars die zich zwaar specialiseren in AI en hoe je daar het meeste uit kunt halen en dit op schaal kunt implementeren. 

Een van de applicaties die we nu bouwen – waar ik niet te veel over mag zeggen – zal ons in staat stellen om geautomatiseerde Revit-taken uit te voeren op flexplekken (hot desks) voor diverse soorten werkzaamheden, zonder dat er een gebruiker fysiek aanwezig hoeft te zijn. We kijken naar het idee om de interactie met Revit te abstraheren naar een webservice die een fysieke computer aanstuurt met specifieke taken en instructies. Er zit momenteel geen AI in de uitvoering van die taken zelf, maar we hebben AI gebruikt om de software te schrijven die dit mogelijk maakt. Als je AI eenmaal omarmt, zie je dat er heel snelle winsten te behalen zijn.

### Kwaliteit van de code en modelvoorkeuren
**Nick:** Vorig jaar zeiden mensen nog: "Het is leuk om te experimenteren, maar de kwaliteit van de code is er simpelweg nog niet." Heb je het gevoel dat dit veranderd is met de nieuwste modellen, of het nu gaat om Fable, Opus 5 of de nieuwste OpenAI-modellen? Zijn ze goed genoeg om zelfstandig taken uit te voeren?

**Gavin:** De kwaliteit van de code is tegenwoordig uitstekend. Ik gebruik momenteel voornamelijk **Claude (Sonnet 3.5)**. We hebben met verschillende providers geëxperimenteerd. Uiteindelijk merkten we dat je de meeste modellen via elkaars API's kunt aanroepen, dus we zitten niet vast aan één platform. 

Ik merkte dat er zo'n drie of vier maanden geleden achter de schermen een knop werd omgezet. Claude werd plotseling veel beter. Het voelt alsof het model nu agentisch achter de schermen werkt, taken delegeert, test en weer terugbrengt. Vroeger kreeg je code terug, stopte je die erin en kreeg je direct 58 foutmeldingen omdat het niet kon compileren. Nu krijgen we misschien één of twee kleine foutjes, bijvoorbeeld omdat een specifieke bibliotheek niet met de volledige namespace is gerefereerd. Maar de PDF-binder die ik bouwde, draaide bijvoorbeeld de allereerste keer direct foutloos.

De sleutel is wat je de AI geeft om mee te werken. Ik ben begonnen met het voeden van meer voorbeelden en het bouwen van gestandaardiseerde Markdown-bestanden voor context. Hierdoor krijg ik consistentere resultaten en hoef ik niet steeds te herhalen: "Hey, ik gebruik Revit" of "Hey, ik gebruik C#". Ik start direct met een script dat ik de AI geef. 

Voorheen gebruikte ik AI niet erg effectief, maar nu doe ik echt onderzoek naar de best practices. Je kunt meer bereiken met minder. We gebruiken geen contextbestand van 8.000 woorden meer; ik heb nu een zeer beknopte samenvatting van 1.200 woorden en een set voorbeelden waar de AI doorheen kan navigeren als dat nodig is. 

Veel mensen zijn verrast dat ik de voorkeur geef aan Sonnet boven Opus, omdat ze denken dat Opus beter is in coderen. Ik vind echter dat Sonnet beter bij mijn workflow past. Het levert complete pakketjes op, netjes ingepakt met een strik eromheen. Opus geeft vaak fragmenten van ideeën en concepten, terwijl ik gewoon het hele project terug wil krijgen zodat ik direct op 'run' kan drukken. Sonnet doet dat uitstekend.

### Democratisering en de Jevons-paradox
**Nick:** Het is grappig, want ik bekeek onlangs video's die ik vorig jaar had gemaakt waarin ik een Python-script "vibe codeerde" en dat in een Dynamo-node of de Python-shell plaatste. Dat voelt nu al bijna lachwekkend verouderd. 

Ik heb onderzocht hoe ik kleinere, lokale bureaus kan leren werken met **Claude Code** en de **pyRevit MCP (Model Context Protocol)**. Voor kleine teams die geen eigen ontwikkelaars kunnen betalen, is dat een extreem krachtige opzet. Sommige van die teams hadden voorheen wel een beetje met Dynamo geëxperimenteerd, maar toen ik ze liet zien hoe ze hun eigen snelle extensie in pyRevit konden genereren met AI, was dat voor hen een enorme openbaring. Ze begonnen direct veel meer te automatiseren. Het is een veel directere weg naar automatisering. Voor grotere bedrijven die meer controle willen over hoe code wordt beheerd, is dit misschien niet ideaal, maar voor kleine bureaus is het een geweldige democratisering.

**Gavin:** Absoluut. Het verschil bij grotere bedrijven is dat wij niet meer vasthouden aan 'low-code' vanwege versiebeheer en het beheren van alle sub-afhankelijkheden (dependencies) van applicaties die aan de hoofdsoftware gekoppeld zijn. Dat wordt heel zwaar en complex om te onderhouden als je veel gebruikers hebt. Maar voor kleine tot middelgrote bureaus die hun tech-stack eenvoudig kunnen beheren omdat ze maar met een paar mensen hoeven te overleggen, is het absoluut een 'democratizer'. 

Hoewel het woord 'democratisering' in de context van AI wel wat ironisch is, gezien de ondemocratische manier waarop deze AI-bedrijven zelf worden beheerd. Het is in ieder geval een gelijkmaker in de toegang tot capaciteiten. Ik ben benieuwd hoe dit verschuift naarmate deze AI-bedrijven richting beursgangen (IPO's) bewegen en winstgevender moeten worden. Nu balanceren ze vaak nog tussen faillissement en extreme winstgevendheid.

**Nick:** Ik heb er zelf nog niet mee gespeeld, maar er zijn ook open-source of 'open-weight' modellen, bijvoorbeeld uit China, die concurreren met Anthropic en OpenAI. Ik weet niet precies wat de technische verschillen zijn, maar het is interessant.

**Gavin:** Het interessante is hoe ze getraind zijn. Veel van die Chinese open-weight modellen lijken getraind te zijn op de output van de gevestigde modellen (zoals GPT-4 of Claude). Je hebt dus kans dat je te maken krijgt met tweedegeneratie-AI-hallucinaties. Mensen weten niet zeker of ze legitiem getraind zijn of via 'knowledge distillation' van andere modellen. Het zal interessant zijn om te zien of deze modellen tegen een plafond aanlopen wanneer de eerstegeneratiemodellen doorkrijgen dat ze een tweedegeneratiemodel aan het trainen zijn en besluiten om te stoppen met praten. Ik geniet wel van de ironie dat AI-bedrijven nu zelf te maken krijgen met het feit dat hun intellectuele eigendom (IP) 'gestolen' wordt. Nu klaagt men in de VS dat China hun IP steelt. Dat is een vermakelijke dynamiek.

### AI-agents vs. Determinische Automatisering
**Nick:** Wat me ook opvalt in de industrie, is dat er zoveel mensen AI-agents voor Revit bouwen. Ik kan niet eens tellen hoe vaak ik een bericht krijg met: "Probeer mijn nieuwe AI-agent voor Revit." Maar ze doen in wezen allemaal exact hetzelfde, wat heel erg lijkt op de gratis pyRevit MCP-setup (buiten het abonnement op Claude om). Waarom zou ik voor hun systeem betalen? Tenzij ze echt iets unieks te bieden hebben in plaats van alleen een prompt-balk die een nieuwe knop aan je Revit-ribbon toevoegt. Als je dat vijf jaar geleden had uitgebracht, was het een killer-app geweest, maar nu doet iedereen het.

**Gavin:** Ja, ik heb me inmiddels een beetje afgewend van het idee van de MCP en de chatbot als primaire bron van waarde. De output van chatbots is er op dit moment simpelweg nog niet helemaal. De pyRevit MCP is een leuke uitzondering omdat je direct iets werkends op je ribbon kunt zetten, maar uiteindelijk willen gebruikers in een professionele omgeving iets dat **deterministisch** is. De tool moet exact doen wat hij belooft. 

Gebruikers willen niet dat een tool een gokje waagt: "Oh ja, ik denk dat ik het zo gedaan heb", om er vervolgens achter te komen dat het niet klopt of dat er per ongeluk elementen zijn verwijderd zonder dat te melden. Dat is de snelste manier om ervoor te zorgen dat mensen je tools nooit meer gebruiken. Ze schakelen het direct uit omdat ze het niet vertrouwen. 

Daarom focussen wij ons nu op betere, deterministische automatisering en betere organisatorische dataschema's. Zodra AI echt op het punt komt dat we de teugels volledig kunnen overdragen, hebben we tenminste een heel helder schema klaarliggen waar de AI mee kan werken. Je kunt de structuur van je bedrijf dan in een Markdown-bestand beschrijven aan de AI: "Dit is hoe je door onze bedrijfsdata navigeert." Dat is een grote focus voor ons. Veel bedrijven proberen nu de weg vrij te maken zodat de AI deze effectief kan bewandelen. Maar het bouwen van schaalbare, efficiënte automatisering die zowel geheugen- als tijdbesparend is, blijft essentieel.

Ik geniet nog steeds van het bouwen van modulaire toolkits en die te delen, zodat mensen (of hun AI) die kunnen inladen in hun eigen toolbar. Ik ben momenteel bijvoorbeeld bezig met een klein project geïnspireerd op een blogpost uit 2012 van Conrad Sobon (Conrad Sobon). Hij liet zien hoe je met een 'listener' in Revit kunt voorkomen dat specifieke elementen per ongeluk worden verwijderd. De tool waarschuwt de gebruiker en herstelt de actie. Ik heb dat in onze bedrijfssystemen geïmplementeerd en ben nu een add-in aan het bouwen om dit met iedereen te delen. Ik geef mensen hiermee ook weer 'voer' voor hun eigen AI om te lezen en mee te werken.

### Ethiek, Licenties en de Rol van Ontwikkelaars
**Nick:** Dat is iets waar ik mee geëxperimenteerd heb. Soms is de ethische kant lastig. Je kunt een GitHub-link kopiëren, in Claude Code plakken en vragen: "Kun je dit herbouwen voor mijn pyRevit-extensie?" Zolang het een openbare MIT-licentie heeft, mag dat. Maar ik vraag me soms af of ik, als ik iets gratis gebruik, ook weer iets moet teruggeven aan de community. 

**Gavin:** AI lijkt zich over het algemeen weinig aan te trekken van licenties, zelfs als de licentietekst in de code staat die je invoert. Ik maak bijna al mijn persoonlijke projecten MIT-gelicenseerd, simpelweg omdat ik geen tijd heb om ze te onderhouden. Als iemand er een bedrijf mee start: prima. Alles wat ik aan robuuste software bouw voor mijn werkgever, blijft uiteraard achter slot en grendel. Maar voor de community deel ik graag gratis toolkits die mensen in hun eigen workflow kunnen hacken.

Wat betreft de uitspraak "we hebben straks geen programmeurs of ontwikkelaars meer nodig": ik denk dat het tegendeel waar is. Als ervaren ontwikkelaar is AI juist een superkracht. Je werkt er vele malen sneller door, omdat je de databaseconcepten, algoritmen en systemen al begrijpt. Je snapt direct wat de AI teruggeeft en waar de risico's liggen. 

Toen ik voor het eerst Claude Code in de terminal installeerde, dacht ik ook: "Wat is dit?" en schakelde ik over naar de desktopversie omdat die minder intimiderend was. Maar we hebben mensen nodig die in systemen kunnen denken, risico's kunnen overzien en de AI in de juiste richting kunnen sturen. Bedrijven zoeken nog steeds programmeurs. 

Mijn theorie is dat er juist meer ontwikkelaars nodig zijn. Dit is de **Jevons-paradox**: hoe gemakkelijker en goedkoper het wordt om code te produceren, hoe groter de vraag ernaar wordt omdat mensen veel meer applicaties willen bouwen. 

We zien ook steeds meer abstractielagen in programmeren. Je voegt steeds meer lagen toe tussen de computer die met enen en nullen werkt en de uiteindelijke gebruiker. Neem Dynamo: dat is al een aantal lagen verwijderd van Revit in C++. Als prestaties (performance) belangrijk zijn, kun je niet te ver van de basis afstaan. De echt sterke programmeurs werken nog steeds met geheugenbeheer, pointers en zware wiskundige concepten. Denk aan rendering-engines zoals Enscape; die moeten extreem dicht op de grafische hardware geprogrammeerd worden om snel te zijn.

**Nick:** Klopt. Wij bouwen momenteel een volledig aangepast LMS (Learning Management System) voor onze BIM Pure-cursussen. Ik heb geprobeerd wat te "vibe-coderen" voor een prototype, maar ik was te bang om dat als echte code te gebruiken. Nu werk ik samen met een professionele ontwikkelaar en treed ik meer op als productmanager. Ik gebruik Claude Code om vragen te stellen over hoe de code is opgebouwd, zodat ik ervan kan leren. Het werken met een ontwikkelaar die AI gebruikt, gaat enorm snel. 

**Gavin:** Precies. Een AI zal je project nooit zo goed begrijpen als jijzelf. Hoe meer informatie je in de context van de AI stopt, hoe groter de kans dat het de specifieke kern van je probleem uit het oog verliest. Je hebt ontwikkelaars nodig om de applicaties en de context van het bedrijf mentaal aan elkaar te lijmen. Anders zou je miljoenen dollars per dag kwijt zijn om de AI constant aan de context van je hele bedrijf te herinneren bij elke query.

### AI voor Tekstcreatie en Sponsoring
**Nick:** Voor coderen is AI geweldig, maar voor het schrijven van teksten vind ik het nog steeds niet werken. Ik heb geprobeerd AI te trainen op mijn stem en de 'BIM Pure-stem', maar het resultaat is het net niet. Ik schrijf al mijn e-mails en social media-posts nog steeds zelf. Vanuit een ethisch en persoonlijk oogpunt haak ik ook direct af als ik zie dat een tekst door AI is gegenereerd. Dat is niet leuk om te lezen. Ik dicteer wel veel via text-to-speech om een authentieke toon te behouden.

**Gavin:** Ik merk het ook onbewust als ik AI-gegenereerde teksten lees. Veel mensen die niet diep in de technologie zitten, geven er trouwens niet zoveel om. Die gebruiken ChatGPT een keertje en laten het erbij. We moeten als ontwikkelaars niet vergeten dat we te maken hebben met eindgebruikers die helemaal niet zo diep in de technologie willen duiken.

---

*(Sponsorgedeelte van de video)*
**Nick:** Met dank aan **PROS** voor het sponsoren van deze BIM Pure-video. PROS (te vinden via `pros.com` of `prolls.com`) is een webapplicatie en Revit-plugin waarmee je details en andere inhoud in de cloud kunt beheren. Je kunt volledige projecten uploaden en selecteren welke elementen je wilt importeren. PROS maakt automatisch een lijst van vergelijkbare details die in andere projecten zijn gebruikt. Gebruikers kunnen details annoteren, teamleden taggen met instructies, en een selectie van details of sheets in één keer in Revit inladen. Er is ook een synchronisatiemodus die waarschuwt als typische details zijn gewijzigd. Naast details beheert PROS ook Revit-families (zowel systeem- als laadbare families) met behulp van AI-beeldherkenning om families te identificeren, zelfs als de naamgeving of tagging niet perfect is.

---

### De Toekomst van Revit Add-ins en de Architectuur
**Nick:** Hoe denk je dat dit plug-in-bedrijven in de industrie gaat beïnvloeden? Sommige bedrijven die zich puur richten op basis-Revit-automatisering (zoals ID8 of Diroots) hebben een verkoopargument dat minder overtuigend wordt nu je met AI relatief eenvoudig je eigen "H&M-versie" van zo'n tool kunt bouwen. 

**Gavin:** Het wordt inderdaad moeilijker om add-ins te verkopen voor duizenden dollars als een bedrijf intern voor een fractie van de kosten een eenvoudigere versie kan bouwen. Hun producten zijn erg gepolijst en hebben prachtige tabellen, maar vaak heeft een gebruiker alleen een voortgangsbalk nodig om de taak te voltooien. AI zorgt ervoor dat je geen hardcore codeur meer hoeft te zijn om dat soort producten uit te dagen. Bedrijven met unieke, performante grafische engines of zeer complexe workflows blijven echter wel buiten schot; dat laat je een AI niet zomaar bouwen.

Het dwingt onze industrie ook om na te denken over wat een architect nu eigenlijk doet. We zien een enorme concurrentie, ook internationaal. Bureaus moeten in de spiegel kijken en zich afvragen wat ze de klant werkelijk verkopen. Verkopen we een ervaring, of leveren we tekeningen? Hopelijk beide, maar we produceren momenteel veel te veel documenten. We gebruiken een hagelschot-benadering om risico's af te dekken door 100% van de informatie al te tonen bij een ontwerpfase van 30%. Klanten begrijpen tekeningen vaak niet eens goed; ze geven de voorkeur aan 3D-ruimte. Ik zou graag zien dat we in de conceptfase direct in Unreal Engine stappen om een ervaring voor de klant te bouwen, in plaats van een PDF-binder van 30.000 pagina's te produceren.

### Autodesk Forma, APS en Dynamo's Toekomst
**Nick:** Wat vind je van Autodesk Forma (voorheen Spacemaker)? De naamsveranderingen binnen het Autodesk-ecosysteem (ACC, Forma) zijn soms erg verwarrend en vermoeiend om cursussen voor bij te werken.

**Gavin:** Ja, het is lastig bij te houden. Forma is in wezen hetzelfde product met een andere naam. Autodesk probeert met de Autodesk Construction Cloud (ACC) en Forma een volledige projectmanagementoplossing te bieden, maar de uitdaging ligt bij data-lockins en licentiekosten voor de klant. Wel ben ik positief over wat ze doen met hun API's via de **Autodesk Platform Services (APS)**. Ze proberen dataschema's te verenigen, zodat hun producten geen losse eilanden meer zijn, maar gestandaardiseerde bruggen hebben in de cloud. Dat is de juiste weg. 

Voor kleine tot middelgrote bureaus (20-30 personen) blijft het draaien van een zwaar programma als Revit heel erg lastig omdat ze vaak geen speciaal digitaal technologieteam hebben. Revit LT is ook beperkt omdat het geen add-ins ondersteunt, wat tegenwoordig essentieel is, zelfs voor visualisaties met Enscape of D5.

**Nick:** Wat is volgens jou de toekomst van **Dynamo**? Ik ben altijd een fan geweest, maar tegenwoordig is mijn eerste reflex bij een automatiseringstaak: "Laat ik een AI inschakelen", in plaats van Dynamo te openen en nodes te plaatsen. Moeten we Dynamo nog wel doceren aan bedrijven?

**Gavin:** Dat hangt ervan af. Ik gebruik Dynamo nog steeds erg veel voor prototyping, het snel opzetten van oplossingen en met name voor het werken met geometrie. Geometrie programmeren in de Revit API is vreselijk ingewikkeld; in Dynamo is dat visueel veel makkelijker. Ook voor ad-hoc oplossingen die ik vóór 15:00 uur klaar moet hebben voor een collega, is Dynamo perfect. Ik ga niet snel een C#-add-in compileren, ondertekenen en uitrollen voor een eenmalige taak. 

Wel ben ik mijn eigen Dynamo-pakket aan het herschrijven in C# (genaamd **Pickles**, te vinden op mijn GitHub). Python is voor mij in Dynamo te onbetrouwbaar geworden door versie- en engine-problemen. Pickles zal sneller, robuuster en minder gevoelig voor bugs zijn. 

Dynamo is hoe ik ooit begon met programmeren, dus het is belangrijk voor de basis. Het leert je de terminologie van de Revit API. Als je niet weet hoe de API onder water werkt, kun je de AI ook niet goed instrueren. Mensen die de API-concepten niet kennen, gebruiken verkeerde termen in hun prompts, waardoor de AI in de war raakt en foutieve code genereert (bijvoorbeeld filteren versus collecteren van elementen). 

Dynamo neemt nog steeds veel frictie weg, zoals het bouwen van installers. Maar bedrijven moeten eerst zelf beslissen of ze een robuuste, centraal beheerde toolkit willen die communiceert met web-endpoints, of dat ze gewoon snel op een knop willen drukken om een PDF te binden.

---

## 2. Batch Upgrade Revit Files - BIM Pure Plugin v0.4

### Nieuwe Feature: Upgrade Revit Files
**Nick (BIM Pure):** In deze video toon ik de nieuwe functies in de bijgewerkte BIM Pure-plugin voor Revit, versie 0.4. We hebben een tool toegevoegd genaamd **Upgrade Revit Files**. Hiermee kun je Revit-bestanden batchgewijs upgraden van de ene versie naar een geselecteerde hogere versie.

#### Workflow en Werking:
1. **Bestanden selecteren:** Klik op "Add Files" en selecteer de bestanden. Dit kan een mix zijn van **RFA-bestanden** (families) en **RVT-bestanden** (projecten).
2. **Versie-detectie:** De tool toont direct de huidige Revit-versie van elk geselecteerd bestand (bijvoorbeeld Revit 2022 of Revit 2025).
3. **Beperkingen en waarschuwingen:**
   * **Workshared / Central Files:** De tool detecteert automatisch of een bestand een centraal model (workshared) is. De tool is **niet compatibel** met workshared bestanden; deze upgrades moeten handmatig worden uitgevoerd.
   * **Downgrades:** Je kunt bestanden uiteraard niet downgraden naar een lagere versie (bijvoorbeeld een Revit 2025 bestand upgraden naar Revit 2023). Deze bestanden worden automatisch gemarkeerd als over te slaan ("skipped").
4. **Doelversie selecteren:** De tool herkent automatisch welke Revit-versies op jouw computer zijn geïnstalleerd. Je kiest simpelweg naar welke versie(s) je wilt upgraden en selecteert een uitvoermap ("output folder").
5. **Uitvoering:** Na het klikken op "Upgrade" opent er een controlevenster en start een command-line interface. De tool opent achtereenvolgens de benodigde Revit-versies op de achtergrond, voert de upgrades uit en sluit de Revit-sessies automatisch af zodra het werk klaar is.
6. **Resultaat:** In de uitvoermap worden de geüpgrade bestanden opgeslagen, waarbij de jaargang van de release automatisch aan het einde van de bestandsnaam wordt toegevoegd (bijvoorbeeld `_R23` of `_R24`). Je hoeft Revit niet eens handmatig te openen; de plugin regelt het openen van de juiste softwareversies volledig zelfstandig.

### Bugfix: Convert Family Units
In deze update is er ook een belangrijke bug opgelost in de tool **Convert Family Units**. Deze tool zet de maateenheden binnen een Revit-family om van imperiaal naar metrisch (of andersom). Er is een optie om de dimensies af te ronden om vreemde breuken of decimalen te voorkomen, en je kunt ook geneste families ("nested families") hierin meenemen. 

Voorheen kon de afrondingsfunctie bij complexe families met veel parameters en formules de interne formules beschadigen. Deze bug is nu volledig opgelost. Als je nu bijvoorbeeld een complexe deur selecteert en de conversie uitvoert, worden alle dimensies (inclusief die van geneste onderdelen) keurig omgezet en afgerond zonder dat de interne formules kapotgaan.

De plugin is exclusief beschikbaar voor leden van de **BIM Pure Membership**, die tevens toegang geeft tot Revit-cursussen, live masterclasses, templates en family-collecties op `bimpure.com`.

---

## 3. How To Use Claude Code For Free To Build pyRevit Tools?

### Inleiding tot gratis tokens en OpenRouter
**Erik Frits:** In deze video laat ik zien hoe je **Claude Code** (de CLI-tool van Anthropic) absoluut gratis kunt gebruiken voor je pyRevit-ontwikkeling of elk ander codeerproject. Ter illustratie: ik heb hiermee inmiddels al **126 miljoen tokens** verbruikt, wat mij exact **$0** heeft gekost. 

Hoewel gratis opties altijd beperkingen hebben, is er op dit moment één specifiek model beschikbaar zonder limieten dat uitstekend presteert. Dit zetten we op in drie eenvoudige stappen via **OpenRouter**.

### Stappenplan voor de setup

#### Stap 1: OpenRouter Account en API-key aanmaken
1. Ga naar **openrouter.ai** en maak een gratis account aan.
2. Ga in je profiel naar het tabblad **API Keys** en klik op **Create Key**. Give it a name (bijvoorbeeld "tutorial") en klik op maken. 
3. Kopieer de gegenereerde API-key (en bewaar deze veilig).

#### Stap 2: Model selecteren
We maken gebruik van een model genaamd **Ox Alpha** (een 'frontier model' dat onlangs door een niet nader genoemde organisatie gratis ter beschikking is gesteld). Sommigen beweren dat het op gelijke hoogte staat met OpenAI's o1 (Fable) of GPT-5. Het belangrijkste voordeel is dat het een context-venster van **1 miljoen tokens** heeft en momenteel volledig gratis te gebruiken is.
1. Zoek op OpenRouter onder "Models" naar **ox-alpha** en controleer of er inderdaad "$0" bij staat.
2. Kopieer de exacte modelnaam.

#### Stap 3: Configuratie in je projectmap (VS Code)
1. Open je projectmap in VS Code.
2. Maak een map aan genaamd `.claude` (dit is de map waar je lokale Claude Code-instellingen in opslaat).
3. Maak daarin een bestand genaamd `settings.json` aan om de standaard API van Anthropic te overschrijven met die van OpenRouter.
4. Voeg de volgende configuratie toe in het bestand:
   * Stel de base URL in op de API-URL van OpenRouter: `https://openrouter.ai/api/v1`
   * Plak je OpenRouter API-key in bij de authenticatie-instellingen.
   * Overschrijf de standaardmodellen (zoals `default_model`, `opus_model`, `sonnet_model`, `haiku_model`) met de exacte gekopieerde naam van het **ox-alpha** model.
   * Stel de maximale context-tokens (`max_context_tokens`) in op **1.000.000**.

### Claude Code opstarten en testen
Open de terminal in je projectmap en typ `claude` (of `CLAUDE`). De CLI start op en toont dat je verbonden bent met het model: **"stealth/ox-alpha" with extra high effort**. 

Als je de AI vraagt welk model het is, antwoordt het: *"I am Ox Alpha, developed by an undisclosed organization."* Dit is een slimme marketingstunt van de makers om mensen het model onbevooroordeeld te laten testen en vergelijken.

### Parallelle testcases

#### Test 1: Interactieve HTML-pagina over pyRevit
Erik vraagt Claude Code in één terminal om een moderne, interactieve HTML-pagina te maken met een donker thema, oranje accenten en speelse elementen die uitleggen waarom pyRevit zo goed is. 

Het resultaat is een interactieve pagina met de kop *"pyRevit is unfair in your favor"*. De pagina bevat interactieve knoppen waarmee je zogenaamd muren kunt tellen (met grappige dummy-outputs) en legt de voordelen van pyRevit uit:
* Geen ingewikkelde ceremonies om de Revit API te gebruiken.
* Je toolbar is letterlijk een mappenstructuur op je computer.
* Eenvoudig uit te rollen naar alle computers op kantoor in één middag.
* Gesteund door een actieve community in plaats van een starre softwareleverancier.

#### Test 2: pyRevit WPF/XAML selectietool (Advanced Selection)
In een tweede terminal (met een pad naar zijn pyRevit-extensie) vraagt Erik om een nieuwe pyRevit-knop te maken voor een geavanceerde selectietool. De tool moet:
* Een **WPF/XAML-formulier** tonen.
* Gebruikers in staat stellen om Revit-categorieën en parameters te kiezen, en filterwaarden in te voeren.
* Knoppen bevatten om elementen te selecteren, te isoleren in de huidige weergave, of te isoleren in een nieuw aan te maken 3D-weergave.

Claude Code begrijpt direct de mappenstructuur van pyRevit en weet dat er voor een WPF-formulier een `script.py` en een `script.xaml` in de push-button-map moeten staan.

### Beperkingen en Alternatieve Modellen
Omdat Ox Alpha waarschijnlijk na de promotieperiode een betaald model wordt, toont Erik hoe je in OpenRouter kunt filteren op andere gratis modellen (zoals Poolside of Gemma-modellen). Sommige van deze modellen hebben een context van 262.000 tokens. 

Erik waarschuwt echter voor een belangrijke limiet: bij het testen van een alternatief model (Poolside) krijgt hij een **HTTP 429-foutmelding** (*"exceeded free models per day usage"*). OpenRouter vereist dat je minimaal $10 aan credits op je account laadt om dagelijks 1.000 gratis model-verzoeken te ontgrendelen. Ox Alpha is momenteel echter onbeperkt gratis te gebruiken, wat Erik dan ook ten zeerste aanbeveelt om direct te benutten.

### Verfijning van de pyRevit Tool
De eerste versie van de WPF-tool werkte direct qua basisfuncties (selecteren en een 3D-weergave maken), maar had nog geen styling en gaf foutmeldingen bij het isoleren omdat er geen Revit-transactie was geopend. Erik vraagt om de volgende updates:
1. **Transactie toevoegen:** Los de foutmelding bij het isoleren van elementen op.
2. **Categorie-selectie verbeteren:** Vervang de invoer door overzichtelijke checkboxes en voeg een zoekbalk met live filterfunctie toe om snel categorieën te vinden.
3. **Styling (WPF/XAML):** Pas een mooi donker thema toe met afgeronde hoeken, oranje accenten en subtiele hover-effecten op de knoppen.

Claude Code voert de aanpassingen succesvol uit. Het resultaat in Revit is een prachtig, modern, donkergestijld formulier dat perfect en snel functioneert. 

Bij het inspecteren van de gegenereerde Python-code valt op dat de AI de naamgevingsconventies van Erik heeft overgenomen (zoals `UI_Event` voor event handlers). De code is netjes gestructureerd met duidelijke functies en scheidt de WPF-stijlen (Resources) netjes van de lay-out-elementen, wat uitzonderlijk is omdat AI's stijlen normaal gesproken rommelig inline plaatsen.

Erik is momenteel bezig met het ontwikkelen van een nieuwe training waarin hij studenten leert om binnen 90 days een volledige pyRevit-toolbar op te zetten en uit te rollen met behulp van AI-workflows.

---

## 4. I Made pyRevit Form WPF Builder (It Already Works...)

### Het probleem met traditionele WPF-ontwikkeling
**Erik Frits:** Iedereen die wel eens mooie WPF-formulieren (Windows Presentation Foundation) heeft willen maken voor pyRevit, weet dat dit een enorme chaos is. Normaal gesproken moeten we hiervoor **Visual Studio** gebruiken. Visual Studio is echter nooit ontworpen voor Python; het is gebouwd voor C#. 

De gegenereerde 'boilerplate'-code is in C#, wat betekent dat we de code handmatig moeten vertalen naar Python. Je bent constant aan het kopiëren en plakken tussen Visual Studio en je pyRevit `.py`- en `.xaml`-bestanden. Je moet alle property-namen en event-namen handmatig onthouden en synchroon houden. Als er iets breekt, ben je eindeloos aan het zoeken naar welke naam je bent vergeten aan te passen.

Bovendien is .NET niet echt ontworpen voor de webbrowser, waardoor een live-preview in de browser onmogelijk leek.

### De oplossing: Erik's Browser-based WPF Form Builder
Erik heeft een interactieve browser-applicatie ontwikkeld die dit proces volledig automatiseert en visualiseert.

#### Belangrijkste functionaliteiten:
1. **Live Previewer:** Plak je XAML-code in de browser en zie direct een interactieve preview van het formulier aan de rechterkant. De schaal past zich automatisch aan en elementen lichten op wanneer je er met de cursor overheen gaat.
2. **Eigenschappen en Events:** Je kunt elementen (zoals knoppen) selecteren en direct eigenschappen aanpassen (zoals breedte of kleur). Als je een event toevoegt, zoals een muisklik (`click = UI_Click`), genereert de tool direct de benodigde Python-code achter de schermen.
3. **Python Boilerplate:** Het tabblad "Python" bevat direct de volledige, direct te gebruiken boilerplate-code voor pyRevit. Kopiëren en plakken is voldoende om de knop te laten werken.
4. **Live Sync-functionaliteit (De "Sync"-knop):** Om het handmatige kopiëren en plakken volledig overbodig te maken, heeft Erik een synchronisatiefunctie ingebouwd. 
   * Klik op "Sync", selecteer je pyRevit-ontwikkelmap (bijvoorbeeld `dev_panel`) en geef de knop een naam. Er verschijnt een groene stip die aangeeft dat de live-verbinding actief is.
   * De tool maakt automatisch een nieuwe push-buttonmap aan in je Windows Verkenner, inclusief een geconfigureerd Python-script (`script.py`), het XAML-bestand (`bundle.yaml` of `script.xaml`) en een standaardicoon (`icon.png`).
   * Zodra je in de browser de kleur van een knop aanpast (bijvoorbeeld naar rood of blauw) en op synchroniseren klikt, wordt het bestand op je computer direct bijgewerkt. Je hoeft in Revit alleen op "Reload" te klikken om de wijzigingen live te zien.

### Veiligheidsmaatregelen en Backups
Erik begrijpt dat ontwikkelaars soms zeer geavanceerde logica in hun Python-bestanden schrijven. Als je per ongeluk je Python-code overschrijft vanuit de browser-tool, zou je al je werk kwijt kunnen raken. 

Om dit te voorkomen, heeft de tool een ingebouwd waarschuwingssysteem. Als het Python-bestand lokaal is gewijzigd, krijg je bij een synchronisatiepoging een melding. Je kunt ervoor kiezen om de boilerplate te pushen, of om alleen het XAML-bestand te synchroniseren en het Python-bestand ongemoeid te laten. Mocht je toch beslissen om te overschrijven, dan maakt de tool **altijd eerst een automatische back-up** van je lokale bestand voordat het wordt overschreven.

Deze WPF Form Builder is momenteel exclusief beschikbaar voor studenten van de aankomende training van Erik, waarin hij kantoren helpt om in 90 dagen een robuuste toolbar uit te rollen met AI. Naast deze tool krijgen studenten toegang tot een *Brand Key Generator*, een *pyRevit Debugger*, een geoptimaliseerde *Revit API Documentatie-app* en zijn persoonlijke *AI-Brain*.

---

## 5. I've Build AI-Brain for pyRevit. Here's how it works

### Wat is het AI-Brain?
**Erik Frits:** In deze video geef ik een rondleiding door mijn **AI-Brain** voor pyRevit. Dit is een kennisdatabase gebouwd in de app **Obsidian** (een Markdown-gebaseerde personal knowledge management tool), gebaseerd op vier jaar aan content die ik heb gegenereerd over de Revit API en pyRevit. 

Het AI-Brain is bedoeld om al deze kennis met elkaar te verbinden, concepten op te bouwen en de AI te trainen, zodat deze een diepgaand en foutloos begrip krijgt van de Revit API op basis van mijn specifieke lesmethoden en codeervoorbeelden.

### Visualisatie en Structuur van het Kennisnetwerk
In Obsidian wordt het AI-Brain gevisualiseerd als een dynamisch netwerk van knooppunten (dots):
* **Blauwe knooppunten (Raw Sources):** Dit zijn onveranderlijke (immutable) bestanden die de ruwe bronnen bevatten. Dit omvat alle lessen van Erik's 6 cursussen (Basics, Modern UI, Python, Advanced), nieuwsbrieven, YouTube-video's, blogposts en meer dan 600 handgeschreven code-snippets.
* **Gele knooppunten:** Vertegenwoordigen blogposts.
* **Groene knooppunten (AI-Managed Wiki):** Dit zijn conceptuele documenten die door de AI worden opgebouwd en onderhouden op basis van de ruwe bronnen.

### Het concept "Selection" als voorbeeld
Erik toont het groene conceptdocument voor "Selection" (inmiddels versie 10 na diverse handmatige sturingen). Dit document is een synthese van alle selectiemethoden die hij in de loop der jaren heeft gedoceerd. Het document bevat:
1. De theoretische basis van selectie in de Revit API.
2. Zeven verschillende selectiemethoden, compleet met argumenten, overloads en gedetailleerde code-snippets.
3. Instructies over hoe je veilig kunt prompteren.
4. Tips om de gebruikerservaring te verbeteren (bijvoorbeeld het toevoegen van een waarschuwingsbalk).
5. Complexe scenario's, zoals het selecteren van elementen uit gekoppelde modellen ("linked models") en selectie-UI-opties.
6. **Veelvoorkomende fouten en oplossingen (Common Issues):** Dit is goud waard. De AI heeft alle fouten verzameld die Erik in zijn lessen noemt. Bijvoorbeeld:
   * Als een gebruiker op 'Escape' drukt tijdens een selectie, breekt het script af met een foutmelding. Oplossing: Gebruik een `try-except`-blok.
   * Als een gebruiker niets selecteert, kan dit verderop in het script fouten veroorzaken. Oplossing: Bouw een controle in die controleert of de selectielijst leeg is.

Op dezelfde manier is er een gigantisch conceptdocument gebouwd voor "Filters", waarin alle trage, snelle en logische filters van de Revit API en de bijbehorende shortcuts tot in detail zijn vastgelegd.

### Het LLM Wiki Concept (Andrej Karpathy)
Dit systeem is gebaseerd op het **LLM Wiki** concept dat is gedeeld door **Andrej Karpathy** (voormalig hoofd AI bij Tesla). Karpathy introduceerde tevens de term "vibe coding". 

Het kernidee van een LLM Wiki is dat traditionele **RAG-systemen** (Retrieval-Augmented Generation) vaak niet optimaal werken: ze verliezen informatie, zijn moeilijk te onderhouden en leveren soms matige resultaten op. In plaats van ruwe documenten te doorzoeken op het moment van een vraag, bouwt en onderhoudt de AI incrementeel een persistente wiki van concepten. 

#### De workflow van de LLM Wiki:
1. **Raw Sources (Ruwe bronnen):** Handgeschreven, onveranderlijke documenten (lessen, code, artikelen).
2. **Wiki-directory:** De AI leest de ruwe bronnen en bouwt zelfstandig de concepten (de groene knooppunten) op.
3. **Skills-directory:** De concepten worden uiteindelijk door de AI omgezet in concrete 'skills'. Omdat deze skills zijn gebaseerd op een gecontroleerde bron van waarheid (de wiki), is de kans op hallucinaties minimaal. Bij reguliere AI-agents die direct code genereren op basis van brede internetdata, sluipen er snel fouten en ontbrekende randvoorwaarden (edge cases) in de code.

### "The Law" (De Grondwet) en Kwaliteitsborging
Erik heeft een strenge controlelaag opgetrokken rondom zijn AI-Brain:
* **The Law (law.md):** Dit is de grondwet van het project. Het is een document waarin alle regels, templates, evaluatiemethoden en beslissingen voor de AI zijn vastgelegd. Het definieert bijvoorbeeld exact de structuur van een conceptdocument (openen met een inleiding, basismethoden, geavanceerde functies, edge cases, veelvoorkomende fouten, conclusie).
* **Schema:** Een door de AI geschreven schema dat definieert welke eigenschappen (metadata) elk bestand moet hebben (bijvoorbeeld of het exclusief voor leden is, aanmaakdatum, etc.).
* **Integratie met Linear en GitHub (De verificatielaag):**
  * Om te voorkomen dat de AI zomaar vitale bestanden in de kernmap (`core`) of de grondwet aanpast, heeft Erik een verificatielaag gebouwd met **Linear** (issue-tracking software) en **GitHub pull requests**.
  * Wanneer Erik de AI in de chat vraagt om een regel in de grondwet aan te passen, herkent de AI dat dit een belangrijk bestand is. In plaats van de wijziging direct door te voeren, maakt de AI via een API-koppeling een issue en een 'Review'-taak aan in Linear.
  * De AI maakt een pull request (PR) aan op GitHub waarin de oude regel en de voorgestelde nieuwe regel naast elkaar worden gezet.
  * De wijziging wordt pas doorgevoerd zodra Erik de taak in Linear goedkeurt. Als hij van gedachten verandert, kan hij via een externe server een 'hostic agent' aanroepen die de wijziging netjes annuleert en het PR sluit.

### Cijfers en Tokenverbruik
Erik geeft toe dat hij behoorlijk ver is gegaan in het project. Het AI-Brain heeft hem tot nu toe gekost:
* **4 miljard tokens** (grotendeels gecached via Claude's prompt caching, waardoor de kosten meevielen).
* **27 API-calls** en **22 actieve sessies**.
* **4.000 transcriptiebestanden** die zijn verwerkt.

### Einddoelen en Tips voor Setup
Erik heeft twee hoofddoelen voor dit project:
1. **Beter coderen:** Het bouwen van hoogwaardige pyRevit-skills zodat hij zelf vele malen sneller en foutlozer kan programmeren.
2. **Ondersteuning voor studenten:** De skills en het AI-Brain worden geïntegreerd in zijn nieuwe leerplatform: de **Learn Revit API Academy 3.0**. Als een student een vraag stelt op het platform, heeft de AI-assistent direct toegang tot deze geverifieerde kennisdatabase en kan deze direct verwijzen naar de exacte les of code-snippet.

#### Tips voor wie dit zelf wil bouwen:
* **Lees de documentatie grondig:** Lees Andrej Karpathy's LLM Wiki-document minstens 2 tot 3 keer goed door voordat je begint met plannen of bouwen.
* **Houd het simpel:** Erik adviseert om zo eenvoudig mogelijk te beginnen. Elke regel die je toevoegt aan "The Law" zorgt voor extra frictie. Hij is zelf een 'control freak', wat leidde tot een grondwet van 600 regels en veel initiële frictie en fouten in GitHub-merges.
* **Mens bepaalt de betekenis, AI de vorm:** De mens moet de bronnen selecteren, de kwalitatieve analyse sturen en de juiste vragen stellen. De AI doet al het saaie werk zoals kruisreferenties leggen en indexeren.

Erik bedankt tot slot **Alexander Gamkavoy** (die 77 pyRevit-skills deelde) en **Juvenio Silva** voor het delen van hun pyRevit-skills om zijn AI-Brain tegen te benchmarken.

---


## 6. Revit + AI Tutorial | Generate & Extract Area Information

### Introductie tot de workflow en doelstelling
**Nick (BIM Pure):** In deze tutorial laat ik zien hoe we **Claude Code** en de **pyRevit MCP (Model Context Protocol)** kunnen gebruiken om geavanceerde informatie uit een Revit-model te analyseren en deze data rechtstreeks in parameters binnen onze oppervlakte-elementen ("Areas") te schrijven. Dit is met name handig voor code-analyses of om betrouwbare informatie te delen met een projectontwikkelaar of promotor. 

In plaats van handmatig alle data op te zoeken en in te voeren, laten we de AI het zware werk doen en bouwen we uiteindelijk een herbruikbare knop voor op onze Revit-ribbon.

### Stap 1: De voorbereiding in Revit
Voordat we de AI aan het werk zetten, moeten we een basisstructuur in Revit opzetten:
1. Maak een **Area Plan** (oppervlakte-ontwerp) aan voor het specifieke niveau dat we willen analyseren (in deze video gefocust op **Level 4**).
2. Teken de **Area Boundary Lines** en plaats een **Area** (oppervlakte-object) in elk appartement op deze verdieping. Deze Areas dienen als het startpunt en de opslaglocatie voor onze parameters.

### Stap 2: De gedetailleerde prompt voor Claude Code
Nick activeert Claude Code via de terminal en stuurt een zeer uitgebreide en specifieke prompt in. De prompt omschrijft de exacte eisen van de projectontwikkelaar:
* **Doelgroep en locatie:** We willen informatie verzamelen over de appartementen op **Level 4**.
* **Afstanden:** Bereken de exacte afstand van elk appartement naar de dichtstbijzijnde lift ("elevator") en de dichtstbijzijnde trap ("stairs").
* **Ramen analyseren:** 
  * Tel het totale aantal ramen per appartement.
  * Bereken het totale glasoppervlak ("total square footage of windows") van de ramen binnen elk appartement.
* **Buren identificeren:** Bereken hoeveel buren op dezelfde verdieping elk appartement heeft.
* **Plafondhoogte:** Identificeer de hoogste plafondhoogte ("highest ceiling height") binnen elk appartement.
* **Parametercreatie:** Claude moet automatisch de benodigde projectparameters voor Areas aanmaken in Revit en de juiste datatypen toewijzen (zoals *Length* voor afstanden/hoogtes, *Integer* voor aantal ramen/buren, en *Area* voor glasoppervlak). Alle data moet in de Areas zelf worden opgeslagen.

### Stap 3: Interactieve verduidelijking en Claude's vragen
Hoewel Nick in zijn eerste prompt vergeet te vermelden dat Claude vragen moet stellen bij onduidelijkheden, doet het model dit uit zichzelf om de nauwkeurigheid te garanderen. Er ontstaat een waardevolle interactie tussen Nick en de AI:
1. **Afstandsberekening:** Claude vraagt of het de **Path of Travel tool** (revisietraject-tool) moet gebruiken. Nick bevestigt dat dit de meest nauwkeurige methode is.
2. **Definitie van een buur:** Claude vraagt wat er precies onder een buur wordt verstaan. Nick verduidelijkt dat dit appartementen zijn die een gemeenschappelijke muur delen.
3. **Berekening glasoppervlak:** Claude vraagt hoe het raamoppervlak berekend moet worden. Nick stelt voor om voorlopig uit te gaan van de ruwe sparingmaat ("rough opening").

### Stap 4: Resultaten en analyse van beperkingen
Na de analyse presenteert Claude Code een keurige, gestructureerde tabel met alle gevonden resultaten per appartement (inclusief aantal buren, glasoppervlaktes, afstanden en plafondhoogtes). 

Tegelijkertijd wijst de AI Nick op een aantal kritieke beperkingen en "edge cases" die het heeft ontdekt:
* **Glasoppervlakte-beperking:** De berekende glasoppervlakte houdt geen rekening met specifieke glaslatten of profielen; het is puur de ruwe sparing.
* **Hoekappartementen:** De hoekappartementen hebben logischerwijs een aanzienlijk groter aantal ramen en een groter glasoppervlak dan de tussenliggende units.
* **Pad-foutmarge:** Bij de afstandsmeting voor liften en trappen laat de Path of Travel-tool een klein gat over van ongeveer 1 foot 6 inches (ca. 45 cm) door de manier waarop de start- en eindpunten zijn geplaatst. 
* **Nick's tip voor handmatige correctie:** Om deze afstands-foutmarge te omzeilen, raadt Nick aan om handmatig revisietrajecten te tekenen via de tab **Analyze** in Revit, daar het appartementnummer aan te koppelen in een custom veld, en deze specifieke data vervolgens terug te voeren naar Claude.

### Stap 5: Een herbruikbare pyRevit-tool bouwen (Unit Data)
Het telkens opnieuw invoeren van deze complexe prompts via Claude Code kost veel tijd en verbruikt onnodig veel tokens. Daarom vraagt Nick aan Claude om een permanente, herbruikbare tool te schrijven:
> *"Create a tool in the pamphlets extension for the windows, window square footage, neighbors, and ceiling height to automatically fill up the values in areas."*

Binnen enkele minuten genereert Claude Code de benodigde code en voegt een nieuwe knop toe aan de `pamphlets` pyRevit-extensie, genaamd **Unit Data** (`unit_data`).

#### Werking en test van de Unit Data-tool:
1. **Opstarten:** Klik op de knop **Unit Data** op de pyRevit-ribbon.
2. **Schema selecteren:** Kies het juiste oppervlakteschema ("area scheme").
3. **Parameter-selectie:** Vink aan welke parameters berekend en ingevuld moeten worden (bijvoorbeeld ramen, buren of plafondhoogte).
4. **Filteren:** De tool vraagt de gebruiker om te filteren welke ramen meegerekend moeten worden (om bijvoorbeeld metalen panelen of dichte delen uit te sluiten).
5. **Berekenen en wegschrijven:** Klik op **Calculate** om de resultaten te genereren, controleer ze snel, en klik op **Write to areas** om de data definitief in de Revit-parameters van de Areas te schrijven.

### Stap 6: Gegevens exporteren en verzoenen (Reconciliation)
Zodra de data in de Revit-areas staat, kun je Claude vragen om direct een **Excel-bestand** te genereren met alle informatie. Dit kan uiteraard ook via een standaard Revit-oppervlakteschema (Area Schedule). 

Een zeer krachtige functie is dat je Claude kunt vragen om deze Revit-data automatisch te vergelijken en te verzoenen ("reconcile") met een spreadsheet die is aangeleverd door de projectontwikkelaar of een andere externe partner, om eventuele discrepanties direct op te sporen.

### Belangrijke aanbevelingen en conclusies
* **Verifieer AI-data altijd:** Hoewel de AI extreem snel is, is het van cruciaal belang om de gegenereerde data altijd handmatig te controleren. Er kunnen altijd fouten insluipen door complexe modelgeometrie.
* **Tokenbeheer:** Voorkom dat je constant dezelfde zware analyses uitvoert via Claude Code, omdat dit enorm veel tokens kost. Het is veel slimmer om eenmalig een pyRevit-tool te laten schrijven en deze lokaal binnen je BIM-team uit te rollen.
* **Cloud for BIM Cursus:** Nick nodigt kijkers uit om zich aan te melden voor de wachtlijst van hun nieuwe **Cloud for BIM** cursus op `bimpure.com/cloud`. Deze cursus bevat 6 live sessies met diverse experts op het gebied van BIM en AI, en pre-recorded lessen over het masteren van pyRevit MCP en Claude Code. Aanmelders ontvangen direct twee gratis PDF-gidsen over het gebruik van AI binnen Revit.

---
## 7. Vyssuals: Colorize & Analyze Revit Models

### Achtergrond en het ontstaan van Vyssuals
**Nick (BIM Pure):** Ik ben hier met Iskar Chindel, de maker van **Vyssuals**, een tool die direct verbinding maakt met Revit. Iskar, je werkte voorheen bij Zagon HDM en besloot toen voor jezelf te beginnen om deze tool te bouwen. Kun je ons vertellen waarom?

**Iskar Chindel:** Absoluut. We werkten aan een gigantisch ziekenhuisproject in San Francisco met maar liefst 5.500 kamers. Dat was simpelweg te veel om te beheren met de standaard ingebouwde methoden van Revit. We besloten daarom Revit te koppelen aan **PowerBI**. Dat gaf ons uitstekend inzicht en controle over de data in de modellen. 

Echter, zodra we een fout ontdekten in PowerBI, was het ontzettend omslachtig en tijdrovend om die fout in Revit op te zoeken en te herstellen. Ik wenste altijd dat er een tool bestond waarmee ik snel de inhoud van mijn BIM-modellen visueel kon analyseren (zoals de verdeling van oppervlaktes of technische parameters zoals base offsets en level adjustments), direct gekoppeld aan Revit via een tweerichtingsverbinding. Die tool bestond niet, dus besloot ik hem zelf te bouwen.

### Hoe werkt Vyssuals? (Color Splasher op steroïden)
**Nick:** De tool doet me in eerste instantie erg denken aan *Color Splasher*, een add-in die destijds door BIM One werd gemaakt en uiteindelijk zijn weg vond naar pyRevit. Het stelt je in staat om je Revit-modellen te visualiseren met kleuren op basis van data. Jouw tool voelt als "Color Splasher op steroïden". Kun je laten zien hoe het werkt?

**Iskar:** Zeker. Er is uiteraard een kleine Revit-addin die de verbinding maakt met de webapplicatie. Het werkt met een simpele startknop, vergelijkbaar met Enscape. Je klikt erop, het opent je browser en laadt direct het volledige Revit-model in de browser. 

Het is een volledige data-werkruimte met een 3D-model dat live via een tweerichtingsverbinding gekoppeld is aan Revit op de achtergrond.

#### Workflow van een data-visualisatie:
1. **Categorie selecteren:** Zoek bijvoorbeeld naar de categorie "Rooms". De tool toont direct alle beschikbare parameters voor kamers in het model.
2. **Parameter-kwaliteit controleren:** Je ziet direct een overzicht van hoe goed de parameter is ingevuld (het percentage ingevulde waarden).
3. **Visualiseren:** Klik op een parameter (bijvoorbeeld 'Occupancy'). Met één klik genereert de browser een staafdiagram van de verdeling én wordt het 3D-model direct ingekleurd op basis van deze waarden. Je hebt dus zowel de grafische chart als het gekleurde 3D-model naast elkaar.
4. **Terugschrijven naar Revit:** Klik op de knop **"Coloring in Revit"** linksonder. Als je nu terugschakelt naar Revit, is het model daar ook direct ingekleurd.

### Gegevensprivacy en Lokale Verbinding
**Nick:** Moet je het model hiervoor altijd eerst naar de cloud uploaden?

**Iskar:** Nee, dat is het unieke. De live-verbinding tussen Revit en de browser verloopt volledig **lokaal** op je eigen computer. Er wordt geen data over het internet gestuurd. Dit is cruciaal voor grotere bedrijven of projecten met strikte regels rondom gegevensprivacy en auteursrechten. De gebruiker behoudt de volledige controle en kan lokaal de data valideren. Pas als je dat wilt, kun je het model uploaden naar de cloud om het te delen met anderen.

### Belangrijke Use Cases

#### Use Case 1: Fouten opsporen (Architecten)
Architecten zijn visuele mensen. Als data diep verborgen zit in Revit-parameters, zie je fouten snel over het hoofd. Door data visueel te maken met kleuren, zie je direct of een kamer een verkeerde kleur heeft (bijvoorbeeld een buitenruimte die de kleur van een binnenruimte heeft gekregen). Zelfs als een foutieve ruimte diep in het model begraven ligt en onzichtbaar is in 3D, valt deze direct op in het staafdiagram naast het model als een 'outlier'.

#### Use Case 2: Rapporteren aan klanten en projectmanagers (Cloud Models)
Projectmanagers en klanten werken doorgaans niet in Revit, maar willen wel weten of het ontwerp voldoet aan het vereiste ruimteprogramma (bijvoorbeeld de verdeling van departementen).
* Binnen Vyssuals kun je naar **Cloud Models** gaan, een project aanmaken (bijvoorbeeld "BIM Pure") en het model uploaden.
* Dit is een **geversioneerde upload** (versioned upload), dus je kunt altijd terugkijken naar eerdere versies (bijvoorbeeld `Version 1`).
* De tool genereert een unieke weblink die je naar iedereen kunt sturen. De ontvanger krijgt exact dezelfde interactieve 3D- en diagram-interface in zijn browser, volledig onafhankelijk van Revit. Je kunt hiermee eenvoudig samenwerken en dashboards delen.

#### Use Case 3: Modelcontrole en IDS-achtige checks (BIM Managers / MEP)
Voor MEP-engineers of BIM-managers is het belangrijk om te controleren of alle elementen de juiste parameters hebben en of deze correct zijn ingevuld (een harde ja/nee-regel).
* **Stap 1 (Exists %):** Klik op het 'exists'-percentage om te controleren of de parameter überhaupt op de elementen aanwezig is (bindingcontrole). Dit genereert een overzichtelijke regel-check (rule check) voor alle categorieën in het model.
* **Stap 2 (Value %):** Klik op het waarde-percentage (bijvoorbeeld 95%) om te zien welke van deze elementen daadwerkelijk een waarde hebben ingevuld en welke leeg zijn.
* **Stap 3 (Allowed Values):** Voer een lijst met toegestane waarden in (bijvoorbeeld voor systeemclassificaties) om te controleren of de ingevoerde data correct is.
* **Tip voor rule-checks:** Voer controles uit in 'logische niveaus' (niet te veel tegelijk) om verwarring te voorkomen. Start breed (bestaat de parameter?) en verfijn de controle stap voor stap.
* **Sjablonen (Templates):** Je kunt je controle-indelingen opslaan als persoonlijke sjablonen of firmabrede sjablonen (organization templates). Zo kun je BIM-standaarden eenvoudig distribueren over het hele kantoor, zodat andere medewerkers dezelfde controles kunnen uitvoeren op andere modellen.

### AI en Model Context Protocol (MCP) Integratie
**Nick:** Gebruiken jullie AI of LLM-integratie voor modelcontroles?

**Iskar:** Ja, we hebben een **AI/MCP-integratie**. We hebben er bewust voor gekozen om AI niet direct in de software in te bouwen, maar de methode te gebruiken die jij ook in je video's laat zien: we laten een krachtige desktop-agent of **Claude Code** via ons Model Context Protocol (MCP) rechtstreeks verbinden met Vyssuals. 

Hierdoor kan de AI je Revit-model inspecteren, grafieken toevoegen of verwijderen, en zelfs wijzigingen in het model voorstellen om fouten direct vanuit het dashboard te corrigeren.

**Nick:** Dat is heel slim. Als je AI direct inbouwt, zit je met de enorme token-kosten van 'power users' die de hele dag AI gebruiken en waarvoor je extra moet factureren. Nu kunnen gebruikers hun eigen gepersonaliseerde Claude Code-omgeving met hun eigen geheugen koppelen. Bovendien is het een veilige barrière: de AI doet direct wijzigingsvoorstellen in het dashboard, die de BIM-manager eerst visueel kan controleren (bijvoorbeeld via highlight-kleuren) voordat de wijzigingen daadwerkelijk in het Revit-model worden doorgevoerd. Niets mag automatisch gaan; er moet altijd een professional tussen zitten om fouten te voorkomen.

### Use Case 4: Samenwerking met externe adviseurs (Multi-user Scenario)
Iskar demonstreert hoe een constructeur (structural engineer) en een BIM-manager kunnen samenwerken via de cloud-omgeving:
1. De BIM-manager deelt een geversioneerd cloud-model met de constructeur via een weblink.
2. De constructeur opent de link in een (incognito) browser. Hij krijgt een vereenvoudigde interface te zien met alleen de 3D-weergave en een tabel van de vloeren. De taak is om de codenamen voor de vloeren in te voeren.
3. De constructeur voert de codenamen in (bijvoorbeeld "pure"). Dit wordt in het systeem gemarkeerd als een **wijzigingsvoorstel** (change proposal).
4. De constructeur dient de wijzigingen in voor beoordeling (*"Send for review"*).
5. De BIM-manager opent het model in zijn eigen omgeving en ziet dat er een wijzigingsvoorstel klaarstaat. De tool toont exact de oude waarde, de nieuwe voorgestelde waarde en eventuele opmerkingen.
6. De BIM-manager kan voorstellen individueel accepteren (blauw) of weigeren (roze). 
7. Met één klik worden de geaccepteerde wijzigingen rechtstreeks naar Revit geschreven. Vervolgens uploadt de manager een nieuwe modelversie (`Version 2`) naar de cloud om de constructeur te updaten.

### Technische details en Snelheid (BIM Open Schema)
**Nick:** Welk bestandsformaat gebruiken jullie voor de export naar de browser? Gebruiken jullie IFC?

**Iskar:** Nee, IFC is veel te traag voor dit soort toepassingen. Ik heb Vyssuals getest met Revit-modellen van meer dan 1 GB groot, en de laadtijd in de browser is slechts **2 seconden**. 

Onze data- en geometriestructuur is gebaseerd op het concept van Christopher Diggins, die de **BOS (BIM Open Schema)** heeft ontwikkeld. Wij houden de geometrie-data en de parameter-data strikt van elkaar gescheiden in de achtergrond via **Parquet-bestanden**. Hierdoor hoeft niet iedereen altijd de zware geometrie te laden als ze alleen data willen bewerken, en kunnen we een ongeëvenaarde snelheid garanderen.

Vyssuals biedt een gratis proefperiode van 30 dagen aan via hun website `vyssuals.com`.
