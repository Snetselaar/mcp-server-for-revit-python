---
type: audit
datum: 2026-10-07
onderwerp: Lintbrede audit van API-compatibiliteit (2024-2027) en logging
status: API schoon; logging 6 fouten, 17 waarschuwingen, niets gewijzigd
---

# Lintbrede audit: API 2024-2027 en logging — 2026-10-07

Twee audits over de live W:-map (`W:\4 - Tijdelijk en verwijderen\AWO\Extensions`),
01_SCI, 02_Beta en 03_R&D, beide als workflow met agents. De API-audit liep op
2026-10-06, de logging-audit is op 2026-10-07 afgerond. **Aan de scripts is niets
gewijzigd.**

## Methode, voor herhaling

Beide audits volgden hetzelfde patroon:

1. **Deterministisch voorwerk:** wat te tellen is, telt een script en niet een
   agent. Daarmee ontstaat de werklijst.
2. **Beoordelen per batch:** één agent per batch knoppen geeft per treffer een
   oordeel, met regelnummer.
3. **Skeptisch verifiëren:** een tweede agent probeert elke fout en waarschuwing
   te weerleggen door de code zelf te lezen. Alleen wat overeind blijft telt.

Scope is in beide gevallen de IronPython-scope van het lint: alles onder een
`.tab`, `lib` of `hooks` plus `startup.py`, zonder `.old`-bundels, zonder
`tools`/`mcp_lezen`/`annotatie_autopilot` en zonder submappen van een knop die
een los CPython-proces zijn (Plot > Set bijwerken). Dat is dezelfde regel die
`check_versies.py` sinds 2026-10-06 hanteert.

## Deel 1 — API 2024-2027: schoon

- `RnD.extension\tools\api_diff.ps1` (nieuw) dumpt alle publieke leden van
  RevitAPI/RevitAPIUI per versie. Uit 2024 verdwijnen tot en met 2027
  **892 namen en 41 overloads**; daarnaast 188 leden die in 2025/2026 bijkwamen
  en weer verdwenen.
- Gekruist met de 135 actieve scripts bleven alleen `.IntegerValue` en
  `ElementId(<var>)` over als echt risico. De rest is ruis: generieke namen
  (`Name`, `X`, `Create`, `Evaluate`, `Volume`) die alleen op obscure MEP- of
  analytische typen verdwenen.
- 4 agents beoordeelden alle 143 treffers in 88 bestanden: 74 commentaar,
  66 afgeschermd (`eid_value`-helper met `.Value` eerst, of een `Int64`-cast),
  3 WorksetId. **Nul echte risico's.**
- Bijvangst, opgelost: `check_versies.py` gaf 258 HARD-meldingen, waarvan 252 uit
  de meegeleverde pypdf en 3 vals alarm op WorksetId. Na de scopefix: 0 HARD,
  exitcode 0. Sindsdien draait hij als pre-commit-hook in `Snetselaar_BIM`
  (commit `91df0db`), samen met IronPython 2.7-compilatie.
- Valkuil voor nieuwe code: `Curve.Intersect(Curve)` en
  `Curve.Intersect(Curve, IntersectionResultArray&)` bestaan niet meer in 2027.
  Het lint gebruikt ze niet.

## Deel 2 — logging: 112 knoppen

### Deterministisch vastgesteld

| Punt | Stand |
|---|---|
| `_TOOL_NAME` uniek over het hele lint | ✓ alle 112 |
| `TOOLLOG_PATH` gelijk in alle 57 inline-kopieën | ✓ |
| `toollog.py` (f32a86bc), `runmark.py`, `plaatsingslog.py` gelijk in alle libs | ✓ |
| Annotatieknoppen in `ANNOTATIE_TOOLS` roepen `start_run` aan | ✓ |
| Vorm per extensie | 01_SCI 53 import / 13 inline · 02_Beta 2 import / 19 inline · 03_R&D 25 inline |
| `start_run` | 01_SCI 9/66 · 02_Beta 20/21 (niet AutoSave, bewust) · 03_R&D 23/25 (niet ElementNotities, Lees_MCP) |
| Opslaancheck in 02_Beta | 19/21 (niet AutoSave en Projectmap, bewust) |
| ModelVergelijk: `__version__ = "1.4"`, Versie-regel `1.3` | ✗ |

> **Conflict met skill `bimtools-logging`:** de skill noemt voor 02_Beta "3"
> scripts met vorm A (import). Gemeten op 2026-10-07: 2 import, 19 inline.
> De Beta-knoppen zijn uit 03_R&D gepromoveerd en hebben hun inline kopie
> meegenomen. Werkt prima, maar de skill klopt hier niet meer.

**Dekkingsgat in 01_SCI.** De gedeelde `toollog.py` roept sinds 2026-09-11
`run_mark_clear()` aan, maar alleen `start_run()` zet een markering neer. Die
roepen 9 van de 66 SCI-knoppen aan (Plot, Tag As-Aanzichten, Toolboek en de zes
stramienbolknoppen). Bij de overige 57 blijft een harde Revit-crash onzichtbaar
in het gebruikslog. Dat is geen fout, maar het is minder dekking dan de notitie
van 2026-09-11 deed vermoeden.

### Uitkomst na verificatie

31 bevindingen staan overeind (6 fout, 17 waarschuwing, 8 info), 2 zijn
weerlegd. De agents gaven daarnaast 25 info-meldingen die niet door de
verificatie gingen.

**De 6 fouten** zijn één patroon in annotatieknoppen: Framing_Taggen,
Kolommen_Taggen (02_Beta), AutoDim_Balken, AutoDim_StramienBalken,
Palen-Stramien en Paal-Paal (03_R&D). Ze roepen `start_run` aan, maar een groot
deel van het werk staat op moduleniveau buiten elke `try`. Een onverwachte
exception daar logt niets. De markering blijft staan en verschijnt 12 uur later
als vals "Vastgelopen". Bij Framing_Taggen kan dat ook na een geslaagde commit.
Zelf nagelezen in Paal-Paal: `start_run` op r.176, de `try` begint pas op r.497.

**De 17 waarschuwingen**, in vier soorten:

- **"OK" zonder dat er iets gebeurde:** Dragend, Niet dragend, IsExternal en
  IsInternal negeren de returnwaarde van `structural_toggle`. Toggle reference
  plane toont "Mislukt" en logt "OK". Staal_Controle logt een lege run als OK.
- **Annuleren geboekt als "Afgebroken":** ModelCheck en Staal_Controle.
- **Fout ingeslikt** (geen `raise`, dus geen traceback): Align_Scopebox, Paal-Paal.
- **Statussen die de telling missen:** "Voltooid" (Framing_Taggen,
  Kolommen_Taggen) en "OK (met fouten)" (Copy scopebox from link, ModelExport).
  `dashboard.py` heeft een alias voor "Voltooid", maar niet voor
  "Voltooid met fouten", "OK (met fouten)" en "stand". `aggregate_logs.py`
  telt alleen de exacte standaardstrings; daar vallen ze alle vijf uit de
  OK-kolom.

## Open beslissingen

1. **De 6 fouten oplossen.** De vier R&D-knoppen kunnen direct in 03_R&D.
   Framing_Taggen en Kolommen_Taggen staan in 02_Beta en in de gedeelde map;
   die volgen de promotieroute.
2. **Statussen:** in de knoppen gelijktrekken naar "OK", of de aliassen
   aanvullen in `dashboard.py` en `aggregate_logs.py`.
3. **Dekking in 01_SCI:** `start_run` toevoegen aan de 57 SCI-knoppen is
   functionaliteit in Alberts spiegel; dat begint volgens de afspraak in 03_R&D
   of op zijn verzoek.
4. **Skill `bimtools-logging`** bijwerken op de Beta-telling.

## Bevindingen met regelnummers

Gegenereerd uit het workflowresultaat; regelnummers gelden voor de stand van
2026-10-07.

### Fout (6)

| Knop | Batch | Regel | Crit. | Kern |
|---|---|---|---|---|
| Framing_Taggen | 02_Beta | 1364 | K1 | grep '^try' geeft op module-niveau alleen r309 (runmark-import), r329 (opslaancheck-import) en r2688 (transactie). Er staat geen def main en geen overkoepelende try. start_run(_TOOL_NAME) draait op r325. Van r1364 tot r2686 (view-checks, collectors, … |
| Kolommen_Taggen | 02_Beta | 1658 | K1 | De try's op module-niveau zijn r289 en r309 (imports), daarnaast alleen kleine lokale try's (r1681, r1687, r1703, r1972, r1979, r2279), die elk één property afvangen, plus de transactie-try op r2289. start_run staat op r305. De gecontroleerde exits … |
| AutoDim_Balken | 03_R&D-a | 391 | K1 | Gelezen: r.128-200 (inline log_tool_gebruik met run_mark_clear in finally, runmark-fallback, start_run r.201), r.391-611 en r.600-762. Na start_run draait r.391-611 op moduleniveau buiten elke try: collectors, collect_beams r.547-572 (c.Evaluate, … |
| AutoDim_StramienBalken | 03_R&D-a | 348 | K1 | start_run r.185. Op moduleniveau staan r.348-656 buiten een try: view/thin lines, de grid-collector r.509, collect_beams/linkfallback r.533-584, crop_vakken_van r.476 en t.Start() r.656. De try begint pas op r.660. Except r.827-830 doet RollBack en logt … |
| Palen-Stramien | 03_R&D-a | 304 | K1 | start_run r.174. r.304-504 staan buiten een try: de view-check, crop_vakken_van r.423, de linkscan met GetLinkDocument en een collector op het linkdocument r.467-477, collect_piles r.479-489, grids r.493 en t.Start() r.504. De try begint op r.508. Except … |
| Paal-Paal | 03_R&D-b | 287 | K1 | Bevestigd. Na start_run (r.176) staat alles op moduleniveau zonder try tot r.497: view.ViewType (r.288), de Thin Lines-collector (r.296-299), crop_vakken_van(view) (r.407; r.344-362 lezen CropBox buiten de interne try), de link-/palencollectors … |

### Waarschuwing (17)

| Knop | Batch | Regel | Crit. | Kern |
|---|---|---|---|---|
| Dragend | 01_SCI-klein | 27 | K2 | script.py r.26-36: try roept set_parameter_op_selectie("LoadBearing", True, ...) aan zonder de returnwaarde te gebruiken; de else-tak r.36 logt altijd "OK". lib/structural_toggle.py r.67-70 (lege selectie) en r.76-83 (geen ligger/kolom) doen forms.alert … |
| IsExternal | 01_SCI-klein | 28 | K2 | script.py r.27-37: set_parameter_op_selectie("IsExternal", True, ...) in de try, returnwaarde niet gebruikt, else-tak r.37 logt "OK". In structural_toggle.py staat return False na een alert zonder exitscript (r.67-70, r.76-83), plus False bij gelukt == 0 … |
| IsInternal | 01_SCI-klein | 28 | K2 | script.py r.27-37 is identiek aan IsExternal (waarde False). De vroege return False uit structural_toggle.py r.67-70/r.76-83 gooit geen SystemExit, want forms.alert wordt zonder exitscript aangeroepen, en komt dus in de else-tak r.37 terecht, die "OK" … |
| Niet dragend | 01_SCI-klein | 27 | K2 | script.py r.26-36 is identiek aan Dragend (waarde False): de returnwaarde van set_parameter_op_selectie wordt genegeerd. De vroege uitgangen met return False in structural_toggle.py r.67-70 en r.76-83 hebben een alert zonder exitscript, dus er is geen … |
| Toggle reference plane (active view) | 01_SCI-klein | 41 | K2 | script.py r.34-42: de binnenste try zoekt het filter 'SCI_reference_planes'. Ontbreekt dat, dan geeft filter(...)[0] een IndexError, die de kale except op r.41 opvangt. Die toont TaskDialog.Show("Mislukt", ...) en gooit niet door. Daarna volgen t.Commit() … |
| Align_Scopebox | 01_SCI-zwaar | 120 | K1 | Gelezen r. 118-231 en grep op exit-paden. Na _tool_t0 (r. 120) staat het hele werk op moduleniveau zonder try. De vijf vroege uitgangen (r. 124-127, 143-151, 181-184, 214-217) loggen elk precies één keer vóór sys.exit(), en er is geen except SystemExit die … |
| Copy scopebox from link | 01_SCI-zwaar | 311 | K3 | Op r. 310-314 staat: status 'OK' if not total_errors else 'OK (met fouten)'. total_errors wordt opgehoogd in de except per link/kopie (r. 288-292). Getoetst tegen de aggregatiecode in Snetselaar_BIM/Logging, de repospiegel van 10-09-2026. aggregate_logs.py … |
| Framing_Taggen | 02_Beta | 2997 | K3 | r2996-2998: log_tool_gebruik(_TOOL_NAME, 'Voltooid' if not mislukt else 'Voltooid met fouten', ...). 'Voltooid' komt in het hele script alleen op r2997 voor, zonder commentaar dat het bewust is. Een recursieve grep over alle .py onder Extensions vindt … |
| Kolommen_Taggen | 02_Beta | 2624 | K3 | r2623-2626: dezelfde 'Voltooid'/'Voltooid met fouten'-constructie zonder commentaar, nergens anders in het script en in geen andere tool of lib. Elke geslaagde run valt zo buiten de OK-telling. Een lege run wordt wel al vóór de transactie als 'Geen actie' … |
| ModelCheck | 03_R&D-a | 1298 | K2 | toon_dialoog r.1081 geeft (None, None) bij Annuleren (r.1134-1135). main r.1296-1302 doet dan raise SystemExit('geannuleerd via dialoog'), en bij een lege set raise SystemExit('geen groepen geselecteerd'). Het entrypoint r.1340-1349 vangt except SystemExit … |
| ModelCheck | 03_R&D-a | 91 | K2 | r.67-91: de import van sci_classificatie valt bij falen terug op het sys.path naar lib\. Lukt dat ook niet, dan volgen forms.alert en raise SystemExit op r.91, op moduleniveau. _tool_t0/start_run staan pas op r.575-577 en het try-entrypoint op r.1340. Er … |
| ModelExport | 03_R&D-a | 679 | K3 | r.678-680 logt "OK" if not errors else "OK (met fouten)". Een exacte-stringtelling ziet die runs als OK noch als Mislukt. Correctie op de bevinding: dit is geen losse vergissing maar een gekopieerd patroon. Dezelfde ternary staat in 01_SCI … |
| Sparingen_Fix | 03_R&D-a | 1559 | K2 | De buitenste try begint op r.418, direct na start_run r.416, en loopt tot r.1625. Daarna volgen except SystemExit: raise (r.1626-1627) en except Exception: log Mislukt + raise (r.1628-1633). De binnenste transactie-except r.1555-1560 doet RollBack, print, … |
| Staal_Controle | 03_R&D-a | 682 | K2 | verzamel_elementen r.673-682: zonder selectie verschijnt forms.alert(yes/no), en bij Nee volgt script.exit() met SystemExit. main r.815 roept dit aan binnen de try r.937. Except SystemExit r.939-942 logt 'Afgebroken' ('gestopt via forms.alert/sys.exit') en … |
| Staal_Controle | 03_R&D-a | 818 | K2 | main r.815-818: bij een lege elementenlijst volgen forms.alert en return 'v.. / bron=.. / elementen=0'. Die waarde loopt door naar de else-tak r.946-947, die OK logt. Er is niets gecontroleerd, dus 'Geen actie' hoort hier. |
| Paal-Paal | 03_R&D-b | 582 | K1 | Bevestigd. r.582-585: 'except Exception as e: t.RollBack(); print(...); log_tool_gebruik(..., "Mislukt", ...)' en dan stopt het bestand (585 regels). Er volgt geen raise, dus de fout wordt ingeslikt en pyRevit toont geen traceback. Er is ook geen 'except … |
| Sparingen_Controle | 03_R&D-b | 2229 | K2 | Bevestigd. De buitenste try begint op r.820 (moduleniveau). De OK-log op r.2229-2232 staat op 4 spaties inspringing en de vlieg-lus (r.2255-2314: if plan / forms.alert yes/no / while True met SelectFromList, AppDomain, ShowDialog, vlieg_naar -> … |

### Info (8)

| Knop | Batch | Regel | Crit. | Kern |
|---|---|---|---|---|
| BatchLink | 01_SCI-zwaar | 291 | K2 | Gelezen r. 118-303. In de tak if not revit.uidoc (r. 291-292) volgt alleen forms.alert, zonder exitscript en zonder log_tool_gebruik. Het script loopt daarna gewoon af, zodat er geen logregel komt. Alle andere uitgangen loggen precies één keer: geen … |
| AutoSave | 02_Beta | 692 | K1 | r691-692 roept main() aan zonder try. main (r630-688) logt alleen bij een standwissel (r677-682, status aan/uit). Dat is bewust, volgens het commentaar op r114-115: 'Alleen het aan-/uitzetten wordt gelogd'. Annuleren (r645-646) geeft return zonder log, ook … |
| Framing_Taggen | 02_Beta | 2861 | K1 | r2854-2861: RollBack, print, forms.alert met de exceptietekst, log_tool_gebruik 'Mislukt' en daarna sys.exit(). Er is geen except SystemExit die nog eens logt, dus precies één logregel, en de finally van log_tool_gebruik ruimt de markering op. De exception … |
| Kolommen_Taggen | 02_Beta | 2499 | K1 | r2492-2499 heeft dezelfde opbouw als Framing_Taggen: RollBack, alert met de fouttekst, één log 'Mislukt' en daarna sys.exit(). Er is geen buitenste except SystemExit, dus geen dubbele regel, en de markering wordt opgeruimd. Alleen de traceback gaat … |
| WandgatenVerticaal | 02_Beta | 556 | K1 | r551-556 binnen de buitenste try (r226): RollBack, TaskDialog met de fouttekst, log 'Mislukt' en sys.exit(). De buitenste 'except SystemExit: raise' (r573-574) logt niet opnieuw, dus precies één regel, en de markering wordt opgeruimd. Doordat de exception … |
| Lees_MCP | 03_R&D-a | 4466 | K1 | r.4466-4467: if __name__ == '__main__': main() staat zonder try. Binnen main (r.4357-4422) is alleen _start afgeschermd (r.4411-4417, logt Mislukt). _stop r.4226 noemt zichzelf 'Faalt nooit' en heeft per stap een try; alleen 'with lock' en de … |
| ModelCheck | 03_R&D-a | 1294 | K2 | r.1291-1294: bij doc is None volgen forms.alert en return u'geen document'. De else-tak r.1348-1349 logt dat als OK. Het pad bestaat dus. bundle.yaml heeft echter een lege 'context:' en geen zero-doc-context. Daardoor schakelt pyRevit de knop standaard uit … |
| ModelVergelijk | 03_R&D-a | 145 | K2 | r.139-145: sys.path wordt uitgebreid met de eigen knopmap en lib, daarna volgt de ongeschermde 'import vergelijk_kern as kern' op moduleniveau. _tool_t0/start_run staan op r.688-690 en het entrypoint-try op r.2449. Faalt de import, dan komt er geen … |

### Weerlegd door de verificatie (2)

- **Lock_Stramien** (K3): Gelezen r. 860-868 (DROOGLOOP = bool(__shiftclick__) met een NameError-fallback), r. 1536-1617 en r. 2056-2057. 'Droogloop' wordt alleen bij Shift+klik gelogd, één keer. De sys.exit() op r. 1617 gaat via except SystemExit: raise naar buiten, dus er is geen dubbele log, en er is geen start_run. De ke
- **Paal-Paal** (K4): Klopt dat log_tool_gebruik bij _TEST vóór de try/finally returnt (r.110-111) en dat start_run (r.176) onvoorwaardelijk draait. Maar ap_testrun in Lees_MCP/script.py vervangt runmark vóór execfile door een nep-module: r.3324-3331 _nep_runmark() maakt start_run/run_stamp/run_mark_clear no-op, r.3447 s

### Info-meldingen zonder verificatie (25)

Niet door de skeptische ronde gegaan (alleen fout/waarschuwing wordt geverifieerd). Lees ze als hint.

- RVTLinks uit r.46 (K2): Staan alle links al uit, dan is types leeg en gebeurt er niets. De else-tak logt toch "OK" met '0 link(s) uit' (r.76-77). De detailtekst laat het zien, maar aggregate_logs telt de run als geslaagd gebruik.
- Align_Scopebox r.215 (K3): Staat de scope box al exact goed, dan logt de knop 'OK' terwijl er niets gewijzigd is ('al exact uitgelijnd, geen actie nodig'). Die run telt daardoor als geslaagde bewerking.
- Lock_Stramien r.1913 (K3): Twee paden zonder annulering door de gebruiker loggen 'Geannuleerd': r. 1913 'Niets te locken' (na de lock-ronde zonder enig resultaat) en r. 1531-1533 'Niets te proberen'. Het correcte resultaat 'er was niets te doen' k
- Lock_Stramien r.773 (K4): Er is geen start_run, en de inline toollog-kopie heeft geen run_mark_clear. Juist deze knop heeft een gedocumenteerde geschiedenis van harde Revit-crashes rond NewAlignment: de commentaren bij TRACE_GEBRUIKERS (r. 790-80
- ProjectNotitie r.455 (K2): btn_save_Click zet _afgehandeld = True vóór self._event.Raise() (r. 457). De uitkomst van Raise() (ExternalEventRequest) wordt niet getoetst, en een exception erin wordt ingeslikt. Draait de handler daardoor nooit, of do
- AutoDim_Detail r.3650 (K3): Twee voorwaarde-uitgangen in main() loggen 'Geannuleerd', terwijl de gebruiker niets annuleerde: maatlijntype niet gevonden (r3650) en geen bruikbare views (r3686). Die horen 'Geen actie' te zijn. Daarnaast logt r3742 al
- AutoSave r.680 (K3): De statussen 'aan' en 'uit' zijn bewust: het commentaar op r112-114 zegt dat alleen het aan- en uitzetten gelogd wordt, niet elke save. Gevolg: aggregate_logs telt AutoSave nergens mee in OK/Mislukt/Geannuleerd, en Duur_
- Framing_Taggen r.1369 (K3): Een aantal voorwaarde-uitgangen logt 'Geannuleerd', terwijl de gebruiker niets annuleerde: geen plattegrond (r1369), view template (r1375) en geen liggers gevonden (r1468). Die horen 'Geen actie' te zijn. Ontbrekende tag
- Kolommen_Taggen r.1663 (K3): Voorwaarde-uitgangen loggen 'Geannuleerd' in plaats van 'Geen actie': geen plattegrond (r1663), view template (r1669), view zonder GenLevel (r1677) en geen kolommen gevonden (r1933). Ontbrekende tagtypes geven 'Mislukt' 
- Projectmap r.30 (K4): De ImportError-terugval van log_tool_gebruik (r29-31) is een kale no-op en roept run_mark_clear() niet aan. runmark wordt los geïmporteerd (r36-37). Ontbreekt toollog.py terwijl runmark.py er wel staat, dan zet start_run
- Tag_Details r.3648 (K3): 'Geen detail-view in het bereik' logt 'Geannuleerd'. Dit is een voorwaarde en geen annulering door de gebruiker; het hoort 'Geen actie' te zijn.
- Tags_Verwijderen r.305 (K1): De uitkomst van t.Commit() wordt niet getoetst. Commit() gooit geen fout bij een rollback (bijvoorbeeld tags die een collega in bezit heeft), dus r315 logt dan 'OK' met n = len(doc.Delete(...)), terwijl er niets weg is. 
- Lees_MCP r.4382 (K3): De statussen 'aan', 'uit' en 'stand' (r.4382, 4408, 4422) zijn bewust: volgens het commentaar op r.235 wordt alleen aan- en uitzetten gelogd, net als bij AutoSave. Gevolg voor de telling: LeesMCP heeft nooit OK-runs in a
- Lees_MCP r.246 (K4): Het ontbreken van start_run is bewust en terecht. De knop zet een luisteraar aan of uit en eindigt direct, en het toollog-blok logt alleen toggles (r.235). Een markering heeft hier geen run om te bewaken. De knop kent ru
- ModelExport r.683 (K1): Het entrypoint (r.683-687) heeft geen except SystemExit-tak. Op dit moment is er geen exit-pad (pick_folder-annulering valt terug op Desktop). Een toekomstige sys.exit of exitscript zou echter geen logregel en een staand
- ModelVergelijk r.2458 (K1): except Exception logt 'Mislukt' via _afsluiten, maar gooit niet door: er volgt een forms.alert (r.2461). Dat is bewust volgens het commentaar (traceback naar de runlog, niet naar de gebruiker), en de logging zelf klopt. 
- Penant_Controle r.1514 (K1): except SystemExit doet 'pass' in plaats van raise. Dat is bewust: een ontsnappende SystemExit draait in pyRevit de gecommitte run terug, zie het commentaar op r.1515-1527. Alle 13 sys.exit-paden loggen vooraf precies één
- Sparingen_Fix r.1554 (K1): De status van t.Commit() wordt niet getoetst. Draait Revit de transactie zelf terug (failure-afhandeling), dan gooit Commit geen exception en logt r.1618 toch 'OK' met de aantallen Gesynchroniseerd/Aangemaakt die niet in
- ElementNotities r.547 (K4): Geen start_run: dit is bewust en geen vergissing. Het commentaar op r.547-551 legt uit dat een paneel dat een werkdag openstaat na 12 uur als 'Vastgelopen' geboekt zou worden, en bij het sluiten nog een tweede regel zou 
- Koppeling_Berekening r.251 (K1): Na start_run (r.230) draaien _laad_dotnet() en de imports van System.IO.Compression/System.Xml (r.251-257) op moduleniveau, buiten de hoofd-try (r.1506). Wordt een van die assemblies op een .NET-versie niet gevonden, dan
- Projectcijfers r.773 (K3): Kiest de gebruiker 'nee' bij 'CSV maken?', dan wordt de hele run als 'Geannuleerd' geboekt, terwijl het volledige rapport al getoond is. Zustertool Tijdverdeling boekt hetzelfde geval (rapport getoond, niet geëxporteerd)
- Vakwerk_Overzicht_Controle r.1230 (K3): In de selectiemodus (Shift+klik) wordt het geval 'geen vakwerken in dit model' gelogd als 'OK' en daarna volgt script.exit(). Er gebeurde niets, dus dit hoort 'Geen actie' te zijn. Nu telt het als een geslaagde run.
- Vakwerk_uit_Excel r.311 (K1): Hetzelfde patroon als Koppeling_Berekening: _laad_dotnet() plus de imports van System.IO.Compression/System.Xml (r.311-316) staan na start_run (r.265) en buiten de hoofd-try (r.2455). Bij een ImportError komt er geen log
- copy_palen_linkedmodel r.239 (K3): 'Geen geladen Revit-links' (r.179) en 'Geen funderingen gevonden' (r.239) worden als 'Geannuleerd' gelogd, maar de gebruiker annuleerde niets. Er viel niets te doen, en dat is 'Geen actie'. Alleen r.249 (bevestiging gewe
- copy_palen_linkedmodel r.366 (K1): Een kopieerfout per link wordt ingeslikt (except, rollback, continue; r.366). De eindregel (r.393) is altijd 'OK', ook als elke link faalde en Gekopieerd=0. In de telling ziet een volledig mislukte run eruit als een gesl