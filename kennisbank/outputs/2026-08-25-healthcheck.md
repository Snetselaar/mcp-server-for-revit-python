---
type: healthcheck
datum: 2026-08-25
omvang: 1 wiki-artikel, 207 regels
---

# Health check 2026-08-25

**Artikelen:** 1 (`mcp-revit-koppeling.md`, status concept).
**Bevindingen:** 1 tegenstrijdigheid · 4 claims zonder bron · 5 gaten ·
0 verouderd · 3 stijlpunten.
**Ernstigste punt:** de tools die de skill `sci-bim-context` §C noemt bestaan
geen van alle in deze repo. Zolang dat niet is uitgezocht, staat er in de skill
een tabel waar niemand iets aan heeft.

Dit is de eerste check, op een kennisbank die één dag oud is. Hij dient vooral om
te bewijzen dat de controle werkt en om de startschuld vast te leggen.

---

## 1. Tegenstrijdigheden

**Tussen wiki-artikelen onderling:** geen. Er is één artikel.

**Tussen wiki en skills:** één, en die is ernstig.

| | |
|---|---|
| Waar | `wiki/mcp-revit-koppeling.md` §6 tegenover skill `sci-bim-context`, `references/template-en-mcp.md` §C |
| Wiki zegt | Deze repo registreert 20 tools met namen als `get_current_view_info`, `list_revit_views`, `list_families`. Onderbouwd met `tools/*.py`, regel voor regel nagelopen. |
| Skill zegt | "Veelgebruikte Revit-MCP-tools" zijn `get_active_view_in_revit`, `get_all_workset_information`, `get_all_warnings_in_the_model`, `get_all_used_families_in_model`, `get_all_project_units`, `get_category_by_keyword`, `get_parameter_value_for_element_ids`. |
| Feit | Geen van die zeven namen komt voor in deze repo. |

Volgens `CLAUDE.md` §3 regel 2 wint de skill bij twijfel. Hier gaat die regel
niet op, want het gaat niet om een oordeel maar om een controleerbaar feit: de
namen staan er niet. Waarschijnlijker is dat de skill een **andere**
Revit-MCP-server beschrijft dan deze repo.

**Voorstel:** uitzoeken welke server er in Revit daadwerkelijk draait. Draai
`get_revit_status` of open `http://localhost:48884/revit_mcp/status/`; komt daar
antwoord met `"api_name": "revit_mcp"`, dan is het déze repo en moet de tabel in
de skill vervangen worden door de tabel uit §4 van het artikel. Niet aanpassen
voordat dit is vastgesteld.

**Tweede, kleinere afwijking:** de skill beschrijft starten in combined
HTTP-modus met de client op `http://localhost:8000/mcp`; `.mcp.json` in deze repo
configureert stdio. Beide werken. Dit is geen fout, maar wel twee opstellingen
die door elkaar heen gedocumenteerd staan.

## 2. Claims zonder bron

Vier regels lezen als vastgesteld terwijl er niets onder ligt. Geen ervan is
gemarkeerd met `[ONBEVESTIGD]`.

| Regel | Claim | Wat eraan mankeert |
|---|---|---|
| 45 | "De scheiding is het punt waar de meeste verwarring vandaan komt." | Oordeel, geen feit. Nergens gemeten of waargenomen. Schrappen of omzetten naar een waarneming met datum. |
| 56 | "Dat zijn de enige twee tools die werken zonder draaiende Revit." | Afleiding uit de README-noot, niet letterlijk zo gesteld. Klopt waarschijnlijk, maar hoort `[ONBEVESTIGD]` of een verwijzing naar de code in `tools/launch_tools.py`. |
| 47-48 | "IronPython 2.7-engine binnen Revit" | De repo bewijst alleen Python 2-syntax (`from StringIO import StringIO`). Dat het IronPython 2.7 is en niet de CPython-engine van pyRevit komt uit de skill `pyrevit-codestijl`, en dat staat er niet bij. |
| §5 punt 1 | "Moet per Revit-sessie aan" | De README beschrijft het activeren van de Routes Server, maar zegt elders dat de service automatisch laadt bij het starten van Revit. Die twee beweringen sluiten elkaar niet uit, maar "per sessie" is niet onderbouwd. Nameten in Revit. |

**Bronnen in de frontmatter kloppen niet volledig.** `LLM.txt` staat als bron
vermeld maar wordt nergens in de tekst aangehaald. Ofwel eruit, ofwel gebruiken.

Alle regelverwijzingen naar code zijn wel nagelopen en klopten op 2026-08-25.

## 3. Gaten

1. **De wiki gaat over de verkeerde helft van het werk.** Het enige artikel gaat
   over deze repo. Over het echte SCI-werk — modellen, scripts, conventies,
   detailtekeningen — staat er niets. Dat zit volledig in de skills. Zolang dat
   zo is, voegt de wiki niets toe.
2. **`raw/` is leeg.** `/kb-verwerk` heeft niets te doen. Zonder instroom is dit
   geen kennisbank maar een map. Eerste zinvolle dumps: openstaande tracebacks,
   aantekeningen van overleg over het lint, alles over Revit 2027.
3. **Geen enkel `verwant:`-verband.** Met één artikel kan het niet, maar het
   betekent dat de kruisverwijzing — waar de waarde vandaan moet komen — nog
   onbewezen is.
4. **`W:` is onbereikbaar vanuit cloudsessies.** De drie extensies,
   `Actielijst lint.xlsm` en de logbestanden staan op de netwerkschijf. Materiaal
   daarvandaan kan alleen vanuit een lokale sessie in `raw/` komen. Onopgelost;
   dit begrenst structureel wat een cloudsessie kan verwerken.
5. **Ongebruikte tools in deze repo.** Voor worksets, warnings en project units
   bestaat hier geen tool — alleen via `execute_revit_code`. Of dat in de praktijk
   knelt is niet vastgelegd.

Geen webzoekopdrachten uitgevoerd; deze check is zonder het argument `web`
gedraaid. Gat 1 en 2 zijn ook niet met zoeken op te lossen.

## 4. Veroudering

Geen enkel artikel ouder dan 90 dagen. Alles is van vandaag.

Wel: het enige artikel staat op `status: concept`. Dat is terecht, maar zet in de
agenda dat het over drie maanden nog steeds concept kan zijn zonder dat iemand
het merkt.

Twee onderwerpen in het artikel verlopen sneller dan de rest en verdienen
opnieuw nakijken bij elke Revit-upgrade: het hardgecodeerde pad in `.mcp.json`
(`C:\Users\S-WOU1A\...`) en de tabel met 20 tools, die verschuift zodra upstream
iets toevoegt.

## 5. Stijl

Drie punten, alle drie licht.

- **Regel 15 (datum bij alles wat kan verlopen).** De toolstabel in §4 heeft geen
  peildatum. Voeg toe dat hij op 2026-08-25 is nagelopen tegen `tools/*.py`.
- **Regel 12 (onzekerheid expliciet).** Zie de vier claims uit controle 2. De
  markering `[ONBEVESTIGD]` is in §6 wel netjes gebruikt, in §1 en §5 niet.
- **Regel 19 (geen bold-spam).** `**Uitzondering:**`, `**Gevolg:**`,
  `**Wat te doen:**` — dit patroon komt zes keer voor. Op zichzelf verdedigbaar
  als structuur, maar het zit tegen de grens aan.

Geen vulwoorden uit regel 6 aangetroffen. Echte namen en getallen (poort 48884,
`S-8985`, `TO-121`) worden gebruikt waar ze bekend zijn — regel 11 in orde.

---

## Voorgestelde acties, op volgorde

1. Vaststellen welke Revit-MCP-server er draait (controle 1). Dit blokkeert het
   opschonen van de skill.
2. De vier ongemarkeerde claims uit controle 2 repareren: bron erbij of
   `[ONBEVESTIGD]` ervoor. `LLM.txt` uit de frontmatter of gebruiken.
3. Materiaal in `raw/` dumpen zodat `/kb-verwerk` iets te doen heeft. Zonder dit
   staat de kennisbank stil.
4. Overwegen `use_transaction` als issue te melden bij upstream — een
   gedocumenteerd payload-veld dat nergens wordt uitgelezen is een valstrik voor
   iedereen die de docstring leest.

Wiki-artikelen zijn niet gewijzigd. `index.md` is bijgewerkt met de gevonden
gaten.

---

## Opvolging (2026-08-25, zelfde dag)

Actie 2 is direct uitgevoerd. In `wiki/mcp-revit-koppeling.md`:

- de oordeelszin over "de meeste verwarring" geschrapt;
- de IronPython 2.7-herkomst toegeschreven aan de skill `pyrevit-codestijl` in
  plaats van aan deze repo;
- de "enige twee tools"-claim onderbouwd met `tools/launch_tools.py`;
- faalpunt 1 voorzien van `[ONBEVESTIGD]` over "per Revit-sessie";
- peildatum toegevoegd bij de toolstabel (stijlregel 15);
- `LLM.txt` uit de frontmatter gehaald, want hij werd nergens aangehaald.

Actie 1, 3 en 4 staan nog open. De bevindingen hierboven beschrijven de staat bij
het draaien van de check en zijn met opzet niet herschreven.

---

## Opvolging (2026-08-26)

**Actie 1 is afgehandeld.** Met Revit open (PID 30312, model `S-9132_R25 -
versie drie kappen`) luistert de Routes Server op **48885**, niet op 48884, en
antwoordt met `"api_name": "revit_mcp"`. Het is dus déze repo die draait. De
tabel met zeven toolnamen in `sci-bim-context` §C beschrijft iets anders en mag
vervangen worden door de twintig namen uit §4 van het artikel. Dat is nog niet
gedaan: skills worden op claude.ai bewerkt, niet op schijf.

Twee dingen kwamen daarbij boven water die in deze check niet stonden:

1. **De poort ligt niet vast.** `main.py` had 48884 hardgecodeerd zonder
   override. Nu instelbaar via `REVIT_HOST`/`REVIT_PORT`, met 48884 als
   onveranderde default, zodat het gedrag zonder omgevingsvariabelen gelijk
   blijft aan upstream.
2. **`.mcp.json` was stuk.** Het wees naar
   `Documents\GitHub\mcp-server-for-revit-python\`, waar na de OneDrive-verhuizing
   alleen de pyRevit-helft staat — geen `main.py`, geen `.venv`. De MCP-server
   kon niet starten. Rechtgezet naar de clone onder OneDrive, met
   `REVIT_PORT=48885` onder `env`.

Dit raakt controle 4 van deze check: het hardgecodeerde pad in `.mcp.json` stond
daar als iets dat "sneller veroudert dan de rest". Het was op dat moment al
verlopen, alleen niet nagemeten.

Actie 3 (materiaal in `raw/`) is inmiddels deels gebeurd — er staan drie dumps
van 2026-08-25 klaar, nog niet verwerkt. Actie 2 was op de dag zelf al gedaan.
Actie 4 (`use_transaction` melden bij upstream) staat nog open.
