


$EnvironmentPath = "C:\sun\ops\shells\powershell"
$Variables       = "EnvironmentVariables.ps1"
$Directories     = @("profile", "functions", "modules", "integrations")
$ToolsPath       = Join-Path $EnvironmentPath "tools"
$ManifestPath    = Join-Path $EnvironmentPath "data\managed-vars"


if (-not (Test-Path $EnvironmentPath)) {
    Write-Warning "Environment path not found: $EnvironmentPath"
    return
}

Get-ChildItem -Path $EnvironmentPath -Filter $Variables -Recurse | ForEach-Object {
    try {
        $file = $_.FullName
        $declaredNames = Select-String -Path $file -Pattern '^\$env:(\w+)' |
            ForEach-Object { $_.Matches[0].Groups[1].Value }

        if (Test-Path $ManifestPath) {
            $previousNames = Get-Content $ManifestPath
            $previousNames | Where-Object { $_ -notin $declaredNames } | ForEach-Object {
                [System.Environment]::SetEnvironmentVariable($_, $null, "User")
            }
        }

        . $file

        foreach ($name in $declaredNames) {
            $current = (Get-Item "Env:$name" -ErrorAction SilentlyContinue)?.Value
            $old = [System.Environment]::GetEnvironmentVariable($name, "User")
            if ($current -ne $old) {
                [System.Environment]::SetEnvironmentVariable($name, $current, "User")
            }
        }

        $declaredNames | Set-Content $ManifestPath
    } catch {
        Write-Warning "Failed to load vars: $_"
    }
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
