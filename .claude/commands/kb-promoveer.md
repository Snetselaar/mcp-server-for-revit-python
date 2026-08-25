---
description: Maakt van een stabiel wiki-artikel een kant-en-klare skill-tekst om in claude.ai te plakken
argument-hint: "<artikelnaam in kennisbank/wiki/>"
---

Promoveer dit wiki-artikel: $ARGUMENTS

## Vooraf

Lees `kennisbank/CLAUDE.md` §3 en §4 (verhouding tot de skills en het
promotiepad) en het genoemde artikel. Geen argument meegegeven? Loop `wiki/` en
`index.md` langs, noem de artikelen die aan de criteria voldoen en vraag welke.

## Stap 1 — poortwachter

Toets het artikel aan de vijf criteria uit `CLAUDE.md` §4:

1. `status: stabiel`;
2. minstens twee onafhankelijke bronnen, of één bron die geverifieerd is tegen
   het echte model of de API-documentatie;
3. geen `[ONBEVESTIGD]`-markeringen meer;
4. het onderwerp is minstens tweemaal opgekomen — controleer dat in `memory.md`
   en `outputs/`;
5. geen bestaande skill dekt het al.

Faalt er een criterium, **stop dan**. Zeg welk criterium, wat eraan mankeert en
wat er nodig is om het wel te halen. Promoveer niet "toch maar even". Dit is
dezelfde poortwachtersgedachte als de fase-eisen in de skill
`bimtools-promotie`: een knop die de testmatrix niet haalt gaat niet naar
`02_Beta`.

## Stap 2 — kies de vorm

Twee mogelijkheden:

- **Nieuwe skill** — het onderwerp is eigenstandig, heeft eigen triggers en valt
  buiten het domein van de bestaande skills.
- **Toevoeging aan een `references/`-bestand van een bestaande skill** — het
  onderwerp hoort bij een domein dat al gedekt is. Meestal is dít het juiste
  antwoord; `sci-bim-context` heeft al `template-en-mcp.md`,
  `scripts-en-skills.md` en `technische-issues.md`.

Motiveer de keuze in één alinea voordat je schrijft.

## Stap 3 — schrijf de tekst

**Bij een nieuwe skill:** volledige SKILL.md met YAML-frontmatter (`name`,
`description`). De `description` bepaalt of de skill überhaupt triggert, dus:
in het Nederlands, met concrete voorbeeldvragen die een gebruiker echt zou
stellen, plus expliciet wat de skill níet doet en naar welke skill je dan moet.
Kijk hoe `sci-bim-context` en `pyrevit-codestijl` dat doen en volg dat patroon.

**Bij een toevoeging:** lever het exacte blok tekst plus waar het in het
bestaande bestand moet, en welke regel in de SKILL.md-index eventueel mee moet
veranderen.

Schrijf volgens `stijlgids.md`. Een skill is compacter dan een wiki-artikel:
haal de redenering en de bronvermeldingen eruit en houd de conclusies over. De
bronnen blijven in het wiki-artikel staan, dat is het punt van de bronketen.

## Stap 4 — leveren, niet installeren

**De skills staan in `~/.claude/skills/synced/` en worden gesynct vanaf
claude.ai. Wijzig ze niet op schijf — dat overleeft de volgende sync niet.**

Lever de tekst in de chat in een codeblok, klaar om te plakken, met erbij:
- waar het heen moet (nieuwe skill met welke naam, of welk bestand en welke plek);
- wat er in claude.ai moet gebeuren.

## Stap 5 — het artikel bijwerken

Na bevestiging van de gebruiker dat de skill is aangemaakt of bijgewerkt:

- `status: gepromoveerd`, `laatst-bijgewerkt:` op vandaag, `skill:` invullen;
- de inhoud inkorten tot de kern plus een verwijzing naar de skill;
- **de bronnen laten staan.** Het artikel is de bronketen onder de skill; die
  weggooien maakt de skill oncontroleerbaar;
- `index.md` en `memory.md` bijwerken.
