---
type: uitvoeringsverslag
datum: 2026-10-07
onderwerp: Opvolging logging-audit — fixes, publicatie en administratie
status: uitgevoerd en gepubliceerd; Revit-test open
vervolg-op: 2026-10-07-lint-audit-api-en-logging.md
---

# Opvolging logging-audit — 2026-10-07

Vervolg op [de audit van vandaag](2026-10-07-lint-audit-api-en-logging.md).
De vier open beslissingen daaruit zijn op opdracht van Albert uitgevoerd.
**Niets hiervan is in Revit getest.** Controle was statisch: IronPython
2.7.12-compilatie, `check_versies.py` (0 HARD) en een tokenvergelijking van oud
tegen nieuw.

## 1. Vals "Vastgelopen" in zes annotatieknoppen

Alles na `start_run(_TOOL_NAME)` staat nu in een `try` met de standaardstaart
(`except SystemExit: raise` / `except Exception: log "Mislukt"; raise`). De
bestaande binnenste handlers loggen zelf en slikken in of eindigen op
`sys.exit`, dus er ontstaat geen dubbele logregel.

| Knop | Versie | Waar |
|---|---|---|
| Framing_Taggen | 1.9 → 1.10 | 02_Beta, gepubliceerd naar de gedeelde map |
| Kolommen_Taggen | 1.10 → 1.11 | 02_Beta, gepubliceerd naar de gedeelde map |
| AutoDim_Balken | 1.2 → 1.3 | 03_R&D, alleen AWO-werkmap |
| AutoDim_StramienBalken | 1.2 → 1.3 | 03_R&D, alleen AWO-werkmap |
| Palen-Stramien | 1.2 → 1.3 | 03_R&D, alleen AWO-werkmap |
| Paal-Paal | 1.2 → 1.3 | 03_R&D, alleen AWO-werkmap |

**Methode, herbruikbaar.** 300 tot 2700 regels per script moesten één niveau
inspringen. Dat ging met `tokenize`: regels die binnen een string over meerdere
regels vallen (XAML, meldingen) springen niet mee in, anders verandert de
stringinhoud. Daarna is gecontroleerd dat de reeks betekenisvolle tokens van
het nieuwe bestand gelijk is aan die van het oude, plus precies `try :` en de
staart. In totaal bleven 450 stringregels ongemoeid.

## 2. Statussen in de rapportage

`STATUS_ALIAS` in `dashboard.py` kent nu ook `Voltooid met fouten` en
`OK (met fouten)` (→ OK) en `stand` (→ Geen actie). `aggregate_logs.py`
gebruikt dezelfde tabel nu ook voor de telling in Totalen. Getest op een kopie
van de echte CSV (4423 regels): Framing_Taggen telt 98 OK-runs, waar dat er eerst
0 waren; 195 `Voltooid`-runs vielen daar buiten de OK-kolom.

**Nieuwe bevinding, open:** het dashboard kent `Vastgelopen` niet als status
en meldt zo'n regel als "onbekende statuswaarde" (nu 1x). Juist de status
waar de loopmarkering voor bestaat, valt daar dus weg. Een volwaardige zesde
status raakt ook de JavaScript-kolommen en de foutenlijst.

## 3. Skill `bimtools-logging`

Bijgewerkt in de repo-bron: statustabel met `Vastgelopen` en de aliassen,
tellingen per logvorm (02_Beta 2 import / 19 inline), een paragraaf
"Loopmarkering — `start_run` en de try horen bij elkaar", en de rapportage.
Daarmee vervalt het conflictblok uit de audit. Zip klaar in
`AWO\Skills\bimtools-logging.zip`; upload door Albert.

## 4. Loopmarkering in de zware 01_SCI-knoppen

Keuze Albert: alleen de elf zware knoppen met een inline toollog, niet de 46
kleine parameterknoppen. Per knop: `run_mark_clear()` in de `finally` van de
inline `log_tool_gebruik`, het runmark-importblok met no-op-terugval, en
`start_run(_TOOL_NAME)` als eerste regel in de bestaande buitenste `try`.
Align_Scopebox had geen `try` en kreeg er een om alles heen. BatchLink logt nu
ook het pad "geen actief document" (`Geen actie`).

| Knop | Versie |
|---|---|
| Align_Scopebox, BatchLink, Copy scopebox from link | 1.0 → 1.1 |
| LinkZichtbaarheid, Bovenkant paal aansluiten | 1.1 → 1.2 |
| Lock_Stramien | 5.8.1 → 5.8.2 |
| Select_OngelockteKolommen | 1.0.0 → 1.0.1 |
| Translatie_X, Translatie_Y | 1.0.5 → 1.0.6 |
| Unlock_Stramien | 2.1.0 → 2.1.1 |
| KolomGaten | 1.3 → 1.4 |

01_SCI-knoppen die een loopmarkering zetten: 9 → **20 van 66**. Vóór de
wijziging waren alle elf byte-gelijk aan de gedeelde map; na publicatie zijn
de hele `01_SCI.tab` en `lib` dat weer.

## Administratie

- `toolboek_historie.csv`: versie en datum op de nieuwste basisregel van de
  dertien gepubliceerde knoppen (bugfix, dus geen tekstwijziging). Tooltips
  geregenereerd met `sync_tooltips.py`, PDF's gebouwd en gepubliceerd naar
  `Extensie\Toolboek`. Backups: `toolboek_historie_backup_voor_logging_audit.csv`
  en `..._voor_loopmarkering_sci.csv`.
- Actielijst: dertien versies bijgewerkt (2 Beta + 11 SCI) plus de vier
  R&D-rijen. Backups `Actielijst lint_backup_20261007_logging_audit.xlsm` en
  `..._loopmarkering_sci.xlsm`. AutoDim detail en Tag Details staan bewust op de
  gepubliceerde versie (1.17/1.15), niet op die van de werkmap (1.22/1.34).
- `versies_overzicht.md`: beide varianten van 01_SCI, 02_Beta en 03_R&D
  opnieuw gegenereerd.

## Nog open

1. **Revit-test.** Bij voorkeur Translatie_X, Lock_Stramien en Framing_Taggen
   één keer draaien en daarna nagaan dat er per run precies één regel in
   `Gebruikslog.csv` staat, en geen achtergebleven `.run` in `_actieve_runs\`.
2. `Vastgelopen` als zesde status in het dashboard.
3. Skill `bimtools-logging` uploaden en vastleggen met
   `skill_uploads.ps1 -Mark bimtools-logging`.
4. Nog openstaande waarschuwingen uit de audit, niet aangepakt: "OK" zonder
   wijziging (Dragend, Niet dragend, IsExternal, IsInternal, Toggle reference
   plane, Staal_Controle), annuleren geboekt als "Afgebroken" (ModelCheck,
   Staal_Controle), ingeslikte fouten zonder traceback (Paal-Paal en de inner
   handlers in Framing/Kolommen_Taggen), en ModelVergelijk `__version__` 1.4
   tegen Versie-regel 1.3.

## Addendum, later dezelfde dag

Op opdracht van Albert ook gepubliceerd naar de gedeelde map:
**AutoDim Detail 1.17 → 1.22** en **Tag Details 1.15 → 1.34**. Toolboek-CSV,
tooltips, PDF's en actielijst zijn bijgewerkt; de actielijst meldt nu "alles
gelijk", en de hele `02_Beta.tab` is byte-gelijk aan de AWO-werkmap. De zin
hierboven dat die twee "bewust op de gepubliceerde versie" staan, is daarmee
achterhaald.

Let op bij de Revit-test: AutoDim Detail 1.22 (wandrijen bij een enkele wand
omgedraaid, 06-10-2026) is nog niet in Revit gedraaid. Op 29-09-2026 liet een
tussenversie (autopilot iter_08) Revit crashen en ging de knop terug naar 1.17;
1.18-1.21 liepen daarna via de annotatie-autopilot in een echt model. Tag
Details 1.16-1.34 zijn per stap door Albert getest. Backups van de vorige
gedeelde versies staan in de sessie-scratchpad (`backup_gedeeld_beta`).
