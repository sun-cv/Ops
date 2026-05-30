function Get-Token {
    param(
        [string]$ClientId,
        [string]$ClientSecret
    )

    $TOKEN = (Invoke-RestMethod -Method Post `
      -Uri "https://api.airbyte.com/v1/applications/token" `
      -ContentType "application/json" `
      -Body "{`"client_id`": `"$ClientId`", `"client_secret`": `"$ClientSecret`"}").access_token

    $global:TOKEN = $TOKEN
    Write-Host "Token exported."
}
