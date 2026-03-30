# ----------------------------
# TEST MODE BACKUP SCRIPT
# ----------------------------

Write-Host "========================================" -ForegroundColor Yellow
Write-Host "  BACKUP TEST MODE" -ForegroundColor Yellow
Write-Host "  This will create -TEST folders" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Yellow
Write-Host ""

# ----------------------------
# Config
# ----------------------------
$sourceFolders = @(
    $env:DIR_FILES,
    $env:DIR_DEV,
    $env:DIR_OPS,
    $env:DIR_BACKUPS
)
$mirrorRoot  = "Z:\"
$backupRoot  = "X:\System\Backups"

$logFile        = Join-Path $env:DIR_LOGS "tasks\GFSBackup\BackupTest.log"

# ----------------------------
# Pre-flight checks
# ----------------------------

$logDir = Split-Path $logFile -Parent
if (-not (Test-Path $logDir)) 
{
    try 
    {
        New-Item -ItemType Directory -Path $logDir -Force | Out-Null
        Write-Host "Created log directory: $logDir" -ForegroundColor Yellow
    } catch 
    {
        Write-Error "Failed to create log directory: $logDir"
        Write-Error $_.Exception.Message
        exit 1
    }
}

try 
{
    "Test write $(Get-Date)" | Out-File -FilePath $logFile -Append -ErrorAction Stop
} 
catch 
{
    Write-Error "Log file is not writable: $logFile"
    Write-Error $_.Exception.Message
    exit 1
}

# ----------------------------
# Helpers
# ----------------------------
function Invoke-Robocopy($source, $dest, [switch]$Mirror) 
{
    $robocopyArgs = @(
        $source,
        $dest,
        "/R:1",
        "/W:1",
        "/FFT",
        "/Z",
        "/XA:S",
        "/V",
        "/NP",
        "/UNILOG+:`"$logFile`""
    )
    
    if ($Mirror) {
        $robocopyArgs += "/MIR"
    } else {
        $robocopyArgs += "/E"
    }
    
    robocopy @robocopyArgs
}

$now = Get-Date

Write-Host "Test started at: $($now.ToString('yyyy-MM-dd HH:mm:ss'))" -ForegroundColor Cyan
Write-Host ""

# ----------------------------
# 1) Mirror source folders to M:
# ----------------------------

Write-Host "=== STEP 1: Mirror to M: drive ===" -ForegroundColor Cyan
Write-Host ""

foreach ($folder in $sourceFolders) 
{
    if (Test-Path $folder) 
    {
        $folderName = Split-Path $folder -Leaf
        $dest       = Join-Path $mirrorRoot $folderName

        if (-not (Test-Path $dest)) 
        { 
            New-Item -ItemType Directory -Path $dest -Force | Out-Null 
        }
        
        Write-Host "[MIRROR] $folder -> $dest" -ForegroundColor Green
        Invoke-Robocopy $folder $dest -Mirror
    } else 
    {
        Write-Warning "Source folder not found: $folder"
    }
}

Write-Host ""
Write-Host "Mirror complete! Check M:\Mirror\" -ForegroundColor Green
Write-Host ""

# ----------------------------
# 2) Create ALL GFS snapshots (TEST MODE)
# ----------------------------

Write-Host "=== STEP 2: Create ALL snapshot types (TEST) ===" -ForegroundColor Cyan
Write-Host ""

$dateStamp      = $now.ToString("yyyy-MM-dd")
$weekStamp      = $now.ToString("yyyy-MM-'W'") + (Get-Culture).Calendar.GetWeekOfYear($now, [System.Globalization.CalendarWeekRule]::FirstFourDayWeek, [DayOfWeek]::Monday).ToString("00")
$monthStamp     = $now.ToString("yyyy-MM")
$yearStamp      = $now.ToString("yyyy")

# Add -TEST suffix to all targets
$dailyTarget    = Join-Path $backupRoot "Daily\$dateStamp-TEST"
$weeklyTarget   = Join-Path $backupRoot "Weekly\$weekStamp-TEST"
$monthlyTarget  = Join-Path $backupRoot "Monthly\$monthStamp-TEST"
$yearlyTarget   = Join-Path $backupRoot "Yearly\$yearStamp-TEST"

# Create ALL backups (no date checks in test mode)
$allTargets = @(
    @{Name = "Daily";   Path = $dailyTarget},
    @{Name = "Weekly";  Path = $weeklyTarget},
    @{Name = "Monthly"; Path = $monthlyTarget},
    @{Name = "Yearly";  Path = $yearlyTarget}
)

foreach ($target in $allTargets) 
{
    if (-not (Test-Path $target.Path)) 
    { 
        New-Item -ItemType Directory -Path $target.Path -Force | Out-Null 
    }
    
    Write-Host "[$($target.Name)] Creating snapshot -> $($target.Path)" -ForegroundColor Green
    Invoke-Robocopy $mirrorRoot $target.Path
    Write-Host ""
}

# ----------------------------
# Test Summary
# ----------------------------

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  TEST COMPLETE!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Check these locations:" -ForegroundColor Cyan
Write-Host "  1. Mirror drive:  M:\Mirror\" -ForegroundColor White
Write-Host "  2. Daily backup:  $dailyTarget" -ForegroundColor White
Write-Host "  3. Weekly backup: $weeklyTarget" -ForegroundColor White
Write-Host "  4. Monthly backup: $monthlyTarget" -ForegroundColor White
Write-Host "  5. Yearly backup:  $yearlyTarget" -ForegroundColor White
Write-Host ""
Write-Host "Log file: $logFile" -ForegroundColor Gray
Write-Host ""
Write-Host "To clean up test folders, delete anything with '-TEST' in the name" -ForegroundColor Yellow
Write-Host ""
