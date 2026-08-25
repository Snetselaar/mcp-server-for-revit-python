# Kennisbank — schema en spelregels

Dit bestand vertelt hoe de kennisbank gelezen en geschreven wordt. Lees het
volledig voordat je iets in `wiki/`, `index.md` of `memory.md` schrijft.

**Werktaal: Nederlands.** Ook de wiki-artikelen en de outputs.

---

## 1. Doel en bereik

De kennisbank verzamelt en verdicht kennis over het **Revit-, BIM- en
SCI-automatiseringswerk bij Snetselaar**. Hij bestaat om drie redenen:

1. Kennis die nu in een sessie ontstaat verdwijnt met die sessie.
2. Er is geen plek waar losse notities, tracebacks en artikelen binnenkomen.
3. Niets bewaakt of de vastgelegde kennis nog klopt.

**Wel in scope:** pyRevit-scripts en het SCI-lint, Revit API en versieverschillen
2024–2027, NLRS/SCI-conventies, de SCI-template, IFC-/DWG-export, de
MCP-Revit-koppeling, projectmodellen en wat daarin is waargenomen, opgeloste
technische problemen, werkafspraken met het team.

**Niet in scope:** alles wat niets met dit werk te maken heeft. Geen algemene
artikelen, geen persoonlijke notities, geen onderwerpen buiten Revit/BIM.
Een kennisbank die overal over gaat wordt over niets goed.

---

## 2. De mappen en wie erin schrijft

| Map | Wie schrijft | Regel |
|---|---|---|
| `raw/` | **de gebruiker** | Dumpmap. Mag rommelig. Nooit opschonen, hernoemen of verwijderen — ook niet na verwerking. |
| `wiki/` | **alleen Claude** | Nooit handmatig bewerken. Wil de gebruiker iets gewijzigd hebben, dan gaat dat via een opdracht of via een nieuw bestand in `raw/`. |
| `outputs/` | **alleen Claude** | Antwoorden, briefings, rapporten, health checks. Gedateerd. Wordt niet overschreven. |

`index.md` en `memory.md` staan in de wortel van `kennisbank/` en worden
uitsluitend door Claude bijgewerkt.

`raw/` is bewust append-only. Het bronbestand is het bewijs onder een
wiki-claim; verdwijnt het bestand, dan is de bronvermelding waardeloos.

---

## 3. Verhouding tot de SCI-skills — lees dit vóór je iets schrijft

Er bestaan tien handgeschreven SCI-skills die **automatisch triggeren** en die
de bron van waarheid zijn:

| Skill | Domein |
|---|---|
| `sci-bim-context` | werkafspraken, NLRS/SCI-naamgeving, categorie-conventies, huisregels detailtekeningen, referentieprojecten, bestaande scripts |
| `pyrevit-codestijl` | IronPython 2.7-codestijl, scriptskelet, transacties, WPF, breaking changes 2024→2027 |
| `revit-api-docs` | het opzóéken van API-signaturen in plaats van reproduceren uit geheugen |
| `bimtools-promotie` | promotiepijplijn 03_R&D → 02_Beta → 01_SCI, fase-eisen, testmatrix |
| `bimtools-logging` | de vier logstromen van het SCI-lint |
| `bimtools-actielijst` | `Actielijst lint.xlsm` bijwerken |
| `update-github-bimtools` | W:-extensies spiegelen naar de repo `Snetselaar_BIM` |

**Regels:**

1. **Skills gaan voor.** Valt een vraag binnen het domein van een skill, gebruik
   dan de skill. De wiki is er voor wat de skills niet dekken.
2. **De wiki spreekt een skill nooit tegen.** Kom je bij het schrijven van een
   wiki-artikel iets tegen dat in strijd is met een skill, schrijf dan niet
   stilzwijgend de wiki-versie op. Twee opties: (a) de skill klopt → volg de
   skill; (b) je hebt een nieuwere geverifieerde bron → schrijf het artikel mét
   een expliciet blok `> **Conflict met skill `naam`:** …` en meld het in je
   antwoord. Nooit stil overschrijven.
3. **Skills zijn hier niet bewerkbaar.** Ze staan in `~/.claude/skills/synced/`
   en worden gesynct vanaf claude.ai. Wijzigen doe je via claude.ai, niet op
   schijf. Promotie levert dus tekst op om te plakken, geen bestandsedit.

---

## 4. Promotiepad — hoe kennis rijpt

Hetzelfde denken als `03_R&D → 02_Beta → 01_SCI`:

```
raw/  →  wiki/ (concept)  →  wiki/ (stabiel)  →  skill of references/-bestand
```

Een artikel is **kandidaat voor promotie** als het aan alles voldoet:

- `status: stabiel`;
- minstens twee onafhankelijke bronnen, of één bron die geverifieerd is tegen
  het echte model of de echte API-documentatie;
- geen `[ONBEVESTIGD]`-markeringen meer;
- het onderwerp is minstens tweemaal opgekomen (blijkt uit `memory.md` of
  `outputs/`);
- er is geen skill die het al dekt.

Promoveren gaat met `/kb-promoveer`. Na promotie krijgt het artikel
`status: gepromoveerd` plus een verwijzing naar de skill, en wordt de inhoud
ingekort tot een verwijzing — niet verwijderd, want dan verdwijnt de
bronketen.

---

## 5. Vorm van een wiki-artikel

Elk bestand in `wiki/` begint met frontmatter:

```yaml
---
titel: Korte beschrijvende titel
status: concept | stabiel | gepromoveerd
laatst-bijgewerkt: JJJJ-MM-DD
bronnen:
  - raw/2026-08-25-traceback-autodim.md
  - https://www.revitapidocs.com/...
  - "waargenomen in model S-8985, view TO-121"
verwant:
  - ander-artikel.md
skill: sci-bim-context     # alleen als het onderwerp een skill raakt
---
```

Bestandsnaam: kleine letters, koppeltekens, beschrijvend en stabiel
(`ifc-export-configuraties.md`, niet `notities-3.md`). Hernoem niet zonder
`verwant:`-verwijzingen elders bij te werken.

**Eén artikel = één onderwerp.** Loopt een artikel over de 200 regels of
behandelt het twee dingen, splits het en leg een `verwant:`-link.

---

## 6. Bronvermelding — de belangrijkste regel

**Elke feitelijke claim krijgt een bron.** Een bron is een bestand in `raw/`,
een URL, een verwijzing naar code in deze repo met regelnummer, of een
waarneming in een echt model (`"waargenomen in model S-8985"`).

Kun je een claim niet onderbouwen maar is hij wel relevant, schrijf hem dan op
mét de markering:

```
[ONBEVESTIGD] De join-volgorde beïnvloedt mogelijk de wapeningsweergave.
```

Niet weglaten en niet gladstrijken tot iets dat zeker klinkt. Dit sluit aan op
de SCI-werkafspraak "onderbouwd vóór presenteren" en op de eis uit
`revit-api-docs` dat een API-signatuur pas geverifieerd heet als hij is
opgezocht.

Voor Revit API-claims geldt de strengere regel uit `revit-api-docs`: opzoeken,
niet reproduceren uit geheugen.

---

## 7. Verwerkingsprotocol

Bij het verwerken van `raw/` (het `/kb-verwerk`-command):

1. Lees `memory.md` — wat is al verwerkt?
2. Lees de nog niet verwerkte bestanden in `raw/`.
3. Schrijf of werk bij in `wiki/`. Voeg bij voorkeur toe aan een bestaand
   artikel in plaats van een nieuw te beginnen.
4. **Leg verbanden.** Zoek actief naar raakvlakken met bestaande artikelen en
   leg ze vast in `verwant:` én in de tekst. Dit is waar de kennisbank zijn
   waarde vandaan haalt; een stapel losse artikelen is een map, geen kennisbank.
5. Werk `index.md` bij.
6. Log in `memory.md`: datum, bron, geraakte artikelen, één zin toelichting.
7. Laat het bestand in `raw/` staan.

Schrijf volgens `stijlgids.md`. Die regels zijn toetsbaar en worden door
`/kb-check` gecontroleerd.

---

## 8. Commands

| Command | Doet |
|---|---|
| `/kb-verwerk` | verwerkt `raw/` naar `wiki/`, werkt index en memory bij |
| `/kb-vraag` | beantwoordt een vraag, schrijft het antwoord naar `outputs/` |
| `/kb-check` | maandelijkse audit op tegenstrijdigheden, bronnen, gaten, veroudering, stijl |
| `/kb-promoveer` | maakt van een stabiel artikel een skill-tekst om te plakken |

## 9. De herinnering

Bij het starten van een sessie in deze repo draait `kennisbank/tools/raw-status.sh`
als SessionStart-hook (geconfigureerd in `.claude/settings.json`). Hij meldt:

- hoeveel bestanden in `raw/` nog niet in `memory.md` staan;
- of de laatste health check meer dan 30 dagen geleden is.

Is er niets te melden, dan zwijgt hij. Faalt hij, dan zwijgt hij ook — een hook
die een sessie blokkeert is erger dan een hook die niets doet.

Hij bepaalt "verwerkt" door te kijken of de bestandsnaam letterlijk in
`memory.md` voorkomt. Noem het bronbestand in de logregel dus altijd bij naam,
anders blijft het eeuwig als onverwerkt gemeld.
