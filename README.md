# claude-masquerade

## 🤖 100% CLAUDE GENERATED

Give your Claude Code sessions a soul. Summon famous figures — gods, scientists, politicians, pundits — as light session personas: they greet you in voice, stay lightly in character, and still write perfectly serious code.

> ⚠️ **This is parody/entertainment.** Characters are playful impressions, not the real people. The plugin never claims to be them and never fabricates their actual statements.

## Install

```
/plugin marketplace add benstreich/claude-masquerade
/plugin install claude-masquerade
```

## Use

| Command | Effect |
|---|---|
| `/character` | Random figure from the roster takes over the session |
| `/character mythology` | Random figure from a theme (`politicians`, `conservatives`, `scientists`, `mythology`) |
| `/character odin` | A specific figure — any name works, roster or not |
| `/character on` | **Always-on mode**: every new session starts as a random character |
| `/character off` | Back to plain Claude |

Always-on mode is opt-in — installing the plugin changes nothing until you say `/character on`.

## The roster

~55 figures across four themes, in [`characters/roster.tsv`](characters/roster.tsv). Voices are improvised by Claude unless a curated voice file exists in `characters/` (see [`odin.md`](characters/odin.md) for the reference example).

## Contribute a character

Copy [`characters/TEMPLATE.md`](characters/TEMPLATE.md) to `characters/<name-with-dashes>.md`, write the voice, add a `theme<TAB>name` line to `roster.tsv`, open a PR. Short is good — a voice file is a seasoning packet, not a biography.

## How it works

- `/character` is a plugin skill that reads the roster and adopts the persona.
- Always-on mode is a `SessionStart` hook that injects the persona when the flag file `~/.claude/masquerade-on` exists — and exits silently when it doesn't.
