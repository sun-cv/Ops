# Operations & Infrastructure
Personal infrastructure for system automation and operational tooling.

## Structure
```
Ops/
├── Environment/        # Dotfiles and environment config (shell, nvim)
├── Services/           # Persistent running services (PM2 etc.), self-contained
└── Tasks/              # Scheduled and on-demand tasks, self-contained
```

## Environment
Personal environment configuration including shell profile and Neovim. This is the dotfiles layer — sourced at shell startup.

- **Nvim** - Neovim config in Lua, structured across bootstrap, plugins, settings, and profile
- **Powershell** - Shell profile, modules, and bootstrap

## Services
Persistent processes with a managed lifecycle. Each service is self-contained with its own config and startup scripts:

- **PM2** - Launches and manages the app ecosystem on startup

## Tasks
Scheduled and on-demand jobs. Each task is self-contained with its own config:

- **GFSBackup** - Grandfather-Father-Son rotation backups to X:\ (daily)
- **GFSBackupVerification** - Validates backup integrity and restorability (weekly)
- **SyncStaging** - Mirrors critical folders to Z:\ (every 4 hours)

## Notes
- All backup scripts use robocopy with `/FFT` for FAT file time tolerance
- Runtime data (logs, backups) is excluded from version control
- Configs may reference local paths
