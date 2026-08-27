#!/usr/bin/env bash
# SessionStart hook: dresses the session as a random character from the roster.
# Config: ~/.claude/masquerade.conf, key=value lines:
#   enabled=true          # all new sessions become characters
#   shared_theme=true     # concurrent sessions draw from the same theme
#   shared_character=true # concurrent sessions are the exact same character
#   intensity=full|light  # full: in character all session; light: occasional word or sentence
conf="$HOME/.claude/masquerade.conf"
get() { grep -s "^$1=" "$conf" | tail -1 | cut -d= -f2; }

root="$(cd "$(dirname "$0")/.." && pwd)"
userdir="$HOME/.claude/masquerade"
# Shipped roster plus the user's own (written by /write-character or by hand).
rosters() { cat "$root/characters/roster.tsv" "$userdir/roster.tsv" 2>/dev/null; }

# ponytail: crude process count — any process named claude counts, like the profile it replaces
claude_count() {
    if command -v tasklist >/dev/null 2>&1; then
        tasklist 2>/dev/null | grep -ci '^claude'
    else
        pgrep -cx claude 2>/dev/null || echo 0
    fi
}

roll() { rosters | grep -v '^#' | grep -v '^[[:space:]]*$' | shuf -n 1; }

# Launcher integration: a wrapper that names the session (claude -n <name>) sets
# MASQUERADE_CHARACTER to force the same character here. Overrides everything, even enabled=.
if [ -n "$MASQUERADE_CHARACTER" ]; then
    name="$MASQUERADE_CHARACTER"
    theme=$(rosters | awk -F'\t' -v n="$name" 'tolower($2)==tolower(n){print $1; exit}')
    line="${theme:-custom}$(printf '\t')$name"
elif [ "$(get enabled)" != "true" ]; then
    exit 0
elif shared_c="$(get shared_character)"; [ "$shared_c" = "true" ] || [ "$(get shared_theme)" = "true" ]; then
    state="$HOME/.claude/masquerade-pick"
    # Reuse the stored pick while other sessions run (this session already counts as 1).
    if [ "$(claude_count)" -gt 1 ] && [ -s "$state" ]; then
        line=$(cat "$state")
        if [ "$shared_c" != "true" ]; then
            # Shared theme only: keep the theme, reroll the character within it.
            line=$(rosters | grep "^${line%%$'\t'*}$(printf '\t')" | shuf -n 1)
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

if [ "$(get intensity)" = "light" ]; then
    style="stay only faintly in character: an occasional word, aside, or single sentence in $name's voice per response at most — otherwise write as plain Claude"
else
    style="stay in character as $name for the whole session — persona voice and flavor in every response, though never at the cost of clarity or code quality"
fi
echo "MASQUERADE ACTIVE — you are $name ($theme). Open your first reply with a short greeting exactly as $name would deliver it, then $style. PERSISTENT: this persona applies to EVERY response until the session ends or the user says otherwise — after long stretches of work or context compaction, you are still $name; carry this instruction into any summary. This is playful parody: never claim to actually be this person, and drop the voice for anything serious or sensitive."

# Curated voice file wins over improvisation; user-written files win over shipped ones.
slug=$(echo "$name" | tr ' ' '-')
for voice in "$userdir/characters/$slug.md" "$root/characters/$slug.md"; do
    [ -f "$voice" ] && { echo; cat "$voice"; break; }
done
exit 0
