



$env:STARSHIP_CONFIG = $env:CONFIG_STARSHIP;

$fg_string   = "`e[38;2;170;217;76m"   # #aad94c - staged
$fg_func     = "`e[38;2;255;180;84m"   # #ffb454 - modified
$fg_markup   = "`e[38;2;240;113;120m"  # #f07178 - deleted
$fg_comment  = "`e[38;2;90;102;115m"   # #5a6673 - untracked
$fg_constant = "`e[38;2;210;166;255m"  # #d2a6ff - stashed
$fg_error    = "`e[38;2;217;87;87m"    # #d95757 - conflicted
$reset       = "`e[0m"

function Invoke-Starship-PreCommand {
    $branch = git branch --show-current 2>$null
    if ($branch) {
        $env:GIT_BRANCH = "$( )$($branch.PadRight(4).Substring(0,4))$( )"
        if (Test-Path Env:GIT_SPACER) { Remove-Item Env:GIT_SPACER }
    } else {
        $env:GIT_SPACER = " "
        if (Test-Path Env:GIT_BRANCH) { Remove-Item Env:GIT_BRANCH }
    }

    $status = git status --porcelain 2>$null
    if ($status) {
        $modified  = ($status | Where-Object { $_ -match '^\s?M' }).Count
        $staged    = ($status | Where-Object { $_ -match '^M|^A' }).Count
        $untracked = ($status | Where-Object { $_ -match '^\?\?' }).Count
        $deleted   = ($status | Where-Object { $_ -match '^\s?D' }).Count

        $env:GIT_STATUS = "$($staged -gt 0    ? "${fg_string}+$staged " : '')$($modified -gt 0  ? "${fg_func}!$modified " : '')$($deleted -gt 0   ? "${fg_markup}-$deleted " : '')$($untracked -gt 0 ? "${fg_comment}?$untracked" : '')${reset}"
    } else {
        if (Test-Path Env:GIT_STATUS) { Remove-Item Env:GIT_STATUS }
    }
}

Invoke-Expression (&starship init powershell)
