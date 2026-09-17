---
titel: Modeless WPF-venster en de persistente engine in pyRevit
status: concept
laatst-bijgewerkt: 2026-09-17
bronnen:
  - "waargenomen bij S-WUL1N op 2026-09-15: crash in model S9475_R25, journaal P:\\9000-9999\\9450-9499\\9475 - fase 1 MJKO Emstek\\3 Tek\\Journals\\journal.0041.txt en journal.0041.0001.dmp"
  - https://raw.githubusercontent.com/pyrevitlabs/pyRevit/master/dev/pyRevitLabs.PyRevit.Runtime/IronPythonEngine.cs
  - https://raw.githubusercontent.com/pyrevitlabs/pyRevit/64fcf31ad284fe73a7a3ea3fead3a840f8a408eb/pyrevitlib/pyrevit/extensions/genericcomps.py
  - "W:\\4 - Tijdelijk en verwijderen\\AWO\\Extensions\\01_SCI\\SCI.extension\\01_SCI.tab\\Notities.panel\\ProjectNotitie.pushbutton\\script.py (versie 1.8)"
  - "C:\\Users\\S-WOU1A\\AppData\\Roaming\\pyRevit\\2025\\pyRevit_2025_b3d37dd068d67ff3_SCI.dll, gelezen op 2026-09-16"
  - "waargenomen 2026-08-26: Revit 2026 liep vast bij een pyRevit-reload nadat ProjectNotitie gebruikt was (werkplek AWO, pyRevit 6.5.5); opnieuw 2026-08-28 bij de Routes-config, zie mcp-revit-koppeling.md §2"
verwant:
  - lees-mcp-koppeling.md
  - routes-thread-veiligheid.md
skill: pyrevit-codestijl
---

# Modeless WPF-venster en de persistente engine in pyRevit

Een pyRevit-knop die zijn venster modeless opent (`Show()` in plaats van
`ShowDialog()`) laat Revit bruikbaar terwijl het venster openstaat. De prijs is
dat het venster blijft leven nadat het script is afgelopen. Wat de eventhandlers
van dat venster daarna nog kunnen aanraken, is beperkter dan het lijkt.

## Wat pyRevit opruimt

`IronPythonEngine.Execute()` maakt per run een verse scope. In het `finally`-blok
staat:

```csharp
if (!ExecEngineConfigs.persistent)
```

en daaronder een stukje Python dat alle niet-dunder namen uit de scope wist:

```python
for __deref in dir():
    if not __deref.startswith('__'):
        del globals()[__deref]
```

Dat is gelijk in de master-versie en in de versie van commit `64fcf31`
(pyRevit 6.1.0). Draait de knop **niet** persistent, dan bestaat na afloop dus
geen enkele modulenaam meer: geen functies, geen constanten, geen
`import`-resultaten. Een callback die later vanuit Revit of Windows wordt
aangeroepen — een WPF-eventhandler of `IExternalEventHandler.Execute` — valt
daarmee in een lege scope.

De Lees-MCP-knop loopt tegen hetzelfde aan en lost het anders op: hij bewaart zijn
toestand in AppDomain-data in plaats van in de module-scope, omdat pyRevit ook op
een persistente engine elke run een verse scope geeft (`lees-mcp-koppeling.md`
§7). Een `ExternalEvent`-callback is ook de voorgeschreven weg voor
model-aanrakende routes (`routes-thread-veiligheid.md` §5); de valkuil hieronder
geldt daar dus evengoed.

## Dat een vlag in bundle.yaml staat, wil niet zeggen dat hij aankomt

De vlag hoort in `bundle.yaml`:

```yaml
engine:
  persistent: true
```

Op de werkplek met pyRevit 6.5.5 komt hij ook echt in de gecompileerde knop
terecht. In `pyRevit_2025_<hash>_SCI.dll` staat per commando een JSON-string:

```json
{"clean":true,"full_frame":false,"persistent":true}
```

Bij een collega op **pyRevit 6.1.0** draaide dezelfde knop, uit dezelfde
gedeelde Lint-map, niet persistent. De Python-kant van 6.1.0 leest de vlag wel
uit de bundle-metadata (`genericcomps.py`, `requires_persistent_engine`), dus het
misgaan zit verderop in de keten naar de DLL. [ONBEVESTIGD] Waar precies is niet
herleid; de DLL van die werkplek is niet ingezien.

De praktische regel: **reken er niet op dat de persistente engine aanstaat.**
Versies lopen per werkplek uiteen en dat is van buitenaf niet zichtbaar.

## Waarom het een crash wordt en geen foutmelding

Op 2026-09-15 crashte Revit 2025 bij een collega op het moment dat zij in
ProjectNotitie op Opslaan klikte. Het journaal toont de klik op de knop
(14:25:53), het typen in het tekstvak (14:26:00) en daarna
`ExceptionCode=0xe0434352`, gevolgd door de fatal error. In het crashdump staat
de oorzaak leesbaar:

```
name '_save_handler' is not defined
```

De klikhandler zocht een modulenaam op die pyRevit had gewist. Die `NameError`
ontsnapte uit de WPF-eventhandler naar de berichtenlus van Revit, waar geen
vangnet van pyRevit meer zit: geen traceback, geen outputvenster, Revit valt weg.
Hetzelfde geldt voor een exception die uit `IExternalEventHandler.Execute`
ontsnapt — die komt in de idle-loop terecht.

De schade is niet zichtbaar in `Gebruikslog.csv`. Een harde crash schrijft geen
logregel, en ProjectNotitie is niet aangehaakt op `runmark`, dus er komt ook geen
status `Vastgelopen`.

## Het patroon dat wel houdt

ProjectNotitie 1.8 (2026-09-16) lost dit op door niets meer aan de module-scope
over te laten. De vier regels, in volgorde van belang:

1. **Vang alles af in elke eventhandler.** Opslaan, Annuleren en sluiten via het
   kruisje staan elk in een `try/except`. Uit een WPF-eventhandler mag nooit een
   exception ontsnappen. Dit alleen al had de crash voorkomen.
2. **Zet op het object wat je later nodig hebt.** Schema-GUID, schemanaam,
   veldnamen, toolnaam en starttijd staan als attributen op het handler-object.
   Het venster krijgt de handler en het ExternalEvent mee als
   constructorargument, niet via een modulenaam.
3. **Importeer in de methode zelf.** `time`, `datetime`, de Revit-types en
   `toollog` worden geïmporteerd binnen de methode die ze gebruikt. Een import
   werkt ook in een lege scope; een modulenaam niet.
4. **Houd het venster vast aan de handler.** De handler is via
   `ExternalEvent.Create()` bij Revit geregistreerd en blijft leven. Een
   modulevariabele `_window` overleeft het opruimen niet, en dan kan de garbage
   collector het venster onder de gebruiker weghalen.

Een functie op moduleniveau aanroepen vanuit zo'n callback helpt niet: die
functie zoekt zijn eigen globals op in dezelfde gewiste scope. Daarom is
`save_notitie()` in 1.8 vervallen en zit die logica in de handler.

## De keerzijde blijft

Draait de engine wél persistent, dan blijft die de hele Revit-sessie leven.
`pyRevit → Reload` probeert de nog levende engine met venster en ExternalEvent af
te breken en kan Revit laten vastlopen. Waargenomen op 2026-08-26 met
ProjectNotitie in Revit 2026 en op 2026-08-28 bij de Routes-configuratie
(`mcp-revit-koppeling.md` §2). Herstart Revit in plaats van te herladen
zodra zo'n knop deze sessie gebruikt is. Dat gedrag is onafhankelijk van de fix
hierboven.

## Diagnose bij een melding die je niet kunt naspelen

- Vraag de **pyRevit-versie** van de melder (pyRevit → About) voordat je in de
  code zoekt. Verschillen tussen werkplekken verklaren meer dan ze lijken.
- Haal het **journaal** van die werkplek op
  (`%LOCALAPPDATA%\Autodesk\Revit\Autodesk Revit <jaar>\Journals`). Het
  `.abbrev`-bestand is genoeg voor de laatste minuut.
- Lees de **exceptietekst uit het `.dmp`**: bytes inlezen, decoderen als Unicode
  én als ASCII, en er met een regex doorheen. Dat werkt zonder debugger.
- Klikken op WPF-knoppen komen in het journaal (`WpfButton(0,OK).Click()`), maar
  **pas nadat de handler klaar is**. Ontbreekt de klik, dan kan die toch gedaan
  zijn — de handler kwam dan niet tot het einde. Sluiten met het kruisje komt
  nooit in het journaal.
- `API_ERROR { : Assembly version conflict … }` bij het opstarten is ruis. In
  `journal.0041.txt` staat hij ook bij Autodesks eigen add-ins.
  [ONBEVESTIGD] Dat hij op elke werkplek voorkomt: alleen dit journaal is
  ingezien.
