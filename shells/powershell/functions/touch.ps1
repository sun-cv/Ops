


function touch {
    if (Test-Path $args[0]) 
    {
        (Get-Item $args[0]).LastWriteTime = Get-Date
    } else {
        New-Item -Path $args[0] -ItemType File
    }
}
