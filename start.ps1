# Backstage Startup Script
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Starting Backstage IDP" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Frontend: http://localhost:3000" -ForegroundColor Green
Write-Host "Backend:  http://localhost:7007" -ForegroundColor Green
Write-Host ""
Write-Host "First startup takes 2-3 minutes to compile..." -ForegroundColor Yellow
Write-Host "Look for 'webpack compiled successfully' message" -ForegroundColor Yellow
Write-Host ""
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Red
Write-Host ""

# Ensure we're in the script's directory
Set-Location $PSScriptRoot
Write-Host "Working directory: $(Get-Location)" -ForegroundColor Gray
Write-Host ""

# Start Backstage
& node .\.yarn\releases\yarn-4.4.1.cjs start
