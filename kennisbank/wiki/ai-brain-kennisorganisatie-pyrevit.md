---
titel: AI-Brain — een raw/wiki/skills-kennisdatabase voor de Revit API
status: concept
laatst-bijgewerkt: 2026-08-31
bronnen:
  - "raw/2026-08-31-uitgebreide-transcriptie-ai-bim-revit-automation-.md §5"
verwant:
  - revit-bronnen-en-communities.md
---

# AI-Brain — een raw/wiki/skills-kennisdatabase voor de Revit API

Erik Frits bouwde een kennisdatabase in **Obsidian** (Markdown-gebaseerd) op
basis van vier jaar aan cursusmateriaal, nieuwsbrieven, video's en meer dan 600
code-snippets over de Revit API en pyRevit
(`raw/2026-08-31-uitgebreide-transcriptie-ai-bim-revit-automation-.md` §5). Het
doel: de AI een foutloos, op zijn eigen lesmethoden gebaseerd begrip van de
Revit API geven, in plaats van generieke internetkennis.

## 1. De drielaagse structuur

| Laag | Kleur in Obsidian | Wie schrijft | Karakter |
|---|---|---|---|
| Raw sources | blauw | Erik zelf | onveranderlijk: lessen, nieuwsbrieven, video's, snippets |
| Wiki | groen | de AI | conceptdocumenten, opgebouwd en onderhouden uit de raw sources |
| Skills | (niet gekleurd genoemd) | de AI, uit de wiki | concrete, direct bruikbare regels voor codegeneratie |

Dit is dezelfde indeling als `kennisbank/CLAUDE.md` §2 en §4 van deze repo:
`raw/` is append-only en onveranderlijk, `wiki/` wordt alleen door Claude
geschreven op basis van `raw/`, en een stabiel wiki-artikel promoveert naar een
skill. Het is geen toeval — beide zijn gebaseerd op hetzelfde bronconcept, zie
§3. De parallel is een zelfstandige bevestiging dat het patroon schaalt: Erik
Frits meet het toegepast op 4.000 transcriptiebestanden en vier jaar aan
lesmateriaal, ruim voorbij de omvang van deze kennisbank.

## 2. Het conceptdocument "Selection" als voorbeeld

Een wiki-document (versie 10, na handmatige sturingen) dat alle
selectiemethoden bundelt die Erik in zijn cursussen doceert:

1. de theoretische basis van selectie in de Revit API;
2. zeven selectiemethoden met argumenten, overloads en code-snippets;
3. instructies voor veilig prompten;
4. tips voor gebruikerservaring (bijvoorbeeld een waarschuwingsbalk);
5. complexe scenario's, zoals selecteren uit gekoppelde modellen;
6. **veelvoorkomende fouten en oplossingen** — verzameld uit alle lessen waarin
   Erik een fout noemt. Twee voorbeelden die letterlijk overdraagbaar zijn naar
   elk selectiescript: `Escape` tijdens een selectie breekt het script af, op te
   vangen met `try-except`; een lege selectie moet expliciet gecontroleerd
   worden voordat het script verdergaat.

Diezelfde opzet bestaat voor "Filters": alle trage, snelle en logische filters
van de Revit API met shortcuts, tot in detail vastgelegd.

[ONBEVESTIGD] Of dit conceptdocument iets bevat dat afwijkt van wat
`revit-api-docs` als geverifieerd erkent — de skill gaat bij tegenspraak voor
(`kennisbank/CLAUDE.md` §3).

## 3. Het LLM Wiki-concept (Andrej Karpathy)

Het systeem is gebaseerd op het "LLM Wiki"-concept van Andrej Karpathy
(voormalig hoofd AI bij Tesla, bedenker van de term "vibe coding"). De
kernaanname: een klassiek RAG-systeem (retrieval-augmented generation) dat
ruwe documenten doorzoekt op het moment van een vraag, verliest informatie en
is moeilijk te onderhouden. Een LLM Wiki bouwt in plaats daarvan incrementeel
een persistente laag van concepten op, zodat de AI met samengevatte, verbonden
kennis werkt in plaats van met losse fragmenten.

Dit is precies de reden waarom `kennisbank/CLAUDE.md` §1 bestaat: "kennis die
nu in een sessie ontstaat verdwijnt met die sessie." Beide projecten lossen
hetzelfde probleem op, onafhankelijk van elkaar bedacht.

## 4. "The Law" en de verificatielaag

Erik heeft rond zijn AI-Brain een controlelaag gebouwd:

- **`law.md`** — de grondwet: regels, templates, evaluatiemethoden en de
  vaste structuur van een conceptdocument (inleiding, basismethoden,
  geavanceerde functies, edge cases, veelvoorkomende fouten, conclusie).
- **Schema** — een door de AI geschreven definitie van welke metadata elk
  bestand moet hebben.
- **Linear + GitHub als verificatielaag** — wil Erik een regel in `law.md`
  laten aanpassen, dan voert de AI die wijziging niet direct door. Ze maakt een
  issue in Linear en een pull request op GitHub waarin oude en voorgestelde
  regel naast elkaar staan. Pas na goedkeuring in Linear wordt de wijziging
  doorgevoerd; bij twijfel kan een los aan te roepen agent de PR weer sluiten.

Dit is een zwaardere versie van wat `kennisbank/CLAUDE.md` §2 al afdwingt voor
deze repo (`wiki/` alleen door Claude, nooit handmatig), maar zonder externe
review-laag. Erik's eigen advies relativeert dat overigens meteen, zie §5.

## 5. Cijfers en de eigen waarschuwing tegen overengineering

Kosten tot nu toe: circa 4 miljard tokens (grotendeels gecached via prompt
caching), 27 API-calls, 22 actieve sessies, 4.000 verwerkte
transcriptiebestanden.

Ondanks die schaal is Eriks eigen advies: begin zo eenvoudig mogelijk. Elke
regel in `law.md` voegt frictie toe; zijn eigen grondwet van 600 regels leidde
tot merkbare wrijving en fouten in GitHub-merges. Hij noemt zichzelf op dit
punt een "control freak" — een waarschuwing, niet een aanbeveling om na te
volgen. Mens bepaalt de betekenis en stuurt de kwalitatieve analyse; de AI doet
het kruisverwijzen en indexeren.

Voor deze kennisbank is dat een directe toetssteen: `kennisbank/CLAUDE.md`
telt op 2026-08-31 acht genummerde secties, geen 600 regels. Zolang die
verhouding zo blijft, is de eigen waarschuwing niet van toepassing — maar het
is de vergelijkingsmaat om bij te houden als het schema in de toekomst groeit.

## 6. Doel: sneller coderen en studentondersteuning

Twee toepassingen: zelf sneller en foutlozer programmeren met de opgebouwde
skills, en de kennisdatabase koppelen aan een leerplatform (Learn Revit API
Academy 3.0) zodat een AI-assistent studenten direct naar de juiste les of
code-snippet verwijst.

Genoemde bronnen voor wie dit zelf wil bouwen: Karpathy's LLM Wiki-document
minstens twee tot drie keer doorlezen vóór het plannen, en twee mensen die hun
pyRevit-skills deelden om het AI-Brain tegen te benchmarken: Alexander
Gamkavoy (77 pyRevit-skills) en Juvenio Silva.

[ONBEVESTIGD] Waar Gamkavoy's 77 skills of Silva's materiaal te vinden zijn —
de bron noemt alleen de namen, geen link of repository.
