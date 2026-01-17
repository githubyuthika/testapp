# Backstage Docker Compose Deployment Script
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Deploy Backstage with Docker Compose" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Set-Location $PSScriptRoot

# Check if Docker is running
Write-Host "Checking Docker..." -ForegroundColor Yellow
docker info | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Docker is not running. Please start Docker Desktop." -ForegroundColor Red
    exit 1
}

# Check if image exists, if not build it
Write-Host "Checking for Backstage image..." -ForegroundColor Yellow
docker images backstage:latest -q | Out-Null
if (-not $?) {
    Write-Host "Image not found. Building..." -ForegroundColor Yellow
    .\build.ps1
    if ($LASTEXITCODE -ne 0) {
        exit 1
    }
}

# Start services
Write-Host "Starting services..." -ForegroundColor Yellow
docker-compose up -d

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host " Backstage is starting!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Backstage URL: http://localhost:7007" -ForegroundColor Cyan
    Write-Host "PostgreSQL: localhost:5432" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Check status: docker-compose ps" -ForegroundColor White
    Write-Host "View logs: docker-compose logs -f backstage" -ForegroundColor White
    Write-Host "Stop: docker-compose down" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host "Deployment failed!" -ForegroundColor Red
    exit 1
}
