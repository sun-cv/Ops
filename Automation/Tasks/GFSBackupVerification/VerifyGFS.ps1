# ----------------------------
# Config
# ----------------------------

$mirrorRoot = "Z:\"
$backupRoot = "X:\Backups"
$logFile    = "C:\Ops\Logs\Automation\Tasks\VerifyGFS.log"

$backupSources = @(
    @{ Source = "Z:\Files"; Name = "Files" },
    @{ Source = "Z:\dev";   Name = "dev" },
    @{ Source = "Z:\ops";   Name = "ops" }
)

#  Critical files or paths to verify existence in backup
$criticalPaths = @(
)

$maxBackupAgeHours      = 48        # Alert if latest backup is older than this
$minFileCountPercent    = 0.95      # Alert if backup has less than 95% of source files
$randomSampleCount      = 10        # Number of random files to hash-verify
$testRestoreEnabled     = $true     # Whether to perform test restore
$testRestorePath        = "C:\Temp\BackupVerifyTest"

# ----------------------------
# Pre-flight checks
# ----------------------------

$logDir = Split-Path $logFile -Parent
if (-not (Test-Path $logDir)) 
{
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}

"=== Backup Verification started: $(Get-Date) ===" | Out-File -FilePath $logFile -Append

# ----------------------------
# Helpers
# ----------------------------

function Test-BackupRecency 
{
    Write-Host "`n=== Checking Backup Recency ===" -ForegroundColor Cyan
    
    $dailyPath = Join-Path $backupRoot "Daily"
    
    if (-not (Test-Path $dailyPath)) 
    {
        Write-Host "  ERROR: Daily backup folder not found!" -ForegroundColor Red
        "ERROR: Daily backup folder not found at $dailyPath" | Out-File -FilePath $logFile -Append
        return $false
    }
    
    $latestBackup = Get-ChildItem $dailyPath -Directory | 
        Where-Object { $_.Name -match '^\d{4}-\d{2}-\d{2}$' } |
        Sort-Object Name -Descending | 
        Select-Object -First 1
    
    if (-not $latestBackup) 
    {
        Write-Host "  ERROR: No dated backup folders found!" -ForegroundColor Red
        "ERROR: No dated backup folders found in $dailyPath" | Out-File -FilePath $logFile -Append
        return $false
    }
    
    $backupAge = (Get-Date) - $latestBackup.CreationTime
    
    Write-Host "  Latest backup: $($latestBackup.Name)" -ForegroundColor Gray
    Write-Host "  Age: $([math]::Round($backupAge.TotalHours, 1)) hours" -ForegroundColor Gray
    
    "Latest backup: $($latestBackup.Name), Age: $($backupAge.TotalHours) hours" | Out-File -FilePath $logFile -Append
    
    if ($backupAge.TotalHours -gt $maxBackupAgeHours) 
    {
        Write-Host "  WARNING: Backup is older than $maxBackupAgeHours hours!" -ForegroundColor Yellow
        "WARNING: Backup age exceeds threshold ($maxBackupAgeHours hours)" | Out-File -FilePath $logFile -Append
        return $false
    }
    
    Write-Host "  OK: Backup is recent" -ForegroundColor Green
    return $true
}

function Test-FileCountComparison 
{
    Write-Host "`n=== Checking File Counts ===" -ForegroundColor Cyan
    
    $allPassed = $true
    $dailyPath = Join-Path $backupRoot "Daily"
    $latestBackup = Get-ChildItem $dailyPath -Directory | 
        Where-Object { $_.Name -match '^\d{4}-\d{2}-\d{2}$' } |
        Sort-Object Name -Descending | 
        Select-Object -First 1
    
    if (-not $latestBackup) 
    {
        Write-Host "  ERROR: Cannot find latest backup for comparison" -ForegroundColor Red
        return $false
    }
    
    foreach ($item in $backupSources) 
    {
        $sourcePath = $item.Source
        $folderName = $item.Name
        
        if (-not (Test-Path $sourcePath)) 
        {
            Write-Host "  WARNING: Source not found: $sourcePath" -ForegroundColor Yellow
            continue
        }
        
        $backupPath = Join-Path $latestBackup.FullName $folderName
        
        if (-not (Test-Path $backupPath)) 
        {
            Write-Host "  ERROR: Backup not found for $folderName" -ForegroundColor Red
            "ERROR: Backup path not found: $backupPath" | Out-File -FilePath $logFile -Append
            $allPassed = $false
            continue
        }
        
        Write-Host "  Comparing: $folderName..." -ForegroundColor Gray
        
        $sourceFiles = @(Get-ChildItem $sourcePath -Recurse -File -ErrorAction SilentlyContinue)
        $backupFiles = @(Get-ChildItem $backupPath -Recurse -File -ErrorAction SilentlyContinue)
        
        $sourceCount = $sourceFiles.Count
        $backupCount = $backupFiles.Count
        
        $sourceSize = ($sourceFiles | Measure-Object -Property Length -Sum).Sum / 1GB
        $backupSize = ($backupFiles | Measure-Object -Property Length -Sum).Sum / 1GB
        
        Write-Host "    Source: $sourceCount files ($([math]::Round($sourceSize, 2)) GB)" -ForegroundColor Gray
        Write-Host "    Backup: $backupCount files ($([math]::Round($backupSize, 2)) GB)" -ForegroundColor Gray
        
        "$folderName - Source: $sourceCount files, Backup: $backupCount files" | Out-File -FilePath $logFile -Append
        
        $ratio = if ($sourceCount -gt 0) { $backupCount / $sourceCount } else { 0 }
        
        if ($ratio -lt $minFileCountPercent) 
        {
            Write-Host "    WARNING: Backup has only $([math]::Round($ratio * 100, 1))% of source files!" -ForegroundColor Yellow
            "WARNING: $folderName backup file count is below threshold ($([math]::Round($ratio * 100, 1))%)" | Out-File -FilePath $logFile -Append
            $allPassed = $false
        }
        else 
        {
            Write-Host "    OK: File count matches ($([math]::Round($ratio * 100, 1))%)" -ForegroundColor Green
        }
    }
    
    return $allPassed
}

function Test-CriticalFiles 
{
    if ($criticalPaths.Count -eq 0) 
    {
        Write-Host "`n=== Skipping Critical Files Check (none configured) ===" -ForegroundColor Gray
        return $true
    }
    
    Write-Host "`n=== Checking Critical Files ===" -ForegroundColor Cyan
    
    $allPassed = $true
    $dailyPath = Join-Path $backupRoot "Daily"
    $latestBackup = Get-ChildItem $dailyPath -Directory | 
        Where-Object { $_.Name -match '^\d{4}-\d{2}-\d{2}$' } |
        Sort-Object Name -Descending | 
        Select-Object -First 1
    
    foreach ($criticalPath in $criticalPaths) 
    {
        $fullBackupPath = Join-Path $latestBackup.FullName $criticalPath
        
        if (Test-Path $fullBackupPath) 
        {
            Write-Host "  OK: $criticalPath" -ForegroundColor Green
        }
        else 
        {
            Write-Host "  ERROR: Missing critical file: $criticalPath" -ForegroundColor Red
            "ERROR: Critical file missing from backup: $criticalPath" | Out-File -FilePath $logFile -Append
            $allPassed = $false
        }
    }
    
    return $allPassed
}

function Test-RandomFileHashes 
{
    Write-Host "`n=== Verifying Random File Hashes ===" -ForegroundColor Cyan
    
    $allPassed = $true
    $dailyPath = Join-Path $backupRoot "Daily"
    $latestBackup = Get-ChildItem $dailyPath -Directory | 
        Where-Object { $_.Name -match '^\d{4}-\d{2}-\d{2}$' } |
        Sort-Object Name -Descending | 
        Select-Object -First 1
    
    foreach ($item in $backupSources) 
    {
        $sourcePath = $item.Source
        $folderName = $item.Name
        
        if (-not (Test-Path $sourcePath)) { continue }
        
        $backupPath = Join-Path $latestBackup.FullName $folderName

        if (-not (Test-Path $backupPath)) { continue }
        
        Write-Host "  Sampling $folderName..." -ForegroundColor Gray
        
        $sourceFiles = @(Get-ChildItem $sourcePath -Recurse -File -ErrorAction SilentlyContinue | 
            Where-Object { $_.Length -lt 100MB })
        
        if ($sourceFiles.Count -eq 0) 
        {
            Write-Host "    No files to sample" -ForegroundColor Gray
            continue
        }
        
        $sampleSize = [math]::Min($randomSampleCount, $sourceFiles.Count)
        $samples = $sourceFiles | Get-Random -Count $sampleSize
        
        foreach ($sourceFile in $samples) 
        {
            $relativePath = $sourceFile.FullName.Replace($sourcePath, "").TrimStart('\')
            $backupFile = Join-Path $backupPath $relativePath
            
            if (-not (Test-Path $backupFile)) 
            {
                Write-Host "    WARNING: File missing in backup: $relativePath" -ForegroundColor Yellow
                "WARNING: Sampled file missing in backup: $relativePath" | Out-File -FilePath $logFile -Append
                $allPassed = $false
                continue
            }
            
            $sourceHash = (Get-FileHash -Path $sourceFile.FullName -Algorithm SHA256).Hash
            $backupHash = (Get-FileHash -Path $backupFile -Algorithm SHA256).Hash
            
            if ($sourceHash -eq $backupHash) 
            {
                Write-Host "    OK: $relativePath" -ForegroundColor Green
            }
            else 
            {
                Write-Host "    ERROR: Hash mismatch: $relativePath" -ForegroundColor Red
                "ERROR: Hash mismatch for $relativePath" | Out-File -FilePath $logFile -Append
                $allPassed = $false
            }
        }
    }
    
    return $allPassed
}

function Test-RestoreCapability 
{
    if (-not $testRestoreEnabled) 
    {
        Write-Host "`n=== Skipping Test Restore (disabled) ===" -ForegroundColor Gray
        return $true
    }
    
    Write-Host "`n=== Testing Restore Capability ===" -ForegroundColor Cyan
    
    $dailyPath = Join-Path $backupRoot "Daily"
    $latestBackup = Get-ChildItem $dailyPath -Directory | 
        Where-Object { $_.Name -match '^\d{4}-\d{2}-\d{2}$' } |
        Sort-Object Name -Descending | 
        Select-Object -First 1
    
    $testSource = $backupSources[0]
    $backupPath = Join-Path $latestBackup.FullName $testSource.Name
    
    if (-not (Test-Path $backupPath)) 
    {
        Write-Host "  ERROR: Cannot find backup path for test restore" -ForegroundColor Red
        return $false
    }
    
    if (Test-Path $testRestorePath) 
    {
        Remove-Item $testRestorePath -Recurse -Force
    }
    
    New-Item -ItemType Directory -Path $testRestorePath -Force | Out-Null
    
    Write-Host "  Performing test restore of $($testSource.Name)..." -ForegroundColor Gray
    
    $result   = robocopy $backupPath $testRestorePath /E /LEV:2 /R:1 /W:1 /NP /NDL /NFL
    $exitCode = $LASTEXITCODE
    
    if ($exitCode -ge 8) 
    {
        Write-Host "  ERROR: Test restore failed (exit code: $exitCode)" -ForegroundColor Red
        "ERROR: Test restore failed with exit code $exitCode" | Out-File -FilePath $logFile -Append
        return $false
    }
    
    $restoredFiles = @(Get-ChildItem $testRestorePath -Recurse -File)
    
    if ($restoredFiles.Count -eq 0) 
    {
        Write-Host "  ERROR: No files were restored" -ForegroundColor Red
        "ERROR: Test restore resulted in 0 files" | Out-File -FilePath $logFile -Append
        return $false
    }
    
    Write-Host "  OK: Successfully restored $($restoredFiles.Count) files" -ForegroundColor Green
    "Test restore successful: $($restoredFiles.Count) files restored" | Out-File -FilePath $logFile -Append
    
    Remove-Item $testRestorePath -Recurse -Force
    
    return $true
}

function Test-BackupRotation 
{
    Write-Host "`n=== Checking Backup Rotation ===" -ForegroundColor Cyan
    
    $allPassed = $true
    
    $tiers = @(
        @{ Name = "Daily"; Path = Join-Path $backupRoot "Daily"; MinExpected = 3 },
        @{ Name = "Weekly"; Path = Join-Path $backupRoot "Weekly"; MinExpected = 1 },
        @{ Name = "Monthly"; Path = Join-Path $backupRoot "Monthly"; MinExpected = 1 },
        @{ Name = "Yearly"; Path = Join-Path $backupRoot "Yearly"; MinExpected = 0 }
    )
    
    foreach ($tier in $tiers) 
    {
        if (Test-Path $tier.Path) 
        {
            $backupCount = @(Get-ChildItem $tier.Path -Directory | 
                Where-Object { $_.Name -match '^\d{4}-' }).Count
            
            Write-Host "  $($tier.Name): $backupCount backups" -ForegroundColor Gray
            "$($tier.Name) tier: $backupCount backups" | Out-File -FilePath $logFile -Append
            
            if ($backupCount -lt $tier.MinExpected) 
            {
                Write-Host "    WARNING: Expected at least $($tier.MinExpected) backups" -ForegroundColor Yellow
                $allPassed = $false
            }
        }
        else 
        {
            Write-Host "  $($tier.Name): Folder not found" -ForegroundColor Yellow
            "$($tier.Name) tier: Folder not found at $($tier.Path)" | Out-File -FilePath $logFile -Append
            
            if ($tier.MinExpected -gt 0) 
            {
                $allPassed = $false
            }
        }
    }
    
    return $allPassed
}

# ----------------------------
# Run all verification tests
# ----------------------------

$now = Get-Date
Write-Host "=== Backup Verification started at $($now.ToString('yyyy-MM-dd HH:mm:ss')) ===" -ForegroundColor Cyan

$results = @{
    Recency = Test-BackupRecency
    FileCount = Test-FileCountComparison
    CriticalFiles = Test-CriticalFiles
    RandomHashes = Test-RandomFileHashes
    TestRestore = Test-RestoreCapability
    Rotation = Test-BackupRotation
}

# ----------------------------
# Summary
# ----------------------------

Write-Host "`n=== Verification Summary ===" -ForegroundColor Cyan

$failedTests = @()
foreach ($test in $results.GetEnumerator()) 
{
    $status = if ($test.Value) { "PASS" } else { "FAIL" }
    $color = if ($test.Value) { "Green" } else { "Red" }
    
    Write-Host "  $($test.Key): $status" -ForegroundColor $color
    "$($test.Key): $status" | Out-File -FilePath $logFile -Append
    
    if (-not $test.Value) 
    {
        $failedTests += $test.Key
    }
}

Write-Host ""

if ($failedTests.Count -eq 0) 
{
    Write-Host "=== All verification tests PASSED ===" -ForegroundColor Green
    "=== All verification tests PASSED ===" | Out-File -FilePath $logFile -Append
    exit 0
}
else 
{
    Write-Host "=== Verification FAILED ===" -ForegroundColor Red
    Write-Host "Failed tests: $($failedTests -join ', ')" -ForegroundColor Red
    Write-Host "`nCheck log for details: $logFile" -ForegroundColor Yellow
    "=== Verification FAILED - Tests: $($failedTests -join ', ') ===" | Out-File -FilePath $logFile -Append
    exit 1
}