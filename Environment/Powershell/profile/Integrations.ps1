

function Invoke-Starship-PreCommand {
    $branch = git branch --show-current 2>$null
    if ($branch) {
        $env:GIT_BRANCH = "$([char]0xFEFF)$($branch.PadRight(4).Substring(0,4))$([char]0xFEFF)"
        Remove-Item Env:GIT_SPACER -ErrorAction SilentlyContinue
    } else {
        $env:GIT_SPACER = " "
        Remove-Item Env:GIT_BRANCH -ErrorAction SilentlyContinue
    }
}

Invoke-Expression (&starship init powershell)
