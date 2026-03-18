Write-Host "Starting PM2 Ecosystem..." -ForegroundColor Green

Set-Location "C:\Ops\Services\PM2"

pm2 start ecosystem.config.js
pm2 save

Write-Host "PM2 Ecosystem started successfully!" -ForegroundColor Green
pm2 status
