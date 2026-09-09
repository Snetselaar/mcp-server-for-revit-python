#!/usr/bin/env bash
# SessionStart-hook voor de kennisbank.
#
# Telt de bestanden in kennisbank/raw/ die volgens kennisbank/memory.md nog niet
# verwerkt zijn, en kijkt hoe lang de laatste health check geleden is.
# Geeft JSON terug met een systemMessage voor de gebruiker en additionalContext
# voor Claude. Is er niets te melden, dan blijft de uitvoer leeg en merkt
# niemand er iets van.
#
# Faalt nooit hard: bij een ontbrekende map of onverwacht formaat exit 0 zonder
# uitvoer. Een hook die een sessie blokkeert is erger dan een hook die zwijgt.

set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." 2>/dev/null && pwd)" || exit 0
KB="$ROOT/kennisbank"
RAW="$KB/raw"
MEMORY="$KB/memory.md"

[ -d "$RAW" ] || exit 0

# --- onverwerkte bestanden in raw/ -------------------------------------------

onverwerkt=""
aantal=0

while IFS= read -r pad; do
    naam="$(basename "$pad")"
    case "$naam" in
        README.md|.*) continue ;;
    esac
    # Al genoemd in het logboek? Dan is het verwerkt.
    if [ -f "$MEMORY" ] && grep -qF "$naam" "$MEMORY"; then
        continue
    fi
    naam="${naam//\\/}"
    naam="${naam//\"/}"
    aantal=$((aantal + 1))
    if [ "$aantal" -le 5 ]; then
        onverwerkt="${onverwerkt}\\n  - ${naam}"
    fi
done < <(find "$RAW" -maxdepth 1 -type f 2>/dev/null | sort)

if [ "$aantal" -gt 5 ]; then
    onverwerkt="${onverwerkt}\\n  - ... en $((aantal - 5)) meer"
fi

# --- dagen sinds de laatste health check --------------------------------------

dagen=""
laatste="$(find "$KB/outputs" -maxdepth 1 -name '*-healthcheck.md' 2>/dev/null | sort | tail -1)"
if [ -n "$laatste" ]; then
    datum="$(basename "$laatste" | cut -c1-10)"
    toen="$(date -d "$datum" +%s 2>/dev/null)" || toen=""
    if [ -n "$toen" ]; then
        dagen=$(( ( $(date +%s) - toen ) / 86400 ))
    fi
fi

# --- bericht opbouwen ---------------------------------------------------------

regels=""

if [ "$aantal" -gt 0 ]; then
    if [ "$aantal" -eq 1 ]; then
        regels="Kennisbank: 1 onverwerkt bestand in raw/ — draai /kb-verwerk${onverwerkt}"
    else
        regels="Kennisbank: ${aantal} onverwerkte bestanden in raw/ — draai /kb-verwerk${onverwerkt}"
    fi
fi

if [ -n "$dagen" ] && [ "$dagen" -ge 30 ]; then
    [ -n "$regels" ] && regels="${regels}\\n"
    regels="${regels}Laatste health check was ${dagen} dagen geleden — draai /kb-check"
elif [ -z "$dagen" ] && [ -d "$KB/outputs" ]; then
    [ -n "$regels" ] && regels="${regels}\\n"
    regels="${regels}Nog geen health check gedraaid — draai /kb-check"
fi

[ -n "$regels" ] || exit 0

printf '{"systemMessage":"%s","hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"%s"},"suppressOutput":true}\n' \
    "$regels" "$regels"
