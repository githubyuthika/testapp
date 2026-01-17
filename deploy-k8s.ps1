# Backstage Kubernetes Deployment Script
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Deploy Backstage to Kubernetes" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Set-Location $PSScriptRoot

# Check kubectl
Write-Host "Checking kubectl..." -ForegroundColor Yellow
kubectl version --client | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "kubectl is not installed or not in PATH" -ForegroundColor Red
    exit 1
}

# Check cluster connection
Write-Host "Checking cluster connection..." -ForegroundColor Yellow
kubectl cluster-info | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Cannot connect to Kubernetes cluster" -ForegroundColor Red
    exit 1
}

# Apply Kubernetes manifests
Write-Host ""
Write-Host "Deploying to Kubernetes..." -ForegroundColor Yellow
Write-Host ""

Write-Host "  [1/6] Creating namespace..." -ForegroundColor Cyan
kubectl apply -f kubernetes/namespace.yaml

Write-Host "  [2/6] Creating PostgreSQL storage..." -ForegroundColor Cyan
kubectl apply -f kubernetes/postgres-storage.yaml

Write-Host "  [3/6] Creating PostgreSQL secrets..." -ForegroundColor Cyan
kubectl apply -f kubernetes/postgres-secret.yaml

Write-Host "  [4/6] Deploying PostgreSQL..." -ForegroundColor Cyan
kubectl apply -f kubernetes/postgres.yaml

Write-Host "  [5/6] Creating Backstage secrets..." -ForegroundColor Cyan
kubectl apply -f kubernetes/backstage-secrets.yaml

Write-Host "  [6/6] Deploying Backstage..." -ForegroundColor Cyan
kubectl apply -f kubernetes/backstage.yaml

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host " Deployment Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Check status:" -ForegroundColor Cyan
Write-Host "  kubectl get pods -n backstage" -ForegroundColor White
Write-Host ""
Write-Host "View logs:" -ForegroundColor Cyan
Write-Host "  kubectl logs -f deployment/backstage -n backstage" -ForegroundColor White
Write-Host ""
Write-Host "Get service URL:" -ForegroundColor Cyan
Write-Host "  kubectl get svc backstage -n backstage" -ForegroundColor White
Write-Host ""
