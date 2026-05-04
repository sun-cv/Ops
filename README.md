# ops

Personal environment, tooling, and infrastructure — managed as a single repo.

## Structure

```
ops/
├── environment/
│   ├── ai/                 # AI tooling configs (Claude instructions, settings)
│   ├── editors/nvim/       # Neovim config (Lua, plugins, LSP, keybindings)
│   ├── platform/
│   │   ├── linux/          # WSL Arch configs (mpd, rmpc)
│   │   └── windows/        # Windows-specific (theme, color profiles)
│   ├── shells/
│   │   ├── powershell/     # Profile, functions, bootstrap, integrations
│   │   └── zsh/            # Profile, functions, bootstrap, integrations
│   └── terminal/           # Prompt config (Starship)
├── services/
│   └── pm2/                # Persistent process management (ecosystem, startup)
└── tasks/
    ├── backup/             # GFS rotation backups to X:\
    └── sync/               # Staging mirror to Z:\
```

## Environment

Dotfiles and editor config — sourced at shell startup or symlinked in place.

- **Neovim**        — Lua config structured across bootstrap, plugins, components, scripts, and profile. Plugins include LSP (Roslyn for C#), Telescope, Harpoon, Barbar, Lualine, Claude Code, and more.
- **PowerShell**    — Profile, functions, and bootstrap loader. Integrations for Starship.
- **Zsh**           — Equivalent shell setup for WSL Arch. Integrations for Starship and mpd.
- **Starship**      — Shared prompt config across both shells.
- **Platform**      — Windows theme (ExplorerBlurMica, color profiles) and WSL Arch media tooling (mpd, rmpc).
- **AI**            — Claude Code instructions and local settings.

## Services

Persistent processes with a managed lifecycle via PM2.

- **PM2**           — Launches and manages the app ecosystem on startup via Windows Task Scheduler.

## Tasks

Scheduled and on-demand jobs, each self-contained with its own scripts and scheduler XML.

- **GFS Backup**    — Grandfather-Father-Son rotation backups to `X:\` (daily)
- **GFS Verify**    — Validates backup integrity and restorability (weekly)
- **Staging Sync**  — Mirrors critical folders to `Z:\` (every 4 hours)

## Notes

- Runtime data (logs, backups) is excluded from version control
- Configs reference local paths — intended for personal use
- Backup scripts use robocopy with `/FFT` for FAT file time tolerance
