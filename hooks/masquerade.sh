#!/usr/bin/env bash
# SessionStart hook: dresses the session as a random character from the roster.
# Config: ~/.claude/masquerade.conf, key=value lines:
#   enabled=true          # all new sessions become characters
#   shared_theme=true     # concurrent sessions draw from the same theme
#   shared_character=true # concurrent sessions are the exact same character
conf="$HOME/.claude/masquerade.conf"
get() { grep -s "^$1=" "$conf" | tail -1 | cut -d= -f2; }
[ "$(get enabled)" = "true" ] || exit 0

root="$(cd "$(dirname "$0")/.." && pwd)"
roster="$root/characters/roster.tsv"

# ponytail: crude process count — any process named claude counts, like the profile it replaces
claude_count() {
    if command -v tasklist >/dev/null 2>&1; then
        tasklist 2>/dev/null | grep -ci '^claude'
    else
        pgrep -cx claude 2>/dev/null || echo 0
    fi
}

roll() { grep -v '^#' "$roster" | grep -v '^[[:space:]]*$' | shuf -n 1; }

shared_c="$(get shared_character)"
if [ "$shared_c" = "true" ] || [ "$(get shared_theme)" = "true" ]; then
    state="$HOME/.claude/masquerade-pick"
    # Reuse the stored pick while other sessions run (this session already counts as 1).
    if [ "$(claude_count)" -gt 1 ] && [ -s "$state" ]; then
        line=$(cat "$state")
        if [ "$shared_c" != "true" ]; then
            # Shared theme only: keep the theme, reroll the character within it.
            line=$(grep "^${line%%$'\t'*}$(printf '\t')" "$roster" | shuf -n 1)
        fi
    else
        line=$(roll)
        echo "$line" > "$state"
    fi
else
    line=$(roll)
fi

theme="${line%%$'\t'*}"
name="${line#*$'\t'}"

echo "MASQUERADE ACTIVE — you are $name ($theme). Open your first reply with a short greeting exactly as $name would deliver it, then stay lightly in character as $name for the whole session. This is playful parody: never claim to actually be this person, and drop the voice for anything serious or sensitive."

# Curated voice file wins over improvisation, if one exists.
voice="$root/characters/$(echo "$name" | tr ' ' '-').md"
[ -f "$voice" ] && { echo; cat "$voice"; }
exit 0
