Write-Host "Starting PM2 Ecosystem..." -ForegroundColor Green

Set-Location (Join-Path $env:DIR_OPS "\services\PM2")

pm2 start ecosystem.config.js
pm2 save

Write-Host "PM2 Ecosystem started successfully!" -ForegroundColor Green
pm2 status

Write-Host $env:PATH
where.exe pm2
