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
| `/character shared theme on` | Concurrent sessions share a theme — open three terminals, get three Norse gods |
| `/character shared character on` | Concurrent sessions are the exact same character — three terminals, three Odins |
| `/character shared ... off` | Every session rolls independently again |
| `/write-character <name or description>` | Claude writes a new curated character for you — see below |

Always-on mode is opt-in — installing the plugin changes nothing until you say `/character on`. See [Configuration](#configuration) for all settings.

## Configuration

All settings live in one plain-text file: **`~/.claude/masquerade.conf`** — one `key=value` per line, no quotes, anything but `true` counts as false. Edit it by hand, script it, or let the `/character` commands write it for you. Missing file = plugin fully dormant.

```ini
# ~/.claude/masquerade.conf
enabled=true
shared_theme=true
shared_character=false
```

| Key | Values | Default | Meaning |
|---|---|---|---|
| `enabled` | `true`/`false` | `false` | Master switch. When `true`, the SessionStart hook gives **every new session** a random character. When `false` (or the file is missing), the hook exits silently — `/character` still works on demand. |
| `shared_theme` | `true`/`false` | `false` | While more than one claude process is running, new sessions keep the **theme** of the first one but roll their own character within it (three terminals → three different Norse gods). When the last claude process exits, the next session rerolls the theme. |
| `shared_character` | `true`/`false` | `false` | Stronger version: concurrent sessions are the **exact same character** (three terminals → three Odins). Takes precedence over `shared_theme`, so setting both is fine. |

Command ↔ config mapping, if you'd rather not touch the file:

| Command | Writes |
|---|---|
| `/character on` / `off` | `enabled=true` / `false` |
| `/character shared theme on` / `off` | `shared_theme=true` / `false` |
| `/character shared character on` / `off` | `shared_character=true` / `false` |

**State file:** shared modes remember the current pick in `~/.claude/masquerade-pick` (`theme<TAB>name`). It's managed automatically; delete it any time to force a fresh roll. **Note:** "concurrent" is detected by counting running `claude` processes, so the shared pick resets whenever no session is left running.

## The roster

~55 figures across four themes, in [`characters/roster.tsv`](characters/roster.tsv). Voices are improvised by Claude unless a curated voice file exists in `characters/` (see [`odin.md`](characters/odin.md) for the reference example).

## Write your own characters

`/write-character gordon ramsay` — or `/write-character a grumpy 1970s unix greybeard` — makes Claude write a full voice file in the template format and save it **user-locally**:

- Voice file: `~/.claude/masquerade/characters/<name-with-dashes>.md`
- Roster line: `~/.claude/masquerade/roster.tsv` (same `theme<TAB>name` format)

Both are merged with the shipped roster automatically — your characters join the random-roll pool and always-on mode without forking the repo, and they survive plugin updates. User-local voice files override shipped ones of the same name. Everything there is hand-editable; the generated file is also PR-ready if you want to contribute it upstream.

## Contribute a character

Copy [`characters/TEMPLATE.md`](characters/TEMPLATE.md) to `characters/<name-with-dashes>.md`, write the voice, add a `theme<TAB>name` line to `roster.tsv`, open a PR. Short is good — a voice file is a seasoning packet, not a biography.

## How it works

- `/character` is a plugin skill that reads the roster and adopts the persona.
- Always-on mode is a `SessionStart` hook that injects the persona when `enabled=true` in `~/.claude/masquerade.conf` — and exits silently otherwise.
- Shared modes store the current pick in `~/.claude/masquerade-pick` and reuse it while other claude processes are running; when the last one exits, the next session rerolls.
