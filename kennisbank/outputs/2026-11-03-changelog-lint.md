# Changelog SCI-lint — 01_SCI en 02_Beta

Per knop wat er veranderd is, nieuwste versie bovenaan. Stand: 30-10-2026.

Het versiebeheer begon op 21-07-2026. Knoppen die toen al bestonden, beginnen
met "al in gebruik". Wat daarvóór veranderde, is niet terug te halen.
Een versienummer dat ontbreekt, is tussendoor in de testfase gebruikt.

Waar staat een knop?
**01_SCI** = de vaste knoppen. **02_Beta** = knoppen in de testfase.
Een knop die van 02_Beta naar 01_SCI ging, verloor de vraag "eerst opslaan?" bij de start.

---

# 01_SCI

## Sparingen

### Wandgaten Verticaal
*huidige versie 2.3*
- **2.3** · 13-10-2026 — Klikken zonder Finish-knop (die bestaat niet meer in Revit 2027): klik per wand aan/uit, Esc = klaar.
- **2.2** · 09-10-2026 — Van 02_Beta naar 01_SCI.
- **2.1** · 09-09-2026 — Waarschuwing bij de start als het model nog niet is opgeslagen.
- **2.0** · 28-07-2026 — Het gat gaat nu over de volle doorsnede van kolom én wand. Hernoemd van WandGaten en naar 02_Beta.
- **1.0** · 21-07-2026 — Al in gebruik: maakt verticale gaten in een wand waar een kolom doorheen gaat.

### Kolom Gaten
*huidige versie 1.5*
- **1.5** · 13-10-2026 — Klikken zonder Finish-knop (Revit 2027): klik per vloer aan/uit, Esc = klaar.
- **1.4** · 07-10-2026 — Een harde crash komt nu als "Vastgelopen" in het gebruikslog.
- **1.3** · 03-09-2026 — Schuine kolommen krijgen ook een vloergat, over de hele vloerdikte.
- **1.1** · 21-07-2026 — Marge rond het gat instelbaar (standaard 10 mm); ronde kolommen krijgen een vierkant gat.
- **1.0** · 21-07-2026 — Al in gebruik: maakt vloergaten waar een kolom door de vloer gaat.

## Levels + Aanzichten

### Levels Verbergen
*huidige versie 1.10*
- **1.10** · 30-10-2026 — Naar 01_SCI. Liggen koppen na het verbergen te dicht op elkaar, dan krijgt de onderste een elbow.
- **1.6** · 13-10-2026 — Van 03_R&D naar 02_Beta, met opslaan-vraag bij de start.
- **1.5** · 09-10-2026 — Regels bijgesteld op wat telt als "level in beeld"; schuin weglopende elementen tellen niet mee.
- **1.2** · 09-10-2026 — Nieuwe knop: verbergt levels die in de view niets raken. Shift+klik zet ze weer aan.

### Level Erboven / Level Eronder
*huidige versie 1.2 (beide knoppen)*
- **1.2** · 09-10-2026 — Van 02_Beta naar 01_SCI.
- **1.1** · 17-09-2026 — Naar 02_Beta, met opslaan-vraag bij de start.
- **1.0** · 17-09-2026 — Nieuwe knoppen.

### As Aanzichten
*huidige versie 1.6*
- **1.6** · 13-10-2026 — "Aanklikken in model" zonder Finish-knop (Revit 2027): klik per as aan/uit, Esc = klaar.
- **1.5** · 09-10-2026 — Van 02_Beta naar 01_SCI.
- **1.4** · 06-10-2026 — Een staande as kijkt standaard van links naar rechts. "Kijkrichting omkeren" doet het andersom.
- **1.3** · 16-09-2026 — Naar 02_Beta. Kijkrichting verbeterd ten opzichte van het oude Dynamo-script.
- **1.0** · 16-09-2026 — Nieuwe knop, vervangt Dynamo "022 As Aanzichten".

### Wand Aanzichten
*huidige versie 1.3*
- **1.3** · 13-10-2026 — "Aanklikken in model" zonder Finish-knop (Revit 2027): klik per wand aan/uit, Esc = klaar.
- **1.2** · 09-10-2026 — Van 02_Beta naar 01_SCI.
- **1.1** · 16-09-2026 — Nieuwe knop: per wand een aanzicht plus een horizontale en verticale doorsnede. Vervangt Dynamo "023".

## Stramien

### Stramienbollen (alle zes: alle aan/uit, boven aan/uit, onder aan/uit)
*huidige versie 1.3*
- **1.3** · 09-10-2026 — Zijn er stramienen geselecteerd, dan worden alleen die aangepast.
- **1.2** · 05-10-2026 — Werkt ook op views of sheets die je in de Project Browser selecteert, zonder ze te openen.
- **1.1** · 23-07-2026 — Werkt nu ook in een gewone view, niet alleen op een sheet.
- **1.0** · 21-07-2026 — Al in gebruik.

## Tools

### Plot
*huidige versie 2.18*
- **2.18** · 20-10-2026 — De RVT-kopie krijgt de naam van het centrale model. Bij Verzenden staat de tekeningenlijst niet meer standaard aan in de DWG-lijst.
- **2.16** · 02-10-2026 — Na een interne-controleprint kan de Bluebeam-set worden bijgewerkt, met de opmerkingen van de vorige revisie.
  Fout "Changing the active view…" bij meerdere bladen opgelost.
- **2.12** · 10-09-2026 — IFC: gelinkte modellen gaan alleen mee als de IFC-setup dat zegt.
- **2.11** · 10-09-2026 — Meer details in het gebruikslog (terugval naar C:\Revit plot, printer).
- **2.10** · 09-09-2026 — Bestandsgrootte en aantal IFC-elementen in het gebruikslog.
- **2.9** · 08-09-2026 — IFC: data uit gelinkte modellen kwam niet mee terwijl de setup dat wel zei; opgelost.
- **2.7** · 04-09-2026 — Uit 02_Beta ("Plot v4"): voortgangsbalk tijdens de IFC-export. Een crash komt in het gebruikslog.
- **2.4.1** · 24-08-2026 — IFC-setup viel bij een view-wissel terug op de standaard van Revit; opgelost.
- **2.4** · 30-07-2026 — DWG-export gaat automatisch mee bij Verzenden.
- **2.3** · 28-07-2026 — DWG-export ruimt de losse png-bestanden op.
- **2.2** · 28-07-2026 — IFC-export per gebouw op de juiste site.
- **1.5** · 27-07-2026 — Bluebeam opent weer goed na de PDF-export.
- **1.3–1.4** · 21/23-07-2026 — Logging opgeschoond en uitleg (tooltip) bijgewerkt.
- **1.2** · 21-07-2026 — Al in gebruik: plot PDF's via Bluebeam en maakt IFC/DWG/RVT.

### Toolboek
*huidige versie 1.0*
- **1.0** · 16-09-2026 — Nieuwe knop: opent de PDF met uitleg over alle knoppen (01_SCI of 02_Beta).

### Sheet Fase
*huidige versie 1.4*
- **1.4** · 09-10-2026 — Van 02_Beta naar 01_SCI.
- **1.3** · 05-10-2026 — Vinkje om de fase op het titelblok mee te zetten (bv. DO → TO).
- **1.2** · 16-09-2026 — Naar 02_Beta, met opslaan-vraag bij de start.
- **1.1** · 16-09-2026 — Fout opgelost waardoor geen enkel sheetnummer werd aangepast.
- **1.0** · 16-09-2026 — Nieuwe knop: wisselt de fase vooraan in de sheetnummers. Vervangt Dynamo "014".

### SCIda Invoer
*huidige versie 1.3*
- **1.3** · 09-10-2026 — Van 02_Beta naar 01_SCI.
- **1.2** · 17-09-2026 — Naar 02_Beta, met opslaan-vraag bij de start.
- **1.1** · 17-09-2026 — Nieuwe knop: vult Project Information vanuit SCIDa.xlsm. Vervangt Dynamo "400".

### AutoSave
*huidige versie 1.1*
- **1.1** · 27-07-2026 — Nieuwe knop: slaat het model automatisch op met een instelbaar interval.
  Sinds 09-10-2026 in 01_SCI.

### Project Notitie
*huidige versie 1.8*
- **1.8** · 16-09-2026 — Crash bij Opslaan opgelost.
- **1.7** · 28-08-2026 — Kleine correctie aan de opslag op de achtergrond.
- **1.6** · 24-07-2026 — Het venster blijft stabiel open terwijl je in Revit doorwerkt.
- **1.5** · 23-07-2026 — Je kunt in Revit doorwerken terwijl het notitievenster openstaat.
- **1.4** · 21-07-2026 — Logging opgeschoond.
- **1.0** · 21-07-2026 — Al in gebruik: notities over projectkeuzes, opgeslagen in het Revit-bestand zelf.

### Projectmap
*huidige versie 1.0*
- **1.0** · 27-07-2026 — Nieuwe knop: opent de projectmap in Verkenner, ook vanuit een lokale kopie.
  Sinds 09-10-2026 in 01_SCI.

## View

### Link Zichtbaarheid
*huidige versie 1.2*
- **1.2** · 07-10-2026 — Een harde crash komt nu als "Vastgelopen" in het gebruikslog.
- **1.1** · 01-10-2026 — Zet het vinkje bij de link in VV > Revit Links van de template, zodat collega's het terugzien.
- **1.0** · 21-07-2026 — Al in gebruik: link aan/uit voor meerdere view templates tegelijk.

### RVTLinks aan / RVTLinks uit
*huidige versie 1.2 (beide knoppen)*
- **1.2** · 01-10-2026 — Werkt via het vinkje in VV > Revit Links van de view template. "Aan" ruimt ook oude verborgen links op.
- **1.0** · 21-07-2026 — Al in gebruik.

### Reference planes (Toggle in actieve view / Uit in alle views)
*huidige versie 1.0 (beide knoppen)*
- **1.0** · 21-07-2026 — Al in gebruik. Geen wijzigingen.

## Staal Tools

### S235
*huidige versie 1.2*
- **1.2** · 14-10-2026 — Structural Material wordt nu SCI_Staal_S235 (was leeg).
- **1.1** · 23-07-2026 — Alleen staal krijgt de staalkwaliteit, andere materialen niet meer per ongeluk.
- **1.0** · 21-07-2026 — Al in gebruik.

### S275 / S355
*huidige versie 1.1 (beide knoppen)*
- **1.1** · 23-07-2026 — Alleen staal krijgt de staalkwaliteit. Sinds 09-10-2026 als stack in plaats van pulldown.
- **1.0** · 21-07-2026 — Al in gebruik.

### Leeg staal naar S235
*huidige versie 1.3*
- **1.3** · 30-10-2026 — Van 02_Beta naar 01_SCI.
- **1.2** · 14-10-2026 — Nieuwe knop: zet alle stalen liggers en kolommen zonder materiaal op SCI_Staal_S235.

### Lock Stramien
*huidige versie 5.8.2*
- **5.8.2** · 07-10-2026 — Een harde crash komt nu als "Vastgelopen" in het gebruikslog.
- **5.8.1** · 16-09-2026 — Rapport zegt bovenaan "draai dit in een plattegrond".
- **5.8.0** · 04-09-2026 — In een aanzicht geen kansloze Align-pogingen meer.
- **5.6.3–5.7.0** · 29-07-2026 — Minder crashes: pauze tussen de Align-pogingen.
- **5.2.0** · 23-07-2026 — Crash opgelost die een transactie open liet staan.
- **5.1.0** · 21-07-2026 — Al in gebruik: lockt kolommen aan het stramien zonder ze te verplaatsen.

### Unlock Stramien
*huidige versie 2.1.1*
- **2.1.1** · 07-10-2026 — Een harde crash komt nu als "Vastgelopen" in het gebruikslog.
- **2.1.0** · 21-07-2026 — Al in gebruik: haalt de locks van Lock Stramien weer weg.

### Select ongelockte kolommen
*huidige versie 1.0.1*
- **1.0.1** · 07-10-2026 — Een harde crash komt nu als "Vastgelopen" in het gebruikslog.
- **1.0.0** · 21-07-2026 — Al in gebruik: selecteert stalen kolommen zonder lock.

### refplane
*huidige versie 1.1*
- **1.1** · 29-07-2026 — Werkte niet op Revit 2026/2027; opgelost.
- **1.0** · 21-07-2026 — Al in gebruik: kleurt liggers zonder werkvlak rood.

### resetoverride
*huidige versie 1.1*
- **1.1** · 29-07-2026 — Werkte niet op Revit 2026/2027; opgelost.
- **1.0** · 21-07-2026 — Al in gebruik: haalt de rode kleur van refplane weer weg.

### Allow join / Disallow join
*huidige versie 1.0 (beide knoppen)*
- **1.0** · 21-07-2026 — Al in gebruik. Geen wijzigingen.

## Tag & Maatvoering

### AutoDim Detail
*huidige versie 1.29*
- **1.29** · 30-10-2026 — De schil van een breedplaatvloer krijgt geen maat en geen peilmaat meer.
- **1.26–1.28** · 15/16-10-2026 — Fundering zonder paal: één detailrij met totaalmaat erbuiten. Vloer links wordt ook bemaat.
  Ketens die Revit niet kan meten, worden niet meer geplaatst.
- **1.25** · 13-10-2026 — Hoogteketen en peilmaten blijven staan als een vloer tegen een kolom stopt.
- **1.24** · 09-10-2026 — Van 02_Beta naar 01_SCI.
- **1.23** · 07-10-2026 — Geen maten meer op vlakken die in het detail niet te zien zijn.
- **1.22** · 07-10-2026 — Bij één wand staat de grootste maat buitenaan.
- **1.19–1.21** · 01/02-10-2026 — Veel minder fouten na tests op echte projecten. Funderingen met een trap krijgen alle hoogtes.
- **1.17** · 11-09-2026 — Werkt goed met een gesplitste crop.
- **1.16** · 09-09-2026 — Opslaan-vraag bij de start.
- **1.7–1.15** · aug 2026 — Reeks correcties: geen maten meer op vloeren, sparingen of peilen die in het detail niet bestaan.
- **1.4–1.6** · 30-07-2026 — Peilmaten binnen de crop, geen staal/hout in de fundering, ontbrekende peilmaten opgelost.
- **1.3** · 30-07-2026 — Hernoemd van "AutoDim Sectie Y" en naar 02_Beta.
- **1.2** · 30-07-2026 — Layout overgenomen van een met de hand gemaakt detail.
- **1.0** · 21-07-2026 — Eerste versie (03_R&D): automatische maatvoering in een doorsnede.

### Tag As-Aanzichten
*huidige versie 3.19*
- **3.19** · 06-10-2026 — Logt wat er geplaatst is, om te meten wat blijft staan. Geen gedragswijziging.
- **3.18** · 05-10-2026 — Staven van een truss krijgen geen tag; de truss zelf wel.
- **3.17** · 24-09-2026 — Geen tags meer op liggers achter de far clip. Werkt goed in gedraaide views; vinkje "botscontrole".
- **3.14–3.16** · 15-09-2026 — Schuine vloeren duwen tags niet meer omhoog. Kolomtags dicht naast elkaar overlappen niet meer.
- **3.12–3.13** · 10-09-2026 — Werkt goed met een gesplitste crop.
- **3.4–3.11** · 08-09-2026 — Strippen worden altijd getagd, de striptag komt naast de liggertag.
- **3.2–3.3** · 04-09-2026 — Hout-fix; strippen taggen tijdelijk als vinkje.
- **3.1** · 28-08-2026 — Alleen nieuwbouw wordt getagd.
- **3.0** · 26-08-2026 — Kolomtags aan de kant waar ruimte is, op één lijn per bouwlaag.
- **2.9** · 29-07-2026 — Werkte niet op Revit 2026/2027; opgelost.
- **2.1–2.8** · 27-07-2026 — Schuine kolommen getagd op de voet in plaats van halverwege.
- **2.0** · 23-07-2026 — Geselecteerde elementen worden overgeslagen; hulpstukken (wapening, koppelstaven) niet meer getagd.
- **1.2–1.7** · 21-07-2026 — Al in gebruik: tagt staal in aanzichten. Vervangt Dynamo "042".

### Tag Details
*huidige versie 1.36*
- **1.36** · 28-10-2026 — Vloerkoppeling krijgt de juiste tag, afhankelijk van "excentrisch".
- **1.35** · 09-10-2026 — Van 02_Beta naar 01_SCI.
- **1.33–1.34** · 01/02-10-2026 — Geen tags meer op kolommen van een hogere bouwlaag of op strips achter het snijvlak.
- **1.15** · 11-09-2026 — Werkt goed met een gesplitste crop.
- **1.14** · 09-09-2026 — Opslaan-vraag bij de start.
- **1.13** · 31-08-2026 — Van 03_R&D naar 02_Beta.
- **1.1–1.12** · aug 2026 (03_R&D) — Afgeleid van Tag As-Aanzichten en afgesteld op details: hout overgeslagen, tags dichter bij het profiel, geen overlap.

### Kolommen Taggen
*huidige versie 1.17*
- **1.17** · 30-10-2026 — Tag 800 mm boven/onder (1:100). Twee kolommen naast elkaar: tags niet meer kruiselings. Kijkt naar de View Range.
- **1.16** · 20-10-2026 — Vinkje "Botscontrole": uit = elke tag op zijn standaardplek.
- **1.14–1.15** · 09-10-2026 — Tagafstand instelbaar en per gebruiker onthouden. Knik in de lijn als hij te steil wordt.
- **1.13** · 09-10-2026 — Van 02_Beta naar 01_SCI.
- **1.12** · 07-10-2026 — Lijn weer "Attached" (makkelijker met de hand te verschuiven); tagafstand per schaal.
- **1.11** · 07-10-2026 — Geen onterechte "Vastgelopen" meer in het gebruikslog.
- **1.10** · 06-10-2026 — Koudebrugonderbrekers overslaan; kortere melding.
- **1.9** · 06-10-2026 — Geen tags meer op kolommen die de view niet toont.
- **1.8** · 01-10-2026 — Altijd de decimale kolomtag-familie, zoals het team tagt.
- **1.7** · 24-09-2026 — Werkt goed in een gedraaide plattegrond; tags uit elkaar.
- **1.6** · 18-09-2026 — Tagafstand schaalt mee met de schaal van de view.
- **1.5** · 18-09-2026 — Lengte van het streepje past bij de tekst.
- **1.4** · 11-09-2026 — Werkt goed met een gesplitste crop.
- **1.3** · 09-09-2026 — Opslaan-vraag bij de start.
- **1.2** · 28-07-2026 — Nieuwe knop: tagt kolommen in de plattegrond (onder/doorgaand/boven). Vervangt Dynamo "043a/b".

### Framing Taggen
*huidige versie 1.13*
- **1.13** · 30-10-2026 — Melding als een tagfamilie ontbreekt, met de keuze om hem te laden.
- **1.12** · 28-10-2026 — Vloerkoppeling krijgt de juiste tag, afhankelijk van "excentrisch".
- **1.11** · 09-10-2026 — Van 02_Beta naar 01_SCI.
- **1.10** · 07-10-2026 — Geen onterechte "Vastgelopen" meer in het gebruikslog.
- **1.8–1.9** · 05-10-2026 — Trusses krijgen één tag, de staven niet. Vinkje "botscontrole".
- **1.7** · 01-10-2026 — Veel minder fouten na tests op echte projecten (strips, hoeklijnen, raveelijzers).
- **1.6** · 24-09-2026 — Poeren, stroken, opstort en vloerkoppelingen krijgen een tag; tags botsen niet meer.
- **1.5** · 22-09-2026 — Houten liggers krijgen geen tag (vinkje).
- **1.4** · 09-09-2026 — Opslaan-vraag bij de start.
- **1.3** · 28-07-2026 — Nieuwe knop: tagt liggers in de plattegrond. Vervangt Dynamo "041".

### Wapening Taggen
*huidige versie 1.4*
- **1.4** · 30-10-2026 — Van 02_Beta naar 01_SCI.
- **1.3** · 28-10-2026 — Naar 02_Beta na een geslaagde test.
- **1.2** · 28-10-2026 — Tweede wapeningslaag onder/boven krijgt ook een tag.
- **1.1** · 28-10-2026 — Herkent de huidige funderingsbalk-familie.
- **1.0** · 28-10-2026 — Nieuwe knop: tagt wapening in een funderingsbalk-detail. Vervangt Dynamo "203".

### Stramienen Maatvoeren
*huidige versie 1.10*
- **1.10** · 30-10-2026 — In plattegronden ligt de keten nu vlak bij de stramienbol.
- **1.9** · 09-10-2026 — Van 02_Beta naar 01_SCI.
- **1.8** · 22-09-2026 — Overbodige diagnoseregel uit het venster.
- **1.3–1.7** · 21/22-09-2026 — Werkt ook in as-aanzichten en op meerdere views tegelijk; meet vanaf de bol.
- **1.2** · 17-09-2026 — Nieuwe knop: maatketens langs de stramienen. Vervangt Dynamo "045".

### Tags Verwijderen
*huidige versie 1.2*
- **1.2** · 09-10-2026 — Van 02_Beta naar 01_SCI.
- **1.1** · 09-09-2026 — Opslaan-vraag bij de start.
- **1.0** · 31-08-2026 — Nieuwe knop: verwijdert alle tags uit de views op een sheet.

### Maatvoering Verwijderen
*huidige versie 1.2*
- **1.2** · 09-10-2026 — Van 02_Beta naar 01_SCI.
- **1.1** · 25-09-2026 — Nieuwe knop: verwijdert alle maatvoering uit de views op een sheet.

## Linkedmodels

### Align Scopebox
*huidige versie 1.1*
- **1.1** · 07-10-2026 — Een harde crash komt nu als "Vastgelopen" in het gebruikslog.
- **1.0** · 21-07-2026 — Al in gebruik: draait een scope box evenwijdig aan een stramien.

### Copy scopebox from link
*huidige versie 1.1*
- **1.1** · 07-10-2026 — Een harde crash komt nu als "Vastgelopen" in het gebruikslog.
- **1.0** · 21-07-2026 — Al in gebruik: kopieert scope boxes uit de links.

### Batch Link
*huidige versie 1.1*
- **1.1** · 07-10-2026 — Een harde crash komt nu als "Vastgelopen" in het gebruikslog.
- **1.0** · 21-07-2026 — Al in gebruik: linkt meerdere RVT's tegelijk via Shared Coordinates.

## Materialen en eigenschappen

### Beton (C20/25, C30/37, C45/55, Reset)
*huidige versie 1.1*
- **1.1** · 23-07-2026 — Alleen beton krijgt de betonkwaliteit, andere materialen niet meer per ongeluk.
- **1.0** · 21-07-2026 — Al in gebruik.

### Hout (C18, C24, GL24h, GL28h, Reset)
*huidige versie 1.1*
- **1.1** · 23-07-2026 — Alleen hout krijgt de houtkwaliteit. C24 slaat in een balksysteem alleen echt houten balken over.
- **1.0** · 21-07-2026 — Al in gebruik.

### Kalkzandsteen (CS12 t/m CS44, Reset)
*huidige versie 1.0*
- **1.0** · 21-07-2026 — Al in gebruik. Geen wijzigingen.

### Brandwerendheid (30, 60, 90, 120 min, Reset)
*huidige versie 1.0*
- **1.0** · 21-07-2026 — Al in gebruik. Geen wijzigingen.

### Milieuklasse (XC1–XC4, XD1, XD3, XF1, XF2, Doc)
*huidige versie 1.0*
- **1.0** · 21-07-2026 — Al in gebruik. Geen wijzigingen.

### Structural (Dragend, Niet dragend, IsExternal, IsInternal)
*huidige versie 1.1*
- **1.1** · 21-07-2026 — Al in gebruik. Dragend/Niet dragend werkt alleen nog op liggers en kolommen.

---

# 02_Beta

## Palen

### Bovenkant paal aansluiten
*huidige versie 1.3*
- **1.3** · 09-10-2026 — Van 01_SCI terug naar 02_Beta (Palen), met opslaan-vraag bij de start.
- **1.2** · 07-10-2026 — Een harde crash komt nu als "Vastgelopen" in het gebruikslog.
- **1.1** · 21-07-2026 — Instelbare offset: de paalkop mag iets onder de vloer eindigen.
- **1.0** · 21-07-2026 — Al in gebruik: sluit de paalkop aan op de onderkant van vloer of balk.

### NAP Wijzigen
*huidige versie 1.1*
- **1.1** · 16-09-2026 — Nieuwe knop: zet het NAP-peil in Project Information en in de schedulenamen. Vervangt Dynamo "016".

### Paal Kleurcode
*huidige versie 1.3*
- **1.3** · 05-10-2026 — Bestaande palen worden overgeslagen.
- **1.2** · 05-10-2026 — Kleurcode en plaatje liepen een plek uit de pas; opgelost.
- **1.1** · 16-09-2026 — Nieuwe knop: kleurcode per paalpuntniveau. Vervangt Dynamo "101a/b".

### Paalcode
*huidige versie 1.3*
- **1.3** · 05-10-2026 — Groepeert op bruto lengte en bovenkant; palen met ander afstortniveau krijgen een eigen code.
- **1.2** · 18-09-2026 — Nummert elke run opnieuw vanaf PC1.
- **1.1** · 16-09-2026 — Nieuwe knop: bestellengte en paalcode PC1, PC2 … Vervangt Dynamo "106".

### Paal Nummeren
*huidige versie 1.3*
- **1.3** · 13-10-2026 — Klikken zonder Finish-knop (Revit 2027): klik per paal aan/uit, Esc = klaar.
- **1.2** · 05-10-2026 — Bestaande palen worden overgeslagen.
- **1.1** · 16-09-2026 — Nieuwe knop: nummert palen op positie, optioneel met tag. Vervangt Dynamo "103".

### Sonderingen
*huidige versie 1.1*
- **1.1** · 16-09-2026 — Nieuwe knop: zet sonderingssymbolen uit het Excel in de view. Vervangt Dynamo "104".

---

De ontwikkelknoppen van 03_R&D staan in `Changelog R&D.md`.
