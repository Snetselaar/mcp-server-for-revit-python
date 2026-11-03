# Changelog SCI-lint — 03_R&D

Ontwikkelknoppen: nog in ontwikkeling en niet uitgerold naar de modelleurs. Per knop wat er veranderd is, nieuwste versie bovenaan.
Stand: 30-10-2026. Het versiebeheer begon op 21-07-2026. Knoppen die toen al bestonden, beginnen met "al aanwezig".

Knoppen die al naar 02_Beta of 01_SCI zijn doorgeschoven, staan in `Changelog lint.md`.

---

## Controle

### ModelCheck
*huidige versie 1.3.2*
- **1.3.2** · 02-10-2026 — Rapportvenster op 90 % van het scherm, gecentreerd.
- **1.3.1** · 01-10-2026 — Rapportvenster te verslepen naar een tweede scherm.
- **1.3** · 01-09-2026 — Rapport in de Snetselaar-huisstijl.
- **1.2** · 24-07-2026 — Werkt op Revit 2024 t/m 2027 (ElementId-fix).
- **1.1** · 21-07-2026 — Al aanwezig: alleen-lezen controle van kwaliteit, naamgeving en geometrie.

### Staal Controle
*huidige versie 1.2.2*
- **1.2.2** · 02-10-2026 — Rapportvenster op 90 % van het scherm, gecentreerd.
- **1.2.1** · 01-10-2026 — Rapportvenster te verslepen naar een tweede scherm.
- **1.2.0** · 01-09-2026 — Rapport in de Snetselaar-huisstijl.
- **1.1.0** · 21-07-2026 — Al aanwezig: toetst of de typenaam van staal klopt met de afmetingen.

### Kolom Controle
*huidige versie 1.4.2*
- **1.4.2** · 02-10-2026 — Rapportvenster op 90 % van het scherm, gecentreerd.
- **1.4.1** · 01-10-2026 — Rapportvenster te verslepen naar een tweede scherm.
- **1.4** · 01-09-2026 — Geen tijdelijke view meer; aanwijzen gebeurt in het rapport. Laat niets achter in het model.
- **1.3** · 01-09-2026 — Vergelijkt staalsoort op StructuralClass.
- **1.2–1.2.1** · 01-09-2026 — Rapport in huisstijl; tooltip zegt nu wat de knop doet.
- **1.1** · 24-07-2026 — Werkt op Revit 2024 t/m 2027 (ElementId-fix).
- **1.0** · 21-07-2026 — Al aanwezig: staalsoort per kolomprofiel controleren.

### Framing Controle
*huidige versie 1.4.2*
- **1.4.2** · 02-10-2026 — Rapportvenster op 90 % van het scherm, gecentreerd.
- **1.4.1** · 01-10-2026 — Rapportvenster te verslepen naar een tweede scherm.
- **1.4** · 01-09-2026 — Geen tijdelijke view meer; aanwijzen gebeurt in het rapport.
- **1.3** · 01-09-2026 — Vergelijkt staalsoort op StructuralClass.
- **1.2** · 01-09-2026 — Rapport in de Snetselaar-huisstijl.
- **1.1** · 24-07-2026 — Werkt op Revit 2024 t/m 2027 (ElementId-fix).
- **1.0** · 21-07-2026 — Al aanwezig: staalsoort per liggerprofiel controleren (zonder trusses).

### Wand Sparingen Controle
*huidige versie 3.8.2*
- **3.8.2** · 02-10-2026 — Rapportvenster op 90 % van het scherm, gecentreerd.
- **3.8.1** · 01-10-2026 — Rapportvenster te verslepen naar een tweede scherm.
- **1.3–3.8** · 14/15-09-2026 — Koppeling met het architectenmodel helemaal herzien: op de sparingen in de wand en overlap langs de wand.
  Alleen nog horizontale afwijking telt; draait alleen in een plattegrond.
- **1.1** · 14-09-2026 — Nieuwe knop: vergelijkt sparingen met ramen en deuren in de architectenlink.

### Penant Controle
*huidige versie 1.6*
- **1.6** · 13-10-2026 — Klikken zonder Finish-knop (Revit 2027): klik per wand aan/uit, Esc = klaar.
- **1.5** · 08-09-2026 — Nieuwe knop: markeert penanten die smaller zijn dan een grens.

### Tijdverdeling
*huidige versie 3.0*
- **3.0** · 16-09-2026 — Alleen het project van het open model en alleen je eigen sessies; export naar HTML.
- **2.0** · 11-09-2026 — Nieuwe knop: verdeelt de Revit-tijd over soort werk, bouwdeel en model (uit de journaals).

### Projectcijfers
*huidige versie 1.0*
- **1.0** · 11-09-2026 — Nieuwe knop: verhoudingen per project (zonder uren), om af te staan aan een calculatie.

### Crash Rapport
*huidige versie 2.0*
- **2.0** · 11-09-2026 — Nieuwe knop: rapport van gecrashte Revit-sessies uit de journaaldata.

### Crop Diagnose
*huidige versie 1.1*
- **1.1** · 24-09-2026 — Aangehaakt op het gebruikslog.
- **1.0** · 10-09-2026 — Nieuwe meetknop: leest de crop-geometrie van de actieve view uit.

## Export

### ModelExport
*huidige versie 1.1*
- **1.1** · 24-07-2026 — Werkt op Revit 2024 t/m 2027 (ElementId-fix).
- **1.0** · 21-07-2026 — Al aanwezig: dumpt het model naar JSON voor analyse.

## Linkedmodels

### Model Vergelijken
*huidige versie 1.4*
- **1.4** · 01-10-2026 — Nieuwe knop: vergelijkt een nieuwe architectenaanlevering (IFC of RVT) met de vorige. Toetst ook of IFC-GUID's stabiel zijn.

### Sparingen Fix
*huidige versie 3.4*
- **3.4** · 15-09-2026 — Synchroniseert, verwijdert en maakt sparingen per bouwlaag, met dezelfde koppeling als Sparingen Controle 3.8.
  Verwijderen en aanmaken weer aan, na de mislukte eerste run.
- **1.2** · 14-09-2026 — Nieuwe knop: zet sparingen gelijk met het architectenmodel. Verwijderen en aanmaken nog uit.

### Copy palen uit link
*huidige versie 1.1*
- **1.1** · 24-07-2026 — Werkt op Revit 2024 t/m 2027 (ElementId-fix).
- **1.0** · 21-07-2026 — Al aanwezig: kopieert funderingen uit de links naar het eigen model.

## Maatvoering

### AutoDim Balken / AutoDim Stramien Balken
*huidige versie 1.3 (beide knoppen)*
- **1.3** · 07-10-2026 — Geen onterechte "Vastgelopen" meer in het gebruikslog.
- **1.2** · 01-10-2026 — Vindt alle funderingsvormen; meet haaks op schuine balken. Stramien alleen als het echt evenwijdig is.
- **1.1** · 11-09-2026 — Werkt goed met een gesplitste crop.
- **1.0** · 21-07-2026 — Al aanwezig: maatketens over balken via een getekende lijn.

### Paal-Paal / Palen-Stramien
*huidige versie 1.3 (beide knoppen)*
- **1.3** · 07-10-2026 — Geen onterechte "Vastgelopen" meer in het gebruikslog.
- **1.2** · 01-10-2026 — Testhaak voor de annotatie-autopilot. Palen-Stramien: ketens worden weer getekend (meetvlak en schuine stramienen).
- **1.1** · 11-09-2026 — Werkt goed met een gesplitste crop.
- **1.0** · 21-07-2026 — Al aanwezig: maatketens in het palenplan via een getekende lijn.

## Notities

### Element Notities
*huidige versie 1.6*
- **1.6** · 07-10-2026 — Eenvoudiger paneel; alleen op de voorgrond als Revit actief is.
- **1.3** · 24-09-2026 — Fixes na de tweede testrun (IKC Cunera).
- **1.2** · 22-09-2026 — Nieuwe knop: zwevend paneel om opmerkingen aan elementen te koppelen.

## Tools

### MCP (Lees-MCP)
*huidige versie 2.5*
- **2.5** · 20-10-2026 — Lijst van sheets met hun mappen, voor de sheetcontrole van de autopilot.
- **2.2–2.4** · 28-09/01-10-2026 — Tools voor de annotatie-autopilot: testrun, annotaties meten, view exporteren.
- **2.0–2.1** · 21/22-09-2026 — Drie standen (uit / lezen / lezen en schrijven) met drie schrijftools.
- **1.2** · 15-09-2026 — Nieuwe knop: eigen alleen-lezen koppeling tussen Claude en Revit.

### Koppeling Berekening
*huidige versie 1.4*
- **1.4** · 13/14-10-2026 — Druklaagdikte goed gelezen ("100-80-100" → 100 mm).
- **1.3** · 18-09-2026 — Berekeningsdocument aantoonbaar alleen gelezen; mag openstaan in Excel.
- **1.2** · 18-09-2026 — Een "-" in het Excel wordt een lege parameter in plaats van een streepje.
- **1.1** · 17-09-2026 — Renvooi: alleen nog de laslengte-betonkwaliteit.
- **1.0** · 17-09-2026 — Nieuwe knop: zet het berekeningsdocument in één keer in Revit. Vervangt Dynamo "004".

### Knippen op…
*huidige versie 2.0*
- **2.0** · 20-10-2026 — Knipt ook op kolommen en balken, alles in één klik. Geen korte stukjes meer. Hernoemd van "Knip op stramien".
- **1.1** · 13-10-2026 — Nieuwe knop: knipt balken op elk stramien dat ze kruisen.

### Hoeklijnen op stramien
*huidige versie 1.0*
- **1.0** · 13-10-2026 — Nieuwe knop: zet begin en eind van balken op de dichtstbijzijnde stramienkruising.

### Profiel aansluiten
*huidige versie 1.1*
- **1.1** · 13-10-2026 — Nieuwe knop: laat balken aan beide einden precies aansluiten tegen het profiel ernaast.

### Join cutback
*huidige versie 1.1*
- **1.1** · 13-10-2026 — Nieuwe knop: laat balken een ingevoerde maat terugliggen van de buurstaaf.

### Standaarden Ophalen
*huidige versie 2.0*
- **2.0** · 30-10-2026 — Nieuwe knop: zet de SCI-standaarden (templates, IFC-mapping, shared parameters) in Revit.ini van elke Revit-versie.

### Wapening uit Technosoft
*huidige versie 1.0*
- **1.0** · 30-10-2026 — Nieuwe knop: zet de wapening uit Technosoft Balkroosters terug in Revit.

## Truss

### Vakwerk maken/aanpassen
*huidige versie 2.11*
- **2.4–2.11** · 12/13-10-2026 — Dialoog met live voorbeeld, profielen en staal per groep, verticalen, hoekwaarschuwing.
  Aanpassen direct vanuit het project; bestaande staven blijven behouden.
- **2.0–2.3.1** · 08/09-10-2026 — Hernoemd van "Vakwerk uit Excel". Ook zelf een vakwerk maken zonder rekenblad; één profielhoogteveld per regel.
- **1.19** · 08-10-2026 — Modus "Vakwerk aanpassen" voor een bestaand vakwerk.
- **1.3–1.18** · sep 2026 — Family-maten, stramien en hoogtes, profielen uit de family, adaptief in hoogte. Leest ook alleen een knopenlijst.
- **1.2** · 03-09-2026 — Nieuwe knop: vakwerkgeometrie uit het Excel-rekenblad in een truss-family.

### Vakwerk Overzicht / Controle
*huidige versie 2.18*
- **2.17–2.18** · 14/20-10-2026 — Controle regels tegen Edit Type, gewicht per vakwerk en familiecontrole (A1, A2 … = familie A).
- **2.16** · 13-10-2026 — Vinkje "Alles" in het selectieraster.
- **2.13–2.15.1** · 08/09-10-2026 — Controle "hart op stramien". Shift+klik opent een selectieraster per type en positie.
- **2.12** · 08-10-2026 — Lengte van boven- en onderregel per type getoetst.
- **2.11** · 07-10-2026 — Onderkant onderregel t.o.v. peil 0 getoetst.
- **2.9–2.10.1** · 01/02-10-2026 — Meldt ontbrekende staven; staalsoort uit StructuralClass.
- **2.6–2.8.1** · 30-09/01-10-2026 — Groepering op familie + type; meerderheid per positie is de norm. Naar het Truss-panel.
- **2.5.1** · 02-09-2026 — Shift+klik op de knop opent een selectiedialoog.
- **2.4** · 01-09-2026 — Nieuwe knop: twee vakwerkknoppen samengevoegd tot overzicht met controle.

### Vakwerk Aanzichten
*huidige versie 3.2*
- **3.2** · 09-10-2026 — Alleen het vakwerk en wat ertegenaan sluit blijft zichtbaar.
- **3.0** · 02-10-2026 — Hernoemd van "Vakwerk Details": per vakwerktype een aanzicht met crop, template en tags.

### Vakwerk toepassen
*huidige versie 1.1*
- **1.1** · 30-10-2026 — Regels en webs krijgen daarna Disallow Join, net als Joins los 2.0.
- **1.0** · 13-10-2026 — Nieuwe knop: profiel en staal van elke staaf volgens de staventabel in de family.

### Vakwerk joins los
*huidige versie 2.0*
- **2.0** · 30-10-2026 — Diagonalen én verticalen lopen door tot de hartlijn van de regels.
- **1.2** · 09-10-2026 — Verticalen sluiten aan op boven- en onderregel.
- **1.0** · 02-10-2026 — Nieuwe knop: haalt de join cutback van 12,7 mm van de regels weg.

### Webs snijden
*huidige versie 1.4*
- **1.4** · 09-10-2026 — Coping weer 0 mm; de proef met 1 mm (1.3) maakte de IFC niet lichter.
- **1.2** · 08-10-2026 — Nieuwe knop: webs lopen door tot de hartlijn en worden door de regel uitgesneden.

### Onderregel aansluiten
*huidige versie 1.0*
- **1.0** · 08-10-2026 — Nieuwe knop: laat de onderregel aansluiten tegen het profiel ernaast.
