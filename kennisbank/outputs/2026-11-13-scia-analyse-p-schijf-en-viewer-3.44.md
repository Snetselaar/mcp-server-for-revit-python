# SCIA-bestanden van P: geanalyseerd, viewer 3.44

Datum: 13-11-2026. Vraag: zoek 5 tot 10 relevante SCIA-projecten vanaf nummer 8000 op P:, zet een kopie op de eigen schijf,
analyseer ze en pas de SCI-Viewer aan met wat het oplevert. Aanvulling: de kerk in Kesteren.

## Scan en keuze
- P: alleen gelezen. 1.386 `.esa`-bestanden in 259 projecten (8000 en hoger).
- Twaalf kopieën in `C:\Users\S-WOU1A\Documents\SCIA-analyse` (met `BRON.txt`): 8020 dak, 8029 parkeerdek, 8444 staal
  cassetteplafond, 9096 luifel, 9204 plaatfundering, 9292 kern, 9371 liftput, 9429 vloer op palen, 9475 bovenbouw staal en
  hout, 9537 liftwand, en twee van 8543 kerk Kesteren (staalconstructie 2026, 746 MB; rekenmodel uit Revit 2023, 79 MB).
- SCIA-versies in de set: 20.0, 21.0, 22.1, 25.0, 26.0 en 2027.0.

## Wat de lezer al goed deed
Knopen, staven, doorsneden, materialen, raster, puntsteunen, platen en sparingen klopten op alle twaalf (kerk: 875 staven,
86 profielen). Twee fouten gevonden: een steunpunt dat alleen horizontaal vasthoudt werd als paal geteld (9429: 57 in plaats
van 54), en steunen op een tussenknoop werden overgeslagen (9096: 21 in plaats van 23).

## Nieuw ontcijferd (vier agents, elk met Python-bewijs op alle bestanden)
| Onderdeel | Uitkomst | Zekerheid |
|---|---|---|
| Scharnieren op staafeinden | vrij/verend per richting, met veerstijfheid | hard: alle records, verwijzingen bestaan |
| Lijn-, vlak- en staafsteunen | 82 lijnsteunen, 34 vlaksteunen (bedding C1z) in de eerste tien | hard |
| Belastinggevallen, groepen, combinaties | 158 gevallen; factoren 1,35 / 1,5 / 0,9 | hard; UGT/BGT uit de namen afgeleid |
| Lijn-, punt- en vlaklasten | kerk: 103.288 en 76.556 lasten; wind 0° en 180° geven +1302 en −1302 kN | hard: aantal per geval gelijk aan de lijst in het geval |
| Projectkop, versie, norm, lagen | 12 van 12 gelijk aan het XML-blok achterin | hard |
| Plaatmateriaal, plaat/wand, deelgebied | 68 van 68 | hard; deelgebied maar één voorbeeld |
| Staaftype en laag | 2.738 van 2.738 | hard voor balk/kolom/gording |

Recordopbouw met offsets: zie de rapporten in de sessie en de patches (`scia/feat/patch_{kop,scharnier,steun,last}.py` in de
scratchpad van de sessie; de code staat in `parseEsa` van de viewer, blokken "3.44").

## In de viewer (3.44, live)
- Paneel **Ondersteuningen** en getekende lijnsteunen (arcering langs de rand), vlaksteun als tint met C1z in het label.
- Paneel **Belastingen**: tabel per geval met ΣFx/ΣFy/ΣFz; klik op een geval tekent de lasten. Paneel **Combinaties**.
- Staafpaneel: scharniertekst bij begin en eind, type en laag. Bestandspaneel: SCIA-versie, norm, lagen, projectgegevens.
- Leestijd: 0,1 tot 0,2 s per gewoon bestand; kerk 79 MB 0,7 s, kerk 746 MB 1,5 s.

## Niet gelezen
- Vrije lasten en momenten (alleen geteld), lokale vlaklasten en lijnlasten op een plaatrand staan niet in de som.
- Uitlijning en excentriciteit van staven: ruwe waarden, betekenis niet te toetsen zonder SCIA.
- Profielen THQ en SFB hebben geen vorm. Namen met tekens buiten ASCII leest `naNaam` niet (9475: 69 staven heten "_").
- Geen SCIA beschikbaar om tegen te controleren: alles berust op interne samenhang van de bestanden.
