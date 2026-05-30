# Claude configuration (`ai/claude`)

This directory is the **single source of truth** for the curated Claude Code configuration:
rules, permissions, skills, agents, commands, and hooks. It is version-controlled in `ops`.

It is **not** the live config directory. The live directory is a real `~/.claude` folder in the
user profile; the curated entries here are symlinked into it. Runtime state and secrets live
only in `~/.claude` and never enter this repo.

## Source-vs-runtime model

```
ops/ai/claude/   ← THIS dir. Curated SOURCE, 100% tracked in git.
       ▲
       │  per-item symlinks (created once by scripts/link.ps1)
       │
~/.claude/       ← Live config dir. A REAL folder, NOT in git.
   ├── .credentials.json  history.jsonl  mcp-needs-auth-cache.json   (runtime — never git)
   ├── sessions/  shell-snapshots/  file-history/  telemetry/        (runtime dirs)
   │   projects/  backups/  cache/  paste-cache/  ide/  session-env/  plans/  tasks/
   ├── CLAUDE.md      → ops/ai/claude/CLAUDE.md      (file symlink)
   ├── settings.json  → ops/ai/claude/settings.json  (file symlink)
   ├── instructions/  → ops/ai/claude/instructions   (dir symlink)
   └── skills/ agents/ commands/ hooks/ output-styles/   (dir symlinks)
```

**Why:** the live dir is where Claude writes secrets (`.credentials.json`) and ephemeral state.
Keeping those physically outside the repo makes it *structurally impossible* to commit a secret —
the `.gitignore` here is a fail-safe allowlist, not a fragile blocklist. This mirrors the
established "symlink configs into `ops`" pattern.

## Tracked vs runtime contract

| Tracked here (curated)                                    | Runtime (lives in `~/.claude`, never tracked) |
| --------------------------------------------------------- | --------------------------------------------- |
| `CLAUDE.md`, `settings.json`                              | `.credentials.json`, `mcp-needs-auth-cache.json` |
| `instructions/`, `skills/`, `agents/`                     | `history.jsonl`, `sessions/`, `session-env/`  |
| `commands/`, `hooks/`, `output-styles/`                   | `shell-snapshots/`, `file-history/`, `ide/`   |
| `README.md`, `scripts/`, `.gitignore`                     | `telemetry/`, `projects/`, `backups/`, `cache/`, `paste-cache/`, `plans/`, `tasks/` |

Memory (`projects/<slug>/memory/`) is intentionally **local only** — not tracked.

## Editing caveat (two files only)

Directory symlinks are robust: Claude writes *inside* them, never replacing the link.
The two **file** symlinks — `CLAUDE.md` and `settings.json` — can be replaced by a real file if a
tool rewrites them via atomic save (e.g. `/config` editing settings). Therefore:

- **Edit `CLAUDE.md` and `settings.json` in this source directory**, not via `/config`.
- `settings.json` is strict JSON — **no comments** (rationale is documented here instead).
- If a file symlink ever gets clobbered, re-run `scripts/link.ps1` to restore it.

## Layout

| Path              | Purpose                                                                    |
| ----------------- | -------------------------------------------------------------------------- |
| `CLAUDE.md`       | Entry point. Imports the `instructions/` files in priority order.          |
| `settings.json`   | Model, theme, effort, and the permission policy.                           |
| `instructions/`   | The behavioral rules (security, behavior, environment, tools, style).      |
| `skills/`         | Custom skills — a folder per skill (`<name>/SKILL.md`). See Authoring.      |
| `agents/`         | Subagent definitions (`<name>.md`). See Authoring.                         |
| `commands/`       | Custom slash commands (`<name>.md` → `/<name>`). See Authoring.            |
| `hooks/`          | Hook scripts, wired up in `settings.json`. See Authoring.                  |
| `output-styles/`  | Optional output styles (`<name>.md`).                                      |
| `scripts/`        | One-time setup/maintenance scripts (e.g. `link.ps1`).                      |

> The building-block directories hold a `.gitkeep` until populated. **Don't** add documentation
> `.md` files inside `commands/`, `agents/`, or `output-styles/` — every `.md` there is
> auto-discovered as a live command/agent/style. All conventions live here instead.

## Permission policy (summary)

Defined in `settings.json`. Philosophy:

- **Reads are always allowed.** `Read`/`Glob`/`Grep` and read-only Bash never prompt by default;
  the `allow` list adds read-only PowerShell cmdlets and `git` inspection so they don't prompt either.
- **File writes are never blanket-allowed.** `Edit`/`Write` stay at default, surfacing as the
  approval step (the Neovim diff popup, or a CLI prompt) — case-by-case, per the rules in `instructions/`.
- **Git writes are denied to Claude** (`git commit`, `git push`, `git reset`, `git rebase`,
  `git merge`, `git filter-repo`, `git cherry-pick`, `git revert`). Commits and pushes are writes
  to the user's GitHub and are **the user's to run** — Claude prepares changes and hands over the
  commands. (`deny` beats everything, so this can't be loosened by an allow rule.)
- **Other destructive ops always ask** (`rm`, `Remove-Item`, `git clean`).
- **Secrets are denied to context** (`Read(**/.credentials.json)`, `.env`, `*.key`, `*.pem`, keys).

Per-project write latitude belongs in that project's own `.claude/settings.local.json`, keeping
this global policy conservative.

---

## Authoring

How to add each kind of building block. New files under an already-symlinked directory are picked
up automatically. Only a brand-new *top-level* config type (a new sibling of `skills/`) needs a new
symlink — add it to `scripts/link.ps1` and re-run.

### Skills — `skills/<name>/SKILL.md`

One folder per skill (kebab-case); `SKILL.md` is required. Claude loads a skill when the request
matches its `description`, so make that line specific about *when* to use it.

```markdown
---
name: my-skill
description: Generate a release changelog from git history. Use when asked to draft release notes.
---

# My Skill

Concise, imperative instructions. Reference supporting files (kept beside SKILL.md) by relative
path. Keep each skill to a single, well-bounded capability.
```

### Agents — `agents/<name>.md`

One file per subagent. The body is its system prompt. Give each the **minimum** tools it needs.

```markdown
---
name: doc-auditor
description: Audit docs for staleness against the code. Use when asked to verify docs match code.
tools: Read, Grep, Glob
model: sonnet
---

You are a documentation auditor. Locate the relevant docs and the code they describe, then report
mismatches as a concise list. Read-only — never edit files.
```

Frontmatter: `name`, `description` (required); `tools`, `model` (optional).

### Commands — `commands/<name>.md` → `/<name>`

Subfolders namespace the command (`commands/git/sync.md` → `/git:sync`). The body is the prompt.

```markdown
---
description: Summarize what changed on the current branch versus a base branch
argument-hint: "[base-branch]"
allowed-tools: Bash(git diff *), Bash(git log *)
---

Summarize the changes on this branch compared to `${1:-main}`.

!`git diff ${1:-main}...HEAD --stat`
```

Interpolations: `$ARGUMENTS`, `$1`/`$2`/…, `` !`cmd` `` (inline shell output, needs `allowed-tools`),
`@path` (inline a file). All frontmatter fields are optional.

### Hooks — `hooks/<script>` + wiring in `settings.json`

Scripts live in `hooks/`; the wiring lives in `settings.json` under `"hooks"`. Edit that file in
this source directory (see the editing caveat).

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          { "type": "command", "command": "pwsh -NoProfile -File \"~/.claude/hooks/guard.ps1\"" }
        ]
      }
    ]
  }
}
```

Contract: the hook reads event JSON on **stdin**; **exit 0** = continue, **exit 2** = block (stderr
shown to Claude); `PreToolUse` may emit an `allow`/`deny`/`ask` decision on stdout. Keep hooks fast.
Events: `PreToolUse`, `PostToolUse`, `UserPromptSubmit`, `Stop`, `SubagentStop`, `SessionStart`,
`SessionEnd`, `Notification`, `PreCompact`. The `update-config` skill can author the wiring.

### Output styles — `output-styles/<name>.md`

```markdown
---
name: terse
description: Minimal, no preamble, answer-first
---

Answer first, in as few words as the question allows. No preamble, no restating the question.
Use lists over prose. Show code/diffs rather than describing them.
```

Activate with `/output-style`. Frontmatter `name` + `description` required.
