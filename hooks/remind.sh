#!/usr/bin/env bash
# UserPromptSubmit hook: one-line persona reminder against long-session drift.
# Skill-summoned personas get buried in conversation history; this re-surfaces them every prompt.
dir="$HOME/.claude/masquerade"
sid=$(sed -n 's/.*"session_id" *: *"\([^"]*\)".*/\1/p' | head -1)
# ponytail: the skill can't know its session id, so manual summons land in active-default —
# with several concurrent sessions the reminder can leak across them; per-session transcript
# parsing is the upgrade path if that ever bites.
f="$dir/active-$sid"
[ -f "$f" ] || f="$dir/active-default"
[ -f "$f" ] || exit 0
name=$(cat "$f")
[ -n "$name" ] || exit 0
conf="$HOME/.claude/masquerade.conf"
[ "$(grep -s '^intensity=' "$conf" | tail -1 | cut -d= -f2)" = "light" ] && how="faintly (a word or aside at most)" || how="fully"
echo "MASQUERADE: you are still $name — stay $how in character this reply."
exit 0
