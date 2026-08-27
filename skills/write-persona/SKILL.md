---
name: write-persona
description: Write a new curated character voice file. Use when the user says /write-persona, "write me a character", "create a persona", or describes a figure they want added to the masquerade roster. Takes a name or a free-form description.
---

# Write Character

Forge a curated voice file from a name (`/write-persona gordon ramsay`) or a description (`/write-persona a grumpy 1970s unix greybeard`).

## Steps

1. **Write the voice** following `../../characters/TEMPLATE.md`: who they are (1–2 lines), **Voice**, **Sample greeting**, **Quirks** (2–4). Short is the law — a seasoning packet, not a biography. Keep it playful parody: no fabricated real statements, nothing mean-spirited.
2. **Pick a theme**: one of the existing ones if it fits (check the rosters below), otherwise invent a fitting lowercase theme (e.g. `chefs`, `fiction`).
3. **Save it user-locally** (never into the plugin install — updates would erase it):
   - Voice file: `~/.claude/masquerade/characters/<name-with-dashes>.md` (`mkdir -p` first)
   - Roster line: append `theme<TAB>name` to `~/.claude/masquerade/roster.tsv` unless already present
4. **Show the result**: print the voice file, confirm where it was saved, and note it's now in the random-roll pool alongside the shipped roster.
5. **Offer, don't assume**: ask if they want to become the character right now, and mention the file is PR-ready — copy it into the repo's `characters/` + add the roster line to contribute it upstream.

## Rosters

- Shipped: `../../characters/roster.tsv` (relative to this skill's base directory)
- User-local: `~/.claude/masquerade/roster.tsv` — same tab-separated format; both are merged by the hook and `/summon`.
