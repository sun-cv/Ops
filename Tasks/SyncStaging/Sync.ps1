# ----------------------------
# Config
# ---------------------------

$sourceFolders = @(
    "C:\Users\sun\Files",
    "C:\Users\sun\Documents",
    "C:\Dev",
    "C:\Ops"
    "C:\Backups"
)

$syncRoot = "Z:\"
$logFile  = "C:\Logs\Tasks\GFS\SyncStaging.log"
$errorLog = "C:\Logs\Tasks\GFS\SyncStagingErrors.log"

$excludeFiles = @(
    "*.tmp",
    "*.temp",
    "*.lock",
    "*Lockfile",
    "FSTimeGet-*",
    "*.pdb",
    "thumbs.db",
    "desktop.ini",
    "~$*",
    "*.db",
    "*.log"
)

$excludeDirs = @(
    "Temp",
    "obj",
    "bin",
    ".vs",
    "node_modules",
    ".vscode",
    "Build",
    "Builds",
    "Logs"
)

$logDir = Split-Path $logFile -Parent
if (-not (Test-Path $logDir)) 
{
    try 
    {
        New-Item -ItemType Directory -Path $logDir -Force | Out-Null
        Write-Host "Created log directory: $logDir" -ForegroundColor Yellow
    } 
    catch 
    {
        Write-Error "Failed to create log directory: $logDir"
        Write-Error $_.Exception.Message
        exit 1
    }
}

try 
{
    "=== Sync started: $(Get-Date) ===" | Out-File -FilePath $logFile -Append -ErrorAction Stop
} 
catch 
{
    Write-Error "Log file is not writable: $logFile"
    Write-Error $_.Exception.Message
    exit 1
}

"=== Sync Errors - $(Get-Date) ===" | Out-File -FilePath $errorLog

# ----------------------------
# Functions
# ----------------------------

function Invoke-Robocopy($source, $dest, $folderName) 
{
    $tempLog = "$logDir\temp-$folderName.log"
    
    $robocopyArgs = @(
        $source,
        $dest,
        "/MIR",
        "/R:0",
        "/W:0",
        "/FFT",
        "/XA:S",
        "/NP",
        "/LOG:$tempLog",
        "/V"
    )
    
    # Add file exclusions
    if ($excludeFiles.Count -gt 0) {
        $robocopyArgs += "/XF"
        $robocopyArgs += $excludeFiles
    }
    
    # Add directory exclusions
    if ($excludeDirs.Count -gt 0) {
        $robocopyArgs += "/XD"
        $robocopyArgs += $excludeDirs
    }
    
    $output   = robocopy @robocopyArgs 2>&1
    $exitCode = $LASTEXITCODE
    
     if (Test-Path $tempLog) 
     {
        Get-Content $tempLog | Out-File -FilePath $logFile -Append
        
        $realErrors = Get-Content $tempLog | Where-Object {
            $_ -match "Access is denied" -or
            $_ -match "ERROR \d+" -or
            $_ -match "The process cannot access" -or
            $_ -match "^\s+\d+\s+\S+.*FAILED" -or
            $_ -match "There is not enough space"
        }
        
        if ($realErrors) 
        {
            "`n--- Real Errors from $folderName ---" | Out-File -FilePath $errorLog -Append
            $realErrors | Out-File -FilePath $errorLog -Append
        }
        
        Remove-Item $tempLog -Force
    }
    
    return $exitCode
}

# ----------------------------
# Main Sync Loop
# ----------------------------

$now = Get-Date
Write-Host "=== Sync started at $($now.ToString('yyyy-MM-dd HH:mm:ss')) ===" -ForegroundColor Cyan

$syncSuccess = $true
$hasWarnings = $false

foreach ($folder in $sourceFolders) 
{
    if (Test-Path $folder) 
    {
        $folderName = Split-Path $folder -Leaf
        $dest = Join-Path $syncRoot $folderName

        if (-not (Test-Path $dest)) 
        { 
            New-Item -ItemType Directory -Path $dest -Force | Out-Null 
        }
        
        Write-Host "Syncing $folder -> $dest"
        $exitCode = Invoke-Robocopy $folder $dest $folderName
        
        if ($exitCode -ge 8) 
        {
            Write-Host "  WARNING: Some files failed (exit code: $exitCode)" -ForegroundColor Yellow
            $hasWarnings = $true
        }
        elseif ($exitCode -eq 0)
        {
            Write-Host "  No changes" -ForegroundColor Gray
        }
        elseif ($exitCode -eq 1)
        {
            Write-Host "  Files copied successfully" -ForegroundColor Green
        }
        elseif ($exitCode -le 7)
        {
            Write-Host "  Complete (code: $exitCode)" -ForegroundColor Green
        }
    } 
    else 
    {
        Write-Warning "Source folder not found: $folder"
        $syncSuccess = $false
    }
}

Write-Host ""

if (-not $syncSuccess) 
{
    Write-Host "Sync FAILED - missing source folders" -ForegroundColor Red
    exit 1
}
elseif ($hasWarnings)
{
    Write-Host "Sync complete with WARNINGS" -ForegroundColor Yellow
    
    $errorContent = Get-Content $errorLog
    $hasRealErrors = $errorContent | Where-Object { $_ -match "Real Errors" }
    
    if ($hasRealErrors) 
    {
        Write-Host "Error details: $errorLog" -ForegroundColor Red
        Write-Host "`nErrors found:" -ForegroundColor Yellow
        Get-Content $errorLog | Select-Object -Skip 1 | ForEach-Object 
        {
            Write-Host "  $_" -ForegroundColor Gray
        }
    } 
    else 
    {
        Write-Host "No actual file errors - exit code may be from folder detection or extras" -ForegroundColor Gray
    }
    
    exit 0
}
else 
{
    Write-Host "Sync complete!" -ForegroundColor Green
    exit 0
}
