



$env:STARSHIP_CONFIG = $env:CONFIG_STARSHIP;

function Invoke-Starship-PreCommand {
    $branch = git branch --show-current 2>$null
    if ($branch) {
        $env:GIT_BRANCH = "$( )$($branch.PadRight(4).Substring(0,4))$( )"
        if (Test-Path Env:GIT_SPACER) { Remove-Item Env:GIT_SPACER }
    } else {
        $env:GIT_SPACER = " "
        if (Test-Path Env:GIT_BRANCH) { Remove-Item Env:GIT_BRANCH }
    }
}

Invoke-Expression (&starship init powershell)
