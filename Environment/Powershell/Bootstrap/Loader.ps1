


$EnvironmentPath = "C:\Ops\Environment\PowerShell"

$Directories     = @("Helpers", "Profile")
$ToolsPath       = Join-Path $EnvironmentPath "Tools"

if (-not (Test-Path $EnvironmentPath)) {
    Write-Warning "Environment path not found: $EnvironmentPath"
    return
}

foreach ($Directory in $Directories) {
    $FullPath = Join-Path $EnvironmentPath $Directory
    if (Test-Path $FullPath) {
        Get-ChildItem -Path $FullPath -Filter *.ps1 -Recurse | ForEach-Object {
            try {
                . $_.FullName
            } catch {
                Write-Warning "Failed to load script $($_.FullName): $_"
            }
        }
    }
}

if ((Test-Path $ToolsPath) -and ($env:PATH -notlike "*$ToolsPath*")) {
    $env:PATH += ";$ToolsPath"
}
