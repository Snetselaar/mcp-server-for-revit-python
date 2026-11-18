# SCI-Viewer PDF-deel gelijk aan Revu 21: 3.80–3.84 (17/18-11-2026)

Aanleiding: de gebruiker vroeg dat de PDF-tooling "echt moet lijken op Bluebeam". De vergelijking per tool met de Revu 21-handleiding staat in `2026-11-17-revu-tooling-vs-sci-viewer-3.79.md`.

Werkwijze: per ronde één of twee agents, met een testbrowser en een eigen tab per agent. De hoofdsessie stapelde de patches en controleerde daarna zelf in de browser. Opdrachten en verslagen staan in de scratchpad (`r380` t/m `r384`).

## Gebouwd
| Versie | Repo-commit | Inhoud |
|---|---|---|
| 3.80 | `797875d` | Zijgrepen; draaigreep (15°, Shift = 1°; Square/Circle bij een vrije hoek worden een Polygon met 4 of 64 punten); los tekstvak bij bijschrift en Cloud+; vergrendelen (/F 132, Ctrl+Shift+L); Als standaard instellen |
| 3.81 | `10d1f6c` | Sneltoetsen gelijk aan Revu; selectiekader links/rechts; Ctrl+slepen kopieert; Ctrl+Shift+V; Esc rondt af; Alt+Z; Bijschrift en Polygon als basistool; Shift/Alt bij tekenen; wolk als veelhoek met boogmaat en omkeren; markeerstift als Ink; pen-bundeling; groeperen, uitlijnen, verdelen, spiegelen en volgorde; punten toevoegen of weghalen; maatlabel los slepen; omtrek open |
| 3.82 | `9dbf443` | Notitie, Typewriter, Boog, Maatlijn, Gum, Hyperlink, Afbeelding uit bestand; opmaak per woord (/RC-spans); Format Painter; schaal over meerdere bladen; Toepassen op bladen |
| 3.83 | `25639ae` | Schaal als /VP met /Measure /RL zoals Revu; audit 3.80–3.82 (6 van 14 gerepareerd) |
| 3.84 | `20469f7` | De overige 8 auditpunten: groepen met afbeelding/link/notitie, schaal wissen uit /VP, ongedaan maken inclusief schaal, benoemde Revu-viewport ongemoeid |

## Lessen
- **Sneltoetsen:** de echte lijst staat lokaal in `%APPDATA%\Bluebeam Software\Revu\21\KeyboardShortcuts.xml`.
  - 254 toetsen; `<Keys>` is de .NET Keys-enum met Shift 65536, Ctrl 131072, Alt 262144.
  - Het teamprofiel `Snetselaar.bpx` bevat geen sneltoetsen. De gebruiker heeft niets aangepast, dus het team heeft de standaardlijst.
  - Waar de lijst en de handleiding verschillen: volgorde gaat met Ctrl+] / Ctrl+[ (niet Ctrl+J), en M opent de meettool.
- **Draaien:** de handleiding zegt op bijna elke pagina "15°, Shift = 1°". Alleen de Callout-pagina zegt "1°, Ctrl = 15°"; die is waarschijnlijk fout.
- **Gegroepeerde tekst:** pdf.js geeft een FreeText in een groep (/IRT /RT /Group) de /Contents van de groepsleider. Een link mag daarom nooit de leider van een groep zijn: pdf.js leest de /IRT van een link niet.
- **/VP:**
  - Revu schrijft `/Type /Viewport /BBox = MediaBox /Measure /NM`, zonder /Name.
  - /Measure /RL met /R "1 mm = n mm", /X C = n × 25,4/72, /D /A /T /V en /TargetUnitConversion 0.3527778.
  - Een benoemde viewport is een detail en moet ongemoeid blijven.
- **Gedeelde bron:** andere sessies passen dezelfde viewer aan. Vergelijk daarom vóór elke uitrol de NAS-versie met de eigen vorige uitrol (memory `sci-viewer-nas-eerst-vergelijken`).

## Open (in Revu na te kijken)
- Of Revu de door de viewer geschreven /VP als paginaschaal toont.
- Of een notitie en een link in een groep in Revu goed werken.
- De opslagvorm van een boog (`/PolyLine /IT /PolyLineArc`, eigen keuze) en van een omgekeerde wolk (eigen sleutel `/SCIWolkInv`). Hiervoor is een voorbeeld-PDF uit Revu nodig.
- Of Ctrl+Shift+C (Format Painter) in Edge botst met de DevTools-sneltoets.
