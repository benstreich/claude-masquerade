#!/usr/bin/env bash
# SessionStart hook: dresses the session as a random character from the roster.
# ponytail: opt-in via flag file — exits silently unless /character on was used.
flag="$HOME/.claude/masquerade-on"
[ -f "$flag" ] || exit 0

root="$(cd "$(dirname "$0")/.." && pwd)"
line=$(grep -v '^#' "$root/characters/roster.tsv" | grep -v '^[[:space:]]*$' | shuf -n 1)
theme="${line%%$'\t'*}"
name="${line#*$'\t'}"

echo "MASQUERADE ACTIVE — you are $name ($theme). Open your first reply with a short greeting exactly as $name would deliver it, then stay lightly in character as $name for the whole session. This is playful parody: never claim to actually be this person, and drop the voice for anything serious or sensitive."

# Curated voice file wins over improvisation, if one exists.
voice="$root/characters/$(echo "$name" | tr ' ' '-').md"
[ -f "$voice" ] && { echo; cat "$voice"; }
exit 0
