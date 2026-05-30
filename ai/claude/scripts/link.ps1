<#
.SYNOPSIS
    One-time migration + (re)linker for the Claude config.

.DESCRIPTION
    Converts the whole-directory  ~/.claude -> ops\ai\claude  symlink into the
    "separate source from runtime" model:

      * ~/.claude becomes a REAL directory (runtime state + secrets live here, outside git)
      * curated config (CLAUDE.md, settings.json, instructions/, skills/, agents/,
        commands/, hooks/, output-styles/) is symlinked back from ops\ai\claude

    Safe to re-run (idempotent). In "relink" mode (when ~/.claude is already a real
    directory) it re-asserts the curated symlinks and sweeps any runtime artifacts that
    leaked into the source back out to ~/.claude — handy if a file symlink gets clobbered
    or Claude wrote into the source before linking.

.IMPORTANT
    >>> CLOSE CLAUDE CODE BEFORE RUNNING. <<<
    Claude holds open handles to sessions/ and shell-snapshots/ inside the config dir;
    moving them while it runs will fail or corrupt state.

    Creating symlinks on Windows needs either Developer Mode enabled or an elevated shell.

.EXAMPLE
    pwsh -NoProfile -File .\link.ps1
    pwsh -NoProfile -File .\link.ps1 -Yes      # skip the confirmation prompt
#>
[CmdletBinding()]
param(
    [string]$Source = 'C:\sun\ops\ai\claude',
    [string]$Live   = (Join-Path $env:USERPROFILE '.claude'),
    [switch]$Yes
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

# Curated items symlinked from $Source into $Live (what Claude Code reads).
$CuratedFiles = @('CLAUDE.md', 'settings.json')
$CuratedDirs  = @('instructions', 'skills', 'agents', 'commands', 'hooks', 'output-styles')

# Runtime items that must physically live in $Live and never enter git.
$RuntimeItems = @(
    '.credentials.json', 'history.jsonl', 'mcp-needs-auth-cache.json', '.last-cleanup',
    'sessions', 'shell-snapshots', 'file-history', 'telemetry',
    'projects', 'backups', 'cache', 'paste-cache', 'ide', 'session-env',
    'plans', 'tasks'
)

function Test-ReparsePoint {
    param([string]$Path)
    $item = Get-Item -LiteralPath $Path -Force -ErrorAction SilentlyContinue
    return $item -and ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint)
}

function Remove-LinkOnly {
    # Removes a symlink/junction WITHOUT following it into (or deleting) the target.
    # rmdir removes a directory link; del removes a file link. Neither touches the target.
    param([string]$Path)
    $item = Get-Item -LiteralPath $Path -Force
    if ($item.PSIsContainer) { & cmd /c rmdir "$Path" | Out-Null }
    else                     { & cmd /c del /f /q "$Path" | Out-Null }
    if (Test-Path -LiteralPath $Path) { throw "Failed to remove link: $Path" }
}

Write-Host '=== Claude config linker ===' -ForegroundColor Cyan
Write-Host "Source (curated, git) : $Source"
Write-Host "Live   (runtime, home): $Live`n"

if (-not (Test-Path -LiteralPath $Source)) { throw "Source not found: $Source" }

$staging = "$Live.real"   # e.g. C:\Users\<you>\.claude.real

# --- Step 1: dissolve the whole-dir symlink, if that's the current state. ---
if ((Test-Path -LiteralPath $Live) -and (Test-ReparsePoint $Live)) {
    $target = (Get-Item -LiteralPath $Live -Force).Target
    Write-Host "~/.claude is a symlink -> $target"
    if (-not $Yes) {
        $ans = Read-Host 'Migrate to real dir + curated symlinks? Type "yes" to proceed'
        if ($ans -ne 'yes') { Write-Host 'Aborted.'; return }
    }

    if (Test-Path -LiteralPath $staging) {
        throw "Staging path already exists (partial prior run?): $staging`n" +
              'Inspect it, move anything needed back, remove it, then re-run.'
    }

    # Move runtime OUT of the source (it physically lives there today) into staging.
    New-Item -ItemType Directory -Path $staging | Out-Null
    foreach ($item in $RuntimeItems) {
        $src = Join-Path $Source $item
        if (Test-Path -LiteralPath $src) {
            Write-Host "  move runtime -> staging: $item"
            Move-Item -LiteralPath $src -Destination (Join-Path $staging $item)
        }
    }

    Remove-LinkOnly $Live                         # remove reparse point only; $Source untouched
    Move-Item -LiteralPath $staging -Destination $Live   # promote staging to the real ~/.claude
    Write-Host "  ~/.claude is now a real directory with runtime state.`n"
}
elseif (-not (Test-Path -LiteralPath $Live)) {
    New-Item -ItemType Directory -Path $Live | Out-Null
    Write-Host "Created real ~/.claude (was missing).`n"
}
else {
    Write-Host "~/.claude is already a real directory — relinking only.`n"
}

# --- Step 1b: keep the source curated-only by sweeping any runtime that lingers in it. ---
# Self-healing: anything Claude wrote into $Source before linking, or an orphan left by an
# older run, is relocated to $Live. If $Live already holds the item, the source copy is a
# stale duplicate and is dropped. (After a fresh migration this finds nothing.)
foreach ($item in $RuntimeItems) {
    $src = Join-Path $Source $item
    if (-not (Test-Path -LiteralPath $src)) { continue }
    $dest = Join-Path $Live $item
    if (Test-Path -LiteralPath $dest) {
        Write-Host "  drop stale runtime orphan in source: $item"
        Remove-Item -LiteralPath $src -Recurse -Force
    } else {
        Write-Host "  relocate runtime orphan -> live: $item"
        Move-Item -LiteralPath $src -Destination $dest
    }
}

# --- Step 2: (re)create curated symlinks in $Live -> $Source. ---
foreach ($name in ($CuratedFiles + $CuratedDirs)) {
    $linkPath   = Join-Path $Live   $name
    $targetPath = Join-Path $Source $name

    if (-not (Test-Path -LiteralPath $targetPath)) {
        Write-Warning "  skip (no source): $name"; continue
    }
    if (Test-Path -LiteralPath $linkPath) {
        if (Test-ReparsePoint $linkPath) {
            Remove-LinkOnly $linkPath
        } else {
            Write-Warning "  exists as a real file/dir, NOT relinking: $name"; continue
        }
    }
    New-Item -ItemType SymbolicLink -Path $linkPath -Target $targetPath | Out-Null
    Write-Host "  link: $name -> $targetPath"
}

Write-Host "`nDone." -ForegroundColor Green
Write-Host 'Verify with:'
Write-Host "  Get-ChildItem '$Live' -Force | Select-Object Name, LinkType, Target"
Write-Host 'Then reopen Claude Code and confirm model/instructions/settings load.'
