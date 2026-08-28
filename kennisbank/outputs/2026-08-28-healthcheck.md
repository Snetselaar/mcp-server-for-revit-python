---
type: healthcheck
datum: 2026-08-28
omvang: 9 wiki-artikelen
---

# Health check 2026-08-28

**Artikelen:** 9, alle `status: concept`.
**Bevindingen:** 0 nieuwe tegenstrijdigheden (1 bekende, in behandeling) ·
0 ongemarkeerde claims in de wiki · 5 gaten (3 nieuw en concreet) · 0 verouderd
(>90 dagen) · 0 stijlovertredingen · 0 kapotte kruisverwijzingen · coverage
volledig.
**Ernstigste punt:** de correctie van `sci-bim-context` §C staat sinds
2026-08-28 in de skillbron maar is niet naar claude.ai geüpload. Tot die upload
leest Claude in een gesprek nog de acht verzonnen toolnamen. Dit is een handeling
van de gebruiker en blokkeert niets in de wiki, maar het is de enige plek waar de
vastgelegde kennis en de kennis-in-gebruik uiteenlopen.

Dit is de tweede check. De eerste (2026-08-25) draaide op één artikel; sindsdien
zijn er acht bijgekomen, waarvan twee vandaag. De kennisbank is in goede staat —
de bronvermelding is streng, de `[ONBEVESTIGD]`-discipline wordt gevolgd en de
kruisverwijzingen kloppen. Wat volgt is grotendeels fijnregeling.

---

## 1. Tegenstrijdigheden

**Tussen wiki-artikelen onderling:** geen. Gecontroleerd op verkapte gevallen —
poorten, paden, versiegrenzen, categorie-conventies. De 48884/48885-poort wordt
overal via `mcp-revit-koppeling.md` §2 aangehaald en nergens tegengesproken. De
versietabel in `rebar-3d-modelleren.md` §1 is de enige plek waar 2024/2025-grenzen
staan; andere artikelen verwijzen ernaar in plaats van hem te herhalen.

**Tussen wiki en skills:** één bekende, en die is onder controle.

| | |
|---|---|
| Waar | `mcp-revit-koppeling.md` §6 tegenover skill `sci-bim-context`, `references/template-en-mcp.md` §C |
| Stand | De skillbron is op 2026-08-28 gecorrigeerd (acht namen → twintig echte). De upload naar claude.ai ontbreekt nog. |
| Gevolg | De versie die Claude in een gesprek leest, spreekt de wiki nog tegen. |

Dit is geen nieuw probleem en het artikel documenteert het expliciet (§6, slot).
Niets aan te doen in de wiki; zie het actieplan.

**Nieuw, en correct afgehandeld:** het voorbeeldscript in
`mcp-eigen-tools-toevoegen.md` §1 komt uit de bron en gebruikt
`el_id.IntegerValue`. Dat breekt vanaf Revit 2026 (`.Value`). Dit is een conflict
tussen de bron en de skill `pyrevit-codestijl`, niet tussen de wiki en een skill:
het artikel neemt het niet over maar zet er een waarschuwingsblok bij dat de skill
laat winnen. Zo hoort het. Geen actie.

## 2. Claims zonder bron

**In de wiki: geen ongemarkeerde feitelijke claim gevonden.** De negen artikelen
attribueren hun beweringen aan een raw-bestand, een repo-regel, een opgezochte URL
of een meting, en gebruiken `[ONBEVESTIGD]` waar de onderbouwing ontbreekt. De
twee nieuwe artikelen zijn nagelopen regel voor regel; alle claims dragen een
bron of een markering.

Twee kanttekeningen, beide al in de artikelen zelf benoemd:

- **`rebar-api-parameters.md`** noemt vijf URL's in de frontmatter, maar §0 zegt
  dat geen ervan is opgehaald (proxy gaf 403). Het zijn zoekresultaat-URL's, geen
  geverifieerde bronnen. Het artikel is hier eerlijk over. Openstaand tot iemand
  de tabel vanaf de werkplek naloopt.
- **`mcp-revit-koppeling.md`** leunt op code-regelverwijzingen (`main.py:24-25`
  enz.). Die zijn voor het laatst nagelopen op 2026-08-26. Vanuit een cloudsessie
  niet te herverifiëren; ze kunnen schuiven zodra upstream `main.py` wijzigt.

**Broncontrole:** alle in de frontmatter genoemde `raw/`-bestanden bestaan nog
(`2026-08-25 samenvatting-bronnen.md`, `2026-08-25-samenvatting-revit-structure-rebar.md`,
`2026-08-27_revit_mcp_bronnen_transcripties.md`). Geen dode raw-verwijzing.

## 3. Gaten

**Uit de nieuwe bron, bewust of licht overgeslagen** (lage waarde, geen actie
nodig):

- De **organisatie-analogie** van Erik Frits (Client / Project Manager / Workers /
  Project) uit §1 is niet overgenomen. Didactisch beeld, geen kennis.
- De **volledige lijst transport-modes** (SSE, streamable-HTTP) uit §2 staat niet
  in de wiki; `mcp-revit-koppeling.md` noemt alleen stdio en combined, de twee die
  hier daadwerkelijk gebruikt worden. Aanvulbaar als het ooit uitmaakt.

**Nieuw en wél concreet** (naar `index.md` verplaatst):

1. Staat pyRevit Routes op de SCI-werkplekken op `localhost` of nog op de
   standaard `0.0.0.0`? Zie `mcp-revit-koppeling.md` §2.
2. Draait er ergens pyRevit 6.5.3 (Routes-bug)? Zie §5 punt 7.
3. Welke Revit-versies draait SCI in productie? Bepaalt of de Autodesk 2027
   MCP-server in beeld komt (`mcp-versus-custom-tools.md` §4) en overlapt met de
   openstaande versievragen bij de rebar-artikelen.

**Staande gaten, onveranderd:** `W:` onbereikbaar vanuit cloudsessies; de acht
BuiltInParameters half geverifieerd; geen vastgelegde SCI-tagfamilie voor
wapening; onbekend of de IFC-scripts BIM Basis ILS volgen. Deze staan al in
`index.md` en zijn deze ronde niet dichter bij een antwoord gekomen.

Geen webzoekopdracht uitgevoerd; deze check draaide zonder het argument `web`.

## 4. Veroudering

Geen enkel artikel ouder dan 90 dagen — de oudste is van 2026-08-26, twee dagen
oud. Geen enkele `laatst-bijgewerkt:` valt buiten de grens.

**Alle negen staan op `status: concept`.** Dat is terecht (de promotiedrempel uit
`CLAUDE.md` §4 vraagt twee onafhankelijke bronnen, en de meeste artikelen leunen
op één gecureerde dump), maar het is een categorie om over drie maanden opnieuw
tegen te houden: concept dat concept blijft zonder dat iemand het merkt.

**Twee artikelen raken sneldraaiende feiten** en verdienen herijking bij elke
Revit-cyclus:

- `mcp-versus-custom-tools.md` §4 beschrijft de Autodesk 2027 MCP-server als
  "Technical Preview, beperkt". Die beta beweegt; herlees bij Revit 2027-uitrol.
- `mcp-revit-koppeling.md` §5 punt 7 (pyRevit 6.5.3-bug) hangt aan een
  pyRevit-versie zonder issuenummer.

## 5. Stijl

**Nul overtredingen in `wiki/` en `outputs/`.** De verboden-woordenlijst (regel 6)
is met een grep over de hele kennisbank getoetst: elke treffer zit in `raw/` (de
onaangeroerde dumps, waar de stijlgids niet geldt) of in `stijlgids.md` zelf. De
twee nieuwe artikelen bevatten geen van de gemarkeerde woorden — de "van cruciaal
belang"-formulering uit de bron (§4, over de docstring) is bij het overnemen
herschreven.

Echte namen en getallen (regel 11) worden gebruikt: poort 48884/48885, model
`S-9132_R25`, `mcp dev main.py`, poort 6274. Datum bij vervalbare feiten (regel 15)
staat bij de Autodesk 2027-beta en de pyRevit-versiebug.

## 6. Kapotte kruisverwijzingen

**Scripted gecontroleerd** (PowerShell-variant van het script uit `kb-check.md`
§6): **0 problemen op 9 artikelen.** Geen ontbrekend doelwit, geen eenzijdige
`verwant:`-link, geen weesartikel. De vier nieuwe/gewijzigde frontmatter-blokken
van deze week (koppeling, eigen-tools, versus-custom, bronnen) zijn aan beide
kanten bijgewerkt.

In-tekst gecontroleerd: de §-verwijzingen in de twee nieuwe artikelen wijzen naar
bestaande secties (`mcp-revit-koppeling.md` §1/§3/§4/§5, `rebar-api-parameters.md`
§4). Eén losse waarneming: `mcp-versus-custom-tools.md` §4 verwijst in de tekst
naar `rebar-api-parameters.md` zonder dat die als `verwant:` in de frontmatter
staat. Geen kapotte link — het doel bestaat — en het verband (de versiespanning
2024–2027) is secundair. Optioneel toe te voegen; niet vereist.

## 7. Coverage — is elk raw-bestand écht verwerkt?

Alle vier de bestanden in `raw/` staan in `memory.md` en zijn per sectie
nagelopen. Geen half werk gevonden.

| Raw-bestand | Secties | Terug te vinden in |
|---|---|---|
| `2026-08-25 samenvatting-bronnen.md` | §1 t/m §5 | rebar-3d-modelleren, rebar-documentatie, revit-bronnen (§2–5). Volledig. |
| `2026-08-25-samenvatting-revit-structure-rebar.md` | §1 t/m §5 | rebar-3d, rebar-documentatie, revit-robot, nlrs, rebar-api-parameters. Volledig. |
| `2026-08-25 zelfverbeterende-kennisbank-claude.md` | — | Bewust geen wiki-artikel (buiten bereik §1); gebruikt om `kb-check` en `CLAUDE.md` te verbeteren. Zoals gelogd. |
| `2026-08-27_revit_mcp_bronnen_transcripties.md` | §1 t/m §8 | mcp-eigen-tools-toevoegen, mcp-versus-custom-tools, mcp-revit-koppeling, revit-bronnen. Volledig op twee bewuste omissies na (§3.1). |

**Omgekeerde controle:** geen bestand in `raw/` dat buiten `memory.md` valt.
`README.md` overgeslagen zoals voorgeschreven.

Detail bij de laatste rij: de eerder als "niet bekeken" gemarkeerde BIM Pure /
Claude Code-regel in `revit-bronnen-en-communities.md` is met deze bron ingevuld
en verwijst nu naar `mcp-versus-custom-tools.md`. Daarmee is een openstaande
belofte uit de vorige verwerking gesloten.

---

## Actieplan

Op volgorde van belang. Twee soorten: wat de gebruiker moet doen (een handeling
buiten de kennisbank) en wat Claude in een sessie kan afronden.

1. **[gebruiker] Upload de gecorrigeerde `sci-bim-context` naar claude.ai.** De
   skillbron `Snetselaar_BIM/sci-bim-context/references/template-en-mcp.md` §C is
   al bijgewerkt; pas de upload maakt het effectief. Daarna kan de regel onder
   "Vragen aan de skills" in `index.md` weg en vervalt het conflict in
   `mcp-revit-koppeling.md` §6.
2. **[gebruiker, op de werkplek] Meet de Routes-binding.** Draai op een
   SCI-werkplek `pyrevit config routes` (of lees `pyRevit_config.ini`, sectie
   `[routes]`) en stel vast of er `localhost` of `0.0.0.0` staat. Is het
   `0.0.0.0`: `pyrevit config routes --host localhost` en herladen. Dit is een
   beveiligingspunt, geen fijnregeling.
3. **[gebruiker, op de werkplek] Loop de acht BuiltInParameters na** vanuit een
   omgeving waar `revitapidocs.com` bereikbaar is, met de GUID-truc op 2024 én
   2027 (`rebar-api-parameters.md` §6). Pas daarna mag daar "Geverifieerd" boven.
4. **[Claude, optioneel] Voeg `rebar-api-parameters.md` toe als `verwant:` aan
   `mcp-versus-custom-tools.md`** (en terug), als de versiespanning-link de moeite
   waard is. Klein; alleen doen op verzoek.
5. **[Claude, optioneel] Vul de transport-modes aan** in `mcp-revit-koppeling.md`
   §6 (SSE, streamable-HTTP) als volledigheid ooit nodig is. Nu lage waarde.

`index.md` is bijgewerkt met de drie nieuwe concrete gaten (punten 1–3 van §3).
De wiki-artikelen zijn niet gewijzigd door deze check.

---

## Opvolging (2026-08-28, zelfde dag)

**Actie 1 is afgehandeld.** De gecorrigeerde `sci-bim-context` is naar claude.ai
geüpload en vastgelegd met `skill_uploads.ps1 -Mark sci-bim-context` (sha256
`6513f443…`, commit `aec356d`). De inpak liep via `Snetselaar_BIM/tools/pack_skill.ps1`
(forward-slash-entries geverifieerd). Skill-in-gebruik en wiki lopen niet langer
uiteen. Twee bestanden bijgewerkt: de openstaande vraag in `index.md` en het slot
van `wiki/mcp-revit-koppeling.md` §6, dat nu "Opgelost 2026-08-28" meldt en het
conflictblok als historisch markeert.

**Actie 2 en 3 zijn dezelfde dag alsnog uitgevoerd** (de sessie bleek op de
werkplek te draaien, met Revit 2025 en de Routes-server live).

- **Actie 2 — Routes-binding.** Live gemeten op `0.0.0.0:48884` (kwetsbaar
  bevestigd). Gecorrigeerd naar `host = 127.0.0.1` onder `[routes]`. De
  tutorial-opdracht `pyrevit config routes --host` bleek niet te bestaan in deze
  pyRevit; gebruikt is `pyrevit configs "routes:host" 127.0.0.1`. Na een
  Revit-herstart (de pyRevit-reload liep vast) bindt de socket op
  `127.0.0.1:48884` en werkt `/status/` — geverifieerd, dus afgerond.
- **Actie 3 — BuiltInParameters.** Alle acht getoetst met `Enum.IsDefined` op de
  live Revit 2025-API. Alle acht bestaan; `REBAR_SHAPE_IMAGE` is tóch een
  BuiltInParameter (twee wiki-artikelen gecorrigeerd). Semantiek en een
  2024/2027-spotcheck blijven open.

Alle drie de acties van deze health check zijn daarmee afgerond. Wat resteert is
achtergrondwerk zonder deadline: de semantiek van drie BuiltInParameters en een
2024/2027-spotcheck (actie 3), en de pyRevit 6.5.3-versievraag.
