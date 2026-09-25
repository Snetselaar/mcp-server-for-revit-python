---
titel: De MCP-koppeling — eigen koppeling tussen Claude en Revit, lezen en schrijven
status: concept
laatst-bijgewerkt: 2026-09-21
bronnen:
  - "W:\\4 - Tijdelijk en verwijderen\\AWO\\Extensions\\03_R&D\\RnD.extension\\03_R&D.tab\\Tools.panel\\Lees_MCP.pushbutton\\script.py (versie 2.1, gelezen 2026-09-21)"
  - "hetzelfde pad, bundle.yaml (tooltip, engine: persistent: true)"
  - "W:\\4 - Tijdelijk en verwijderen\\AWO\\Extensions\\03_R&D\\RnD.extension\\mcp_lezen\\revit_lezen_server.py (versie 2.1)"
  - "bouwplan_mcp_schrijfmodus.md, opgesteld 2026-09-19 met Albert"
  - "reflectie tegen RevitAPI.dll en RevitAPIUI.dll van Revit 2024 en 2027, 2026-09-21"
  - ".mcp.json (deze repo), server revit-lezen, gelezen 2026-09-17"
  - "waargenomen: gebruikt als meetroute in S-9479_R25 (2026-09-15) en S-9497_R27 (2026-09-16)"
  - "eerste schrijfrun: IKC Cunera_CON_SNE_9204_DO_R25 (Revit 2025), 2026-09-21, 175 verzoeken"
verwant:
  - routes-thread-veiligheid.md
  - mcp-revit-koppeling.md
  - ifc-export-staalgewicht.md
  - ifc-import-verboden-tekens-in-namen.md
  - modeless-venster-persistente-engine.md
  - mcp-versus-custom-tools.md
  - rebar-api-parameters.md
  - mcp-eigen-tools-toevoegen.md
skill: sci-bim-context
---

# De MCP-koppeling

Een eigen MCP-koppeling waarmee Claude een open Revit-model leest en, in de
hoogste stand, ook wijzigt. Gebouwd op 14-09-2026 als vervanger van de
Nonica-connector, die een daglimiet heeft, en als uitweg uit de instabiele
pyRevit Routes-server (`routes-thread-veiligheid.md`). Stand 2026-09-21: knop
**MCP** in 03_R&D, versie 2.1. De knopmap heet nog `Lees_MCP.pushbutton`, zodat
de reeks in `Gebruikslog.csv` onder `LeesMCP` doorloopt.

## 1. Twee helften

| Helft | Waar | Draait op |
|---|---|---|
| Knop **MCP** | `03_R&D.tab\Tools.panel\Lees_MCP.pushbutton` | IronPython 2.7 in Revit, persistente engine |
| MCP-server `revit-lezen` | `RnD.extension\mcp_lezen\revit_lezen_server.py` | CPython ≥ 3.11 via `uv run --script` (inline dependency `mcp>=1.23,<2`), stdio |

`.mcp.json` in deze repo start de server met
`uv run --script "W:\...\mcp_lezen\revit_lezen_server.py"` (gelezen 2026-09-17).

Anders dan bij `mcp-revit-koppeling.md` zit er **geen pyRevit Routes en geen
HTTP** tussen (docstring van de server, r. 18).

## 2. Drie standen

Een klik opent een keuze met de huidige stand in de titel (`script.py:2845`,
`forms.CommandSwitchWindow`).

| Stand | Listener | Leestools | Schrijftools |
|---|---|---|---|
| Uit | gestopt | — | — |
| Alleen lezen | actief | ja | geweigerd |
| Lezen en schrijven | actief | ja | toegestaan, alleen in het gebonden model |

Revit start altijd op **Uit**; schrijven overleeft een herstart niet. Wie naar
*Lezen en schrijven* gaat, krijgt eerst een `TaskDialog` met de modelnaam en de
vraag of elke wijziging bevestigd moet worden. Het model dat op dat moment
actief is, wordt vastgelegd: een schrijfaanvraag terwijl een ander model actief
is, wordt geweigerd met beide namen in de melding (`script.py:1575`).

Omschakelen tussen de twee actieve standen laat de listener draaien. Er komt
geen nieuwe poort en geen nieuwe sleutel, dus een lopende leessessie merkt er
niets van. De stand staat in AppDomain-data onder dezelfde sleutel als de rest
van de sessiestatus, en gaat mee in het sessiebestand en in het ping-antwoord.

## 3. Werking

1. Klikken zet een .NET `TcpListener` aan op `127.0.0.1`, eerste vrije poort in
   de reeks **48950-48969**, op één achtergrondthread. Die thread raakt de
   Revit API nooit aan, print niet en logt niet, en vangt elke exception af.
2. Een verzoek is één regel JSON met een sessiesleutel. De thread zet het in een
   wachtrij, roept `ExternalEvent.Raise()` aan en wacht met
   `ManualResetEvent.WaitOne` op een time-out.
3. Revit voert de handler pas uit tussen twee commando's: nooit tijdens een
   commando of een modale dialoog.
4. Elke aanvraag heeft sinds 2.0 een **id en een deadline**. De handler slaat
   een verlopen aanvraag over; bij schrijven toetst hij de deadline nog een keer
   na de bevestigingsdialoog en vlak voor `Transaction.Start()`. Een aanvraag
   waarop Claude al een time-out kreeg, kan het model dus niet alsnog wijzigen.
   De deadline komt sinds 2.1 als absolute vervaltijd (`verval_op`) van de
   client. Dat moest, want deze thread accepteert verbindingen **een voor een**:
   staat er een dialoog open, dan blijft de volgende aanvraag in de TCP-backlog
   staan en kreeg hij daarvoor pas bij het accepteren zijn deadline. Een
   aanvraag die bij binnenkomst al verlopen is, gaat de wachtrij niet meer in.
5. De uitkomst van een schrijfaanroep blijft 10 minuten bewaard onder zijn id.
   `haal_resultaat` leest die uit, en wordt net als `ping` volledig op de
   luisterthread beantwoord. Juist als Revit bezet is komt dat antwoord dus wél.

Lezen opent nergens een `Transaction`; schrijven opent er precies één per
aanroep.

## 4. Sessies en beveiliging

- Bij het aanzetten schrijft de knop `%LOCALAPPDATA%\SCI_RevitLeesMCP\sessie_<pid>.json`
  met poort, sleutel en stand. Elk verzoek moet die sleutel meesturen. Het
  bestand is alleen leesbaar voor het eigen Windows-account, dus een webpagina
  kan de poort niet misbruiken.
- De server leest alle sessiebestanden, pingt elke sessie en gebruikt alleen de
  levende (`revit_lezen_server.py:101-133`).
- Staan er meerdere Revit-sessies aan, dan weigert elke tool tot er een gekozen
  is met `kies_revit_sessie`.
- De MCP-server is geen beveiliging: hij registreert de schrijftools altijd, ook
  in leesmodus. De weigering komt uit Revit, want alleen daar is de stand bekend.

## 5. De tools

44 tools (`@mcp.tool`, geteld 2026-09-21): twee voor sessiebeheer, `get_status`,
37 leestools, drie schrijftools en `haal_resultaat`.

Afspraken die de server aan Claude meegeeft: lengtes en coördinaten in
**millimeters** ten opzichte van de projectinterne oorsprong, element-id's als
gehele getallen, eerst `dry_run`, nooit twee schrijfaanroepen tegelijk, en bij
een time-out op een schrijfaanroep de uitkomst opvragen in plaats van opnieuw
sturen.

Time-outs: 30 s standaard, 120 s voor zware leestools én voor schrijfaanroepen
(de bevestigingsdialoog blokkeert de wachtrij zolang hij openstaat). De
CPython-kant wacht `timeout_s + 10`, zodat de Revit-kant altijd eerst antwoordt.
Per aanroep maximaal 1.000 id's bij lezen en 500 bij schrijven.

### De drie schrijftools

| Tool | Doet | Weigert |
|---|---|---|
| `zet_parameter` | parameter op naam zetten, op de instantie of op het type | alleen-lezen en ontbrekende parameters, `ElementId`-parameters, andere eenheden dan lengte (mm) en getal |
| `wijzig_type` | ander type via `type_id` of `type_naam` | een typenaam die binnen de categorie op meer dan één type past (geeft de kandidaten terug), ongeldige types, vastgepinde elementen |
| `verplaats_elementen` | verplaatsen over dx/dy/dz in mm | vastgepinde elementen |

Alle drie hebben `dry_run=true` als standaard en geven per element een regel
terug met de oude en de nieuwe waarde. Het antwoord bevat altijd `model` en
`id_aanvraag`, plus `modus`: `voorbeeld`, `uitgevoerd`, `geweigerd`, `verlopen`
of `teruggedraaid`.

Een echte schrijfaanroep loopt langs: poorten (stand, gebonden model,
`IsReadOnly`, `IsModifiable`, familie- of gelinkt document, aantal) →
bevestigingsdialoog → deadline-hercontrole → worksharing → één transactie met
een `IFailuresPreprocessor` die waarschuwingen wegvangt en bij een fout
terugdraait. De transactienamen zijn `Parameter zetten via Claude`, `Type
wijzigen via Claude` en `Elementen verplaatsen via Claude`, zodat in de
undo-lijst te zien is waar een wijziging vandaan komt.

Worksharing: elementen die een ander in bezit heeft worden overgeslagen met de
naam van de eigenaar (`GetWorksharingTooltipInfo().Owner`), vrije elementen
worden vóór de transactie uitgecheckt, en staat er nieuwer werk in het centrale
model, dan volgt een waarschuwing.

Wat er bewust **niet** in zit: verwijderen, kopiëren, roteren, elementen of
families aanmaken, schrijven in gelinkte modellen of families, en vrije code.
Dat laatste is een harde grens, geen v2-wens: `/execute_code/` is er juist om
crashes uit gehaald (`execute-code-crasht-revit`, memory).

## 6. Logging

De knop logt zijn eigen aan/uit en de standwissel als `LeesMCP`. Een **echte**
schrijfaanroep levert één regel onder de lint-breed unieke naam
`MCP_schrijven`, met `OK`, `Geen actie`, `Geannuleerd` (bevestiging geweigerd),
`Afgebroken` (deadline verstreken) of `Mislukt` (rollback). Een `dry_run` logt
niet. In de details staan alleen de toolnaam, de parameternaam en aantallen:
geen waarden en geen element-id's.

De logfunctie kreeg hiervoor een `stil=True`-variant. Dat is een bewuste
afwijking van de inline toollog-kopie van de andere knoppen: een `print()`
vanuit de `ExternalEvent`-handler klapt het pyRevit-outputvenster open midden in
het werk van de gebruiker.

## 7. Versiegeschiedenis

| Versie | Datum | Wat |
|---|---|---|
| 1.0 | 14-09-2026 | eerste versie |
| 1.1 | 14-09-2026 | eerste echte run op `S-9464`, Revit 2025: elk verzoek faalde op `4138977L is not JSON serializable` — een `System.Int64` uit `ElementId.Value`. Nu `int()` plus een json-terugval |
| 1.2 | 14-09-2026 | `'unknown' codec can't decode byte 0xb2` bij het teken ² in een weergavewaarde. IronPython-`json` met `ensure_ascii=True` decodeert tekst ≥ 0x80 als UTF-8; nu `ensure_ascii=False` |
| 2.0 | 21-09-2026 | knop heet MCP, drie standen, drie schrijftools, id en deadline per aanvraag, `haal_resultaat`, bevestigingsdialoog, worksharing |
| 2.1 | 21-09-2026 | na de eerste echte schrijfrun: de nameting van `nieuw` gebeurt na de commit in plaats van erin, en de deadline gaat als absolute `verval_op` mee van de client. Zie §9 |

De eerste twee fouten zijn IronPython 2.7-eigenaardigheden en horen bij de
valkuilen uit de skill `pyrevit-codestijl`.

## 8. Wat er voor 2.0 is geverifieerd

Alle gebruikte API-leden zijn op 21-09-2026 via reflectie tegen de
`RevitAPI.dll` en `RevitAPIUI.dll` van Revit 2024 **en** 2027 gecontroleerd, met
`System.Reflection.Metadata` vanuit PowerShell (`RnD.extension	ools\check_api.ps1`,
op 21-09-2026 hiervoor geschreven; `tools/check_versies.py` in `Snetselaar_BIM`
doet het lintbrede werk en blijft bestaan). Aanwezig in beide versies, met
dezelfde signatuur:

```
Transaction.GetFailureHandlingOptions / SetFailureHandlingOptions / GetStatus
FailureHandlingOptions.SetFailuresPreprocessor
FailuresAccessor.GetFailureMessages / DeleteWarning
FailureProcessingResult.{Continue, ProceedWithRollBack}
IFailuresPreprocessor.PreprocessFailures(FailuresAccessor) -> FailureProcessingResult
Definition.GetDataType() -> ForgeTypeId, SpecTypeId.Length, SpecTypeId.Number
UnitUtils.ConvertToInternalUnits(Double, ForgeTypeId), UnitTypeId.Millimeters
Element.ChangeTypeId(ElementId), Element.GetValidTypes(), Element.Pinned
ElementTransformUtils.MoveElement(Document, ElementId, XYZ)
WorksharingUtils.GetCheckoutStatus / GetModelUpdatesStatus / CheckoutElements
Document.IsReadOnly / IsLinked / IsModifiable / IsFamilyDocument
TaskDialog.AddCommandLink / DefaultButton, TaskDialogResult.CommandLink1..4
```

`ElementId(Int32)` bestaat in 2024 en 2025 wel en in 2026 en 2027 niet meer;
`ElementId(Int64)` bestaat in alle vier. Dat bevestigt de tabel in
`pyrevit-codestijl` §5 en de bestaande helper in de knop.

`ForgeTypeId` wordt vergeleken op `.TypeId` (een string) en niet met `.Equals()`.
`.Equals(Object)` bestaat in beide versies, maar een string-vergelijking is in
IronPython 2.7 zeker; die keuze is niet uit nood geboren maar uit voorzichtigheid.

Offline getoetst op 21-09-2026, buiten Revit:

- het script compileert onder IronPython 2.7.12 (pyRevit-engine `IPY2712PR`, via
  de hosting-API vanuit PowerShell);
- `tools/check_versies.py` uit `Snetselaar_BIM` geeft twee HARD-bevindingen, en
  die zijn allebei **vals**: `ws.Id.IntegerValue` op r. 1339 en
  `wid.IntegerValue` op r. 1365 staan op een `WorksetId`, niet op een
  `ElementId`. `WorksetId.IntegerValue` bestaat in 2024 t/m 2027 en
  `WorksetId.Value` bestaat in geen van de vier (reflectie, 21-09-2026). Die
  regels moeten dus blijven zoals ze zijn; de 2024+-fallback erin zetten zou ze
  juist slopen. De patroonlaag van `check_versies.py` herkent alleen het
  `ElementId`-geval;
- 54 toetsen op de schrijflogica, met de functies rechtstreeks uit `script.py`
  geknipt en gedraaid tegen nep-parameters en nep-documenten: eenheden,
  ja/nee-waarden, alle weigeringen, de antwoordvorm en de resultaatcache;
- 33 toetsen op het protocol, met de echte MCP-server tegen een nep-Revit: het
  id van 8 tekens per schrijfaanvraag, de deadline van 120 s, de argumenten, en
  dat een leestool géén id krijgt.

Wat offline niet te toetsen is en dus in Revit moet: de transactie zelf, de
bevestigingsdialoog, de checkout, de standenkeuze en het icoon. Die punten staan
in `test_matrix.md` bij de rij `MCP (map Lees_MCP)`.

## 9. Wat de eerste schrijfrun opleverde

Gedraaid op 2026-09-21 in `IKC Cunera_CON_SNE_9204_DO_R25` (Revit 2025, niet
workshared, een echt project), op verzoek van Albert en zonder op te slaan. 175
verzoeken, geen time-out, geen fout in de statusregel. Twee fouten kwamen boven
water die tegen een nep-Revit niet te vinden waren.

**Het veld `nieuw` werd binnen de transactie gemeten.** Een ja/nee-parameter
geeft daar nog zijn oude weergavetekst terug: `translatie_x` meldde `No` terwijl
het model er daarna `Yes` van maakte. Erger was de verplaatsing: die meldde
`uitgevoerd` met `x = 51336`, maar bij het committen trok een constraint de kolom
terug naar `51436`, zonder dat Revit een fout gaf. De tool meldde dus een
wijziging die er niet stond. Sinds 2.1 gebeurt de nameting na de commit, en
landt een element ergens anders dan gevraagd, dan krijgt het de status
`anders_geland` en telt het niet als gewijzigd.

**De deadline beschermde niets zolang de wachtrij geblokkeerd was.** De
luisterthread accepteert verbindingen een voor een. Stond er een
bevestigingsdialoog open, dan bleef de volgende aanvraag in de TCP-backlog
hangen en kreeg hij pas bij het accepteren zijn deadline — dus een verse.
Gemeten: een aanvraag met een deadline van 2 s zette `Mark` alsnog, ruim tien
seconden nadat de client hem had opgegeven. Precies het gevaar waarvoor W1 in
het bouwplan bedoeld was. Sinds 2.1 stuurt de client een absolute `verval_op`
mee en weigert de knop een aanvraag die bij binnenkomst al verlopen is, zonder
hem in de wachtrij te zetten.

Wat in dezelfde run wel meteen goed ging:

- de rollback, in het echt: `verplaats_elementen` liep op *Constraints are not
  satisfied*, de `FoutenVanger` draaide de transactie terug en het model bleef
  aantoonbaar onveranderd;
- alle poorten, inclusief 501 id's, een gelinkt model als actief document, en een
  instance-id dat als `type_id` werd aangeboden;
- lengtes: 350 mm kwam aan als intern 1,148293963 voet;
- `op_type=true` landde op twee types en was zichtbaar op instanties die niet in
  de aanroep stonden, met `bron: type` in het leesantwoord;
- vastgepinde stramienen, alleen-lezen parameters (`Column Location Mark`,
  `Volume`), een hoekparameter (`Cross-Section Rotation`) en een
  `ElementId`-parameter werden alle vier overgeslagen of geweigerd met reden;
- de bevestigingsdialoog: drie keer Toestaan en een keer Weigeren, waarbij de
  weigering `geweigerd`, nul gewijzigd en een onveranderd model opleverde;
- de stand *Alleen lezen* weigert alle drie de schrijftools, ook met
  `dry_run=true`, terwijl de leestools in 0,02 s blijven antwoorden;
- `haal_resultaat` gaf een uitkomst van 74 seconden oud terug, en blijft werken
  na het wisselen van stand — de luisteraar draait dan gewoon door.

De fix op dat tweede punt is in dezelfde sessie nagemeten. De race is acht keer
achter elkaar uitgelokt met een zware schrijfaanroep die de accept-lus ongeveer
0,6 s bezet houdt (`Comments` op 500 liggers) en een tweede aanvraag die tijdens
die blokkade binnenkomt met een vervaltijd van 0,25 s: acht van de acht gaven
`verlopen` met nul wijzigingen. De tegenproef, dezelfde race maar met 30 s
speling, ging gewoon door.

Nog niet getest: de knop op 2024, 2026 en 2027, een centraal model met een
element van een collega, een Ctrl+Z over een schrijfaanroep, en schrijven terwijl
Revit in de sketch-modus staat (`IsModifiable`).

## 10. Aandachtspunten

- **Persistente engine is vereist** (`bundle.yaml`), anders sterft de engine
  achter de luisterthread. De toestand staat in AppDomain-data, omdat pyRevit
  elke run een verse scope geeft. Zie voor het versierisico van die vlag
  `modeless-venster-persistente-engine.md`.
- [ONBEVESTIGD] Of de koppeling op pyRevit 6.1.0 werkt, waar de
  persistent-vlag niet in de gecompileerde knop aankwam. Niet getest.
- De ruwe `waarde` van een `Double`-parameter komt uit de leestools in **voet**,
  niet in mm: `_param_dict` geeft `p.AsDouble()` onbewerkt terug, terwijl
  locaties en bounding boxes wel door de mm-omrekening gaan. `zet_parameter`
  neemt mm. Het `weergave`-veld (`AsValueString`) is de mm-waarde en is dus de
  juiste bron bij een vergelijking voor en na. Gemeten in de code op
  2026-09-21, bewust niet gewijzigd om de leeskant ongemoeid te laten.
- Staat in 03_R&D, dus alleen voor de beperkte doelgroep.
- Werkt op 2025 én 2027, en is daarmee een versie-onafhankelijk alternatief voor
  de Autodesk MCP-server, die pas vanaf 2027 draait
  (`mcp-versus-custom-tools.md` §4).
- De schrijftools staan bewust **niet** in `permissions.allow` van Claude Code.
  Daardoor vraagt Claude Code zelf ook toestemming, naast de dialoog in Revit.
