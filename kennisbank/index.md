# Index

Kaart van `wiki/`. Bijgewerkt door `/kb-verwerk` en `/kb-check`.

**Stand:** 1 artikel, 2026-08-25. Laatste health check: [2026-08-25](outputs/2026-08-25-healthcheck.md).

---

## MCP en gereedschap

| Artikel | Status | Bijgewerkt | Waarover |
|---|---|---|---|
| [mcp-revit-koppeling.md](wiki/mcp-revit-koppeling.md) | concept | 2026-08-25 | De keten Claude → MCP → pyRevit Routes → Revit API: opbouw, tools, endpoints en faalpunten |

## Revit API en versies

_Nog leeg. Gedekt door de skills `revit-api-docs` en `pyrevit-codestijl`;
hier komt alleen wat die niet dekken._

## SCI-conventies en projecten

_Nog leeg. Gedekt door de skill `sci-bim-context`._

## Scripts en het SCI-lint

_Nog leeg. Gedekt door de skills `bimtools-promotie`, `bimtools-logging` en
`bimtools-actielijst`._

---

## Open vragen en gaten

Gevuld door `/kb-check`. Elk punt is een kandidaat voor een `/kb-vraag` of voor
een dump in `raw/`.

- **De kennisbank is leeg op één artikel na.** Tot er materiaal in `raw/` komt,
  kan `/kb-verwerk` niets doen. Eerste zinvolle dumps: openstaande tracebacks,
  aantekeningen van overleggen over het lint, artikelen over Revit 2027.
- **Geen enkel artikel over het echte SCI-werk.** Het enige artikel gaat over
  deze repo. De kennis over modellen, scripts en conventies zit nu volledig in
  de skills en nergens in de wiki.
- **`W:` is niet bereikbaar vanuit cloudsessies.** De extensies, `Actielijst
  lint.xlsm` en de logbestanden staan op de netwerkschijf. Wat daar staat kan
  alleen vanuit een lokale sessie in `raw/` terechtkomen. Onopgelost.
- **Welke Revit-MCP-server wordt er nu echt gebruikt?** De skill
  `sci-bim-context` (`references/template-en-mcp.md` §C) noemt zeven tools die
  geen van alle in deze repo bestaan. Zie `wiki/mcp-revit-koppeling.md` §6.
  Uitzoeken voordat een van beide bronnen wordt aangepast.
- **`use_transaction` in `execute_revit_code` doet niets.** Het veld staat wel in
  de docstring maar wordt nergens uitgelezen; er is geen automatische transactie.
  Zie `wiki/mcp-revit-koppeling.md` §4. Kandidaat voor een issue of PR bij
  upstream.
- **Blijft de Routes Server aan tussen Revit-sessies?** De README spreekt zichzelf
  bijna tegen: handmatig activeren onder Settings, maar "loads automatically
  whenever you start Revit". Eén keer nameten in Revit lost dit op.
- **Geen enkel `verwant:`-verband gelegd.** Met één artikel kan het niet, maar de
  kruisverwijzing — waar de waarde vandaan moet komen — is nog onbewezen.
