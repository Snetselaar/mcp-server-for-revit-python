# Claude-accountmigratie: back-up en herstel

Hoort bij het doc *Stappenplan overstap naar Claude Team* (claude.ai, 10-11-2026).

| Moment | Doe |
|---|---|
| Vóór de overstap | dubbelklik `Backup.cmd` → map in `OneDrive - Snetselaar…\Claude-backup\<datum>` |
| Na de overstap, na `/login` op Team | dubbelklik `Herstel.cmd` → zet terug wat ontbreekt en geeft een controletabel |

`Herstel.cmd -Overschrijf` vervangt ook bestaande bestanden (eerst een kopie
`*.voor-herstel`). Zonder die vlag wordt alleen aangevuld wat er niet is.

**Wat gaat mee in de back-up:** Claude Code-memory (alle projecten), plannen,
settings, plugin-marketplaces, `settings.local.json` van de repo's, Claude
Desktop-config (MCP fetch + Nonica Revit), de 7 eigen skills als upload-klare
zip, INVENTARIS.md, manifest.json met SHA-256.

**Wat bewust niet meegaat:** `.claude.json` en de inlog-tokens. Die horen bij het
oude account; terugzetten zou de nieuwe login in de war sturen.

**Wat geen script kan:** de claude.ai-export, Claude Docs exporteren, skills
uploaden, app-koppelingen opnieuw koppelen. Het herstelscript opent de zipmap en
de skillspagina, zodat het uploaden alleen nog klikken is.

Code, kennisbank en skills zelf staan in git (`mcp-server-for-revit-python`,
`Snetselaar_BIM`). Die zijn pas veilig als alles gecommit en gepusht is; de
back-up waarschuwt als dat niet zo is.
