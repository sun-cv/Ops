# Operations & Infrastructure

Personal infrastructure for system automation, backups, and operational tooling.

## Structure

```
Ops/
├── Automation/         # Automated tasks and scripts
│   ├── Tasks/          # Scheduled automation tasks
│   └── Startup/        # System startup scripts
├── Backups/            # Project created backups
├── Config/             # Ops and env config for tasks
└── Logs/               # System and application logs
```

## Automation

### Tasks
Scheduled tasks that run periodically via Task Scheduler:

- **FileSync** - Mirrors critical folders to Z:\ drive (every 4 hours)
- **GFSBackup** - Creates Grandfather-Father-Son rotation backups to X:\ (daily)
- **VerifyBackups** - Validates backup integrity and restorability (weekly)

Each task includes its own README with detailed configuration and usage.

### Startup
Scripts that run on system boot:

- **StartEcosystem** - Launches PM2 ecosystem and apps

## Backup Strategy

### Data Flow
```
Source (C:\) → Staging (Z:\) → Archive (X:\)
```

### GFS Retention
- **Daily**: 7 backups
- **Weekly**: 4 backups (Sundays)
- **Monthly**: 12 backups (1st of month)
- **Yearly**: 10 backups (January 1st)

## Logs

Centralized logging location for:
- Backup operations (`backup.log`, `verify.log`)
- Sync operations (`sync.log`, `sync-errors.log`)
- System tasks and services

## Notes

- All backup scripts use robocopy with `/FFT` for FAT file time tolerance
- Exit codes ≥8 indicate failures requiring attention
- Task Scheduler runs automation tasks with appropriate triggers
- This infrastructure is version-controlled but configs may reference local paths