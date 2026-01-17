# Backstage Build and Deployment Script
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Backstage Build & Deploy" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Set-Location $PSScriptRoot

# Step 1: Install dependencies
Write-Host "[1/5] Installing dependencies..." -ForegroundColor Yellow
node .yarn/releases/yarn-4.4.1.cjs install --immutable
if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to install dependencies" -ForegroundColor Red
    exit 1
}

# Step 2: Type checking
Write-Host "[2/5] Running type checks..." -ForegroundColor Yellow
node .yarn/releases/yarn-4.4.1.cjs tsc
if ($LASTEXITCODE -ne 0) {
    Write-Host "Type check failed" -ForegroundColor Red
    exit 1
}

# Step 3: Build backend
Write-Host "[3/5] Building backend..." -ForegroundColor Yellow
node .yarn/releases/yarn-4.4.1.cjs build:backend
if ($LASTEXITCODE -ne 0) {
    Write-Host "Backend build failed" -ForegroundColor Red
    exit 1
}

# Step 4: Build Docker image
Write-Host "[4/5] Building Docker image..." -ForegroundColor Yellow
docker build -f packages/backend/Dockerfile -t backstage:latest .
if ($LASTEXITCODE -ne 0) {
    Write-Host "Docker build failed" -ForegroundColor Red
    exit 1
}

# Step 5: Done
Write-Host "[5/5] Build complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Docker image: backstage:latest" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  - For Docker Compose: docker-compose up -d" -ForegroundColor White
Write-Host "  - For Kubernetes: kubectl apply -f kubernetes/" -ForegroundColor White
Write-Host ""
