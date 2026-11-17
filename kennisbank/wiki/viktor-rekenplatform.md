---
titel: VIKTOR — cloudplatform voor rekentools, en wat het bureau ervan kan overnemen
status: concept
laatst-bijgewerkt: 2026-11-17
bronnen:
  - "raw/2026-11-17-externe-bronnen-github-en-viktor.md §2 (verkenning 17-11-2026; publieke webpagina's en GitHub-README's, geen account, niets gedraaid)"
  - https://www.viktor.ai/plans
  - https://www.viktor.ai/blog/251/solving-engineering-problems-will-get-a-lot-easier-with-viktor-desktop
  - https://www.viktor.ai/blog/269/how-to-scale-ai-in-your-engineering-organization-generate-results-you-can-trust
  - https://www.viktor.ai/blog/271/what-s-new-in-viktor-november-2026
  - https://docs.viktor.ai/docs/create-apps/software-integrations/revit/
  - https://docs.viktor.ai/docs/create-apps/software-integrations/scia/
  - https://github.com/viktor-platform
verwant:
  - externe-bronnen-ronde-nov2026.md
  - revit-robot-interoperabiliteit.md
  - mcp-versus-custom-tools.md
  - lees-mcp-koppeling.md
  - externe-bronnen-ronde-okt2026.md
---

# VIKTOR

Verkenning van 17-11-2026, zonder account en zonder iets te draaien. Bron:
`raw/2026-11-17-externe-bronnen-github-en-viktor.md` §2. De SDK-documentatie gaf
een 403; wat daaruit komt, is via een zoekmachine gelezen en staat hieronder als
zodanig gemarkeerd.

## Wat het is

VIKTOR is een Rotterdams bedrijf met een cloudplatform waarop ingenieurs met een
Python-SDK webapps bouwen: invoervelden, een berekening, en views of een rapport.
De apps draaien in de VIKTOR-cloud op AWS. Het bedrijf noemt ISO 27001 en 9001
([blog 213](https://www.viktor.ai/blog/213/automating-engineering-tasks-with-viktor-a-guide-to-safe-high-quality-innovation)).
De hostingregio is niet gevonden.

[ONBEVESTIGD] Het oprichtingsjaar: 2012 volgens CB Insights, 2017 volgens
YES!Delft. Let op de naamgenoot viktor.com, een Slack-agent zonder verband.

### Lokale software via workers

Een **worker** op een Windows-pc verbindt uitgaand met de cloud en stuurt daar
lokale software aan: SCIA, Revit, Dynamo, ETABS, STAAD, Plaxis, Excel. Sinds juli
2026 beheert VIKTOR Desktop die workers, met een installatie per integratie
([blog 251](https://www.viktor.ai/blog/251/solving-engineering-problems-will-get-a-lot-easier-with-viktor-desktop)).

[ONBEVESTIGD] De SCIA-integratie eist dat materialen in het ESA-template bestaan
en dat template en worker dezelfde SCIA-versie hebben. Gelezen via een
zoekmachine; de docs-pagina zelf gaf 403.

Technosoft, het hoofdrekenpakket van het bureau, heeft geen VIKTOR-integratie
(niet gevonden, stand 17-11-2026). Voor de koppeling Revit ↔ rekenmodel blijft
`revit-robot-interoperabiliteit.md` en de eigen Technosoft-route het vertrekpunt.

### AI-functies

| Wanneer | Wat | Bron |
|---|---|---|
| 2025 | App Builder: genereert een app uit een prompt, code inzichtelijk | AEC Magazine |
| januari 2026 | agent die apps als deterministische tools aan elkaar knoopt; nog wachtlijst | blog 225 |
| april 2026 | "self-hosted LLM" in apps; waar die draait staat er niet | blog 238 |
| juni 2026 | leest `.xlsm` en Mathcad en zet die om naar een Python-app | blog 247 |
| november 2026 (beta) | apps aanroepen vanuit Claude, ChatGPT of Gemini via MCP; de agent "cannot read or write project data" | blog 271 |

### Prijs

De [plans-pagina](https://www.viktor.ai/plans) kent Free (1 gebruiker, alleen
publieke apps), Individual, Small Business, Business en Enterprise (vanaf 20
Power Builders). Alles boven Free is "Contact us", met credits voor rekentijd.
[ONBEVESTIGD] Het bedrag per stoel; ook Capterra en TrustRadius noemen geen prijs.

### Publieke repo's

[viktor-platform](https://github.com/viktor-platform) heeft 86 publieke repo's,
vooral voorbeeldapps zonder licentie. Voor ons relevant: `cpt-interpreter` (GEF →
grondopbouw met Robertson), `sample-pile-foundations` (D-Foundations + SCIA),
`scia-bridge`, `ifc-viewer`, de MIT-pakketten `bro` en `pyrevit-plugin`, en twee
Revit-voorbeelden die de pyRevit Agent Runtime aanroepen
(`externe-bronnen-ronde-nov2026.md` §2 #12).

### Nederlandse cases

Arcadis (D-Foundations, Excel en SCIA gekoppeld), Heijmans (Excel-rekenbladen
aan SCIA) en Heembouw met WSP (staal-app: inloggen vanuit Revit, profielen terug
in het model) ([case Heembouw](https://www.viktor.ai/customer-cases/55/parametric-design-for-sustainable-construction-at-heembouw)).
Een middelgroot constructiebureau met Revit + Technosoft is niet gevonden.

## Wat het bureau kan overnemen

1. **Release-discipline voor rekentools.** VIKTOR scheidt per app een test- en
   productieversie. Een collega reviewt de code en draait een case met bekende
   uitkomst vóór vrijgave; elke versie heeft tag, maker en datum
   ([blog 269](https://www.viktor.ai/blog/269/how-to-scale-ai-in-your-engineering-organization-generate-results-you-can-trust)).
   Het lint heeft dat al als 03_R&D → 02_Beta → 01_SCI (skill
   `bimtools-promotie`). Voor de Ontwerptools en de rekenfuncties in de
   SCI-Viewer bestaat zoiets nog niet. Over te nemen: per rekentool een vaste
   testcase met bekende uitkomst die bij elke versie meedraait.
2. **Apps als deterministische tools voor een agent.** Hun MCP stelt alleen de
   app-logica bloot, niet de projectdata. Dat sluit aan op de eis "determinisme
   in productie" in `mcp-versus-custom-tools.md` §3 (Gavin Nicholls): laat Claude
   rekenwerk overlaten aan getoetste functies in plaats van zelf te rekenen.
3. **Revit via de pyRevit Agent Runtime.** Hun nieuwste Revit-voorbeeld draait op
   `pyrevit agent run` met `query`/`dry_run`/`modify`. Dat bevestigt de richting
   uit `externe-bronnen-ronde-nov2026.md` §1 voor onze eigen koppeling.
4. **Legacy-rekenbladen omzetten.** De App Builder vertaalt `.xlsm` naar Python.
   Dat kan Claude ook zonder platform; de controle hoort er hetzelfde bij: oude
   en nieuwe uitkomst naast elkaar op dezelfde cases.
5. [ONBEVESTIGD] **UI-patroon rekentool**: links invoer met dynamische tabellen,
   rechts 3D, grafiek, tabel en rapport, elk resultaat herleidbaar tot de invoer.
   Afgeleid uit README's van voorbeeldrepo's; de SDK-docs gaven 403.

Punt 4 is in het lint al eens zo gedaan. Koppeling Berekening (02_Beta, sinds
12-11-2026) verving Dynamo-script `004 Koppeling ber doc naar revit` en is getoetst
door de CPython-uitkomst naast die onder IronPython te leggen op het
berekeningsdocument van S-9266 (memory `koppeling-berekening-uit-dynamo`). Een
vaste testcase per versie, zoals punt 1 vraagt, heeft die knop nog niet.

## Wanneer het platform zelf zin heeft

**Wel** als rekentools door veel collega's of opdrachtgevers via een browser
gebruikt moeten worden zonder installatie, met accountbeheer, audit trail en
versiebeheer dat niemand intern wil onderhouden. Of als SCIA, Plaxis of
D-Foundations vanuit een webapp in batch moeten draaien.

**Niet nu** (stand 17-11-2026), om deze redenen uit de bron:

- de kernstukken draaien al lokaal zonder licentiekosten: de SCI-Viewer als één
  HTML-bestand, het pyRevit-lint, Claude met de eigen MCP;
- Technosoft heeft geen integratie;
- alles boven Free is een stoelabonnement op aanvraag;
- apps en code draaien in hun cloud, dus projectdata verlaat het huis, en apps
  zijn gebonden aan hun SDK: overstappen betekent herschrijven;
- Free staat alleen publieke apps toe, dus niet bruikbaar voor projectwerk.

Goedkope tussenweg: een gratis account alleen om de App Builder en de
Blueprints-apps te bekijken, zonder projectdata. Een account aanmaken doet de
gebruiker zelf.
