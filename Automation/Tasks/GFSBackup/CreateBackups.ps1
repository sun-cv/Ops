
# ----------------------------
# Config
# ----------------------------

$mirrorRoot = "Z:\"
$backupRoot = "X:\Backups"
$logFile    = "C:\Ops\Logs\Automation\Tasks\GFS\Backup.log"

$backupSources = @(
    "Z:\Files"
    "Z:\Documents",
    "Z:\dev",
    "Z:\ops"
)

$excludeDirs = @(
)

$excludePaths = @(
)

$excludeFiles = @(
)

$maxDaily   = 7
$maxWeekly  = 4
$maxMonthly = 12
$maxYearly  = 10

# ----------------------------
# Pre-flight checks
# ----------------------------

if (-not (Test-Path $mirrorRoot)) 
{
    Write-Error "Mirror drive not found: $mirrorRoot"
    exit 1
}

$logDir = Split-Path $logFile -Parent

if (-not (Test-Path $logDir)) 
{
    try 
    {
        New-Item -ItemType Directory -Path $logDir -Force | Out-Null
    } 
    catch 
    {
        Write-Error "Failed to create log directory: $logDir"
        exit 1
    }
}

try 
{
    "=== GFS Backup started: $(Get-Date) ===" | Out-File -FilePath $logFile -Append -ErrorAction Stop
} 
catch 
{
    Write-Error "Log file is not writable: $logFile"
    exit 1
}

# ----------------------------
# Helpers
# ----------------------------

function Invoke-Robocopy($source, $dest) 
{
    $robocopyArgs = @(
        $source,
        $dest,
        "/E",
        "/R:1",
        "/W:1",
        "/FFT",
        "/Z",
        "/XA:S",
        "/NP",
        "/UNILOG+:$logFile"
    )
    
    if ($excludeDirs.Count -gt 0) 
    {
        $robocopyArgs += "/XD"
        foreach ($dir in $excludeDirs) 
        {
            $robocopyArgs += $dir
        }
    }
    
    $relevantPaths = $excludePaths | Where-Object { $_.StartsWith($source, [StringComparison]::OrdinalIgnoreCase) }

    if ($relevantPaths.Count -gt 0) 
    {
        if ($excludeDirs.Count -eq 0) 
        {
            $robocopyArgs += "/XD"
        }
        foreach ($path in $relevantPaths) 
        {
            $robocopyArgs += $path
        }
    }
    
    if ($excludeFiles.Count -gt 0) 
    {
        $robocopyArgs += "/XF"

        foreach ($file in $excludeFiles) 
        {
            $robocopyArgs += $file
        }
    }
    
    robocopy @robocopyArgs
    return $LASTEXITCODE
}

function Backup-SelectedFolders($targetRoot)
{
    $hasErrors = $false
    
    foreach ($source in $backupSources)
    {
        if (Test-Path $source)
        {
            $relativePath = $source.Replace("$mirrorRoot", "").TrimStart('\')
            $dest = Join-Path $targetRoot $relativePath
            
            $destParent = Split-Path $dest -Parent
            if (-not (Test-Path $destParent))
            {
                New-Item -ItemType Directory -Path $destParent -Force | Out-Null
            }
            
            Write-Host "    $relativePath" -ForegroundColor Gray
            $exitCode = Invoke-Robocopy $source $dest
            
            if ($exitCode -ge 8) 
            {
                Write-Warning "Failed to backup: $relativePath (exit code: $exitCode)"
                $hasErrors = $true
            }
        }
        else
        {
            Write-Warning "Source not found (skipping): $source"
        }
    }
    
    return -not $hasErrors
}

function Remove-OldBackups($path, $keepCount) 
{
    if (Test-Path $path) 
    {
        Get-ChildItem $path -Directory |
            Where-Object { $_.Name -match '^\d{4}-' } |
            Sort-Object Name -Descending |
            Select-Object -Skip $keepCount |
            ForEach-Object 
            {
                Write-Host "  Removing old backup: $($_.Name)" -ForegroundColor DarkGray
                Remove-Item $_.FullName -Recurse -Force
            }
    }
}

$now = Get-Date

Write-Host "=== GFS Backup started at $($now.ToString('yyyy-MM-dd HH:mm:ss')) ===" -ForegroundColor Cyan
Write-Host ""


$dateStamp      = $now.ToString("yyyy-MM-dd")
$weekStamp      = $now.ToString("yyyy-MM-'W'") + (Get-Culture).Calendar.GetWeekOfYear($now, [System.Globalization.CalendarWeekRule]::FirstFourDayWeek, [DayOfWeek]::Monday).ToString("00")
$monthStamp     = $now.ToString("yyyy-MM")
$yearStamp      = $now.ToString("yyyy")

$dailyTarget    = Join-Path $backupRoot "Daily\$dateStamp"
$weeklyTarget   = Join-Path $backupRoot "Weekly\$weekStamp"
$monthlyTarget  = Join-Path $backupRoot "Monthly\$monthStamp"
$yearlyTarget   = Join-Path $backupRoot "Yearly\$yearStamp"

# ----------------------------
# Daily
# ----------------------------

Write-Host "Creating daily snapshot..." -ForegroundColor Cyan

if (-not (Test-Path $dailyTarget)) 
{ 
    New-Item -ItemType Directory -Path $dailyTarget -Force | Out-Null 
}

$success = Backup-SelectedFolders $dailyTarget

if (-not $success) 
{
    Write-Error "Daily backup completed with errors"
    exit 1
}

Write-Host "Daily backup complete" -ForegroundColor Green
Write-Host ""

# ----------------------------
# Weekly (Sundays)
# ----------------------------

if ($now.DayOfWeek -eq 'Sunday') 
{
    Write-Host "Creating weekly snapshot (Sunday)..." -ForegroundColor Cyan
    
    if (-not (Test-Path $weeklyTarget)) 
    { 
        New-Item -ItemType Directory -Path $weeklyTarget -Force | Out-Null 
    }
    
    $success = Backup-SelectedFolders $weeklyTarget
    
    if ($success)
    {
        Write-Host "Weekly backup complete" -ForegroundColor Green
    }
    else
    {
        Write-Warning "Weekly backup completed with errors"
    }

    Write-Host ""
}

# ----------------------------
# Monthly (1st of month)
# ----------------------------

if ($now.Day -eq 1) 
{
    Write-Host "Creating monthly snapshot (1st of month)..." -ForegroundColor Cyan
    
    if (-not (Test-Path $monthlyTarget)) 
    { 
        New-Item -ItemType Directory -Path $monthlyTarget -Force | Out-Null 
    }
    
    $success = Backup-SelectedFolders $monthlyTarget
    
    if ($success)
    {
        Write-Host "Monthly backup complete" -ForegroundColor Green
    }
    else
    {
        Write-Warning "Monthly backup completed with errors"
    }
    Write-Host ""
}

# ----------------------------
# Yearly (January 1st)
# ----------------------------

if ($now.Day -eq 1 -and $now.Month -eq 1) 
{
    Write-Host "Creating yearly snapshot (January 1st)..." -ForegroundColor Cyan
    
    if (-not (Test-Path $yearlyTarget)) 
    { 
        New-Item -ItemType Directory -Path $yearlyTarget -Force | Out-Null 
    }
    
    $success = Backup-SelectedFolders $yearlyTarget
    
    if ($success)
    {
        Write-Host "Yearly backup complete" -ForegroundColor Green
    }
    else
    {
        Write-Warning "Yearly backup completed with errors"
    }
    Write-Host ""
}

# ----------------------------
# Cleanup
# ----------------------------

Write-Host "Cleaning up old backups..." -ForegroundColor Cyan

Remove-OldBackups "$backupRoot\Daily"   $maxDaily
Remove-OldBackups "$backupRoot\Weekly"  $maxWeekly
Remove-OldBackups "$backupRoot\Monthly" $maxMonthly
Remove-OldBackups "$backupRoot\Yearly"  $maxYearly

Write-Host ""
Write-Host "=== GFS Backup complete! ===" -ForegroundColor Green