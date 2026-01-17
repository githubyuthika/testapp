# Backstage Deployment Guide

## 🚀 Deployment Options

This Backstage instance can be deployed using:
1. **Docker Compose** (Quick local/single-server deployment)
2. **Kubernetes** (Production-grade, scalable deployment)
3. **Cloud Platforms** (AWS, GCP, Azure)

---

## 🐳 Option 1: Docker Compose Deployment (Recommended for Testing)

### Prerequisites
- Docker Desktop installed and running
- 4GB+ RAM available

### Quick Deploy

```powershell
cd C:\cfc\backstage_demo\testapp
.\deploy-docker.ps1
```

### Manual Steps

1. **Build the Docker image**:
   ```powershell
   .\build.ps1
   ```

2. **Start services**:
   ```powershell
   docker-compose up -d
   ```

3. **Check status**:
   ```powershell
   docker-compose ps
   ```

4. **View logs**:
   ```powershell
   docker-compose logs -f backstage
   ```

5. **Access Backstage**:
   - URL: http://localhost:7007
   - Database: postgres:5432

6. **Stop services**:
   ```powershell
   docker-compose down
   ```

### Configuration

Edit `docker-compose.yml` to add your GitHub token:
```yaml
environment:
  GITHUB_TOKEN: ghp_your_token_here
```

---

## ☸️ Option 2: Kubernetes Deployment (Production)

### Prerequisites
- Kubernetes cluster (minikube, EKS, GKE, AKS)
- kubectl installed and configured
- Docker image built and pushed to registry

### Build & Push Image

```powershell
# Build
.\build.ps1

# Tag for your registry
docker tag backstage:latest your-registry/backstage:latest

# Push to registry
docker push your-registry/backstage:latest
```

### Update Kubernetes Manifests

Edit `kubernetes/backstage.yaml` and update the image:
```yaml
spec:
  containers:
    - name: backstage
      image: your-registry/backstage:latest
```

### Deploy

```powershell
cd C:\cfc\backstage_demo\testapp
.\deploy-k8s.ps1
```

### Manual Kubernetes Deployment

```powershell
# Create namespace
kubectl apply -f kubernetes/namespace.yaml

# Create storage
kubectl apply -f kubernetes/postgres-storage.yaml

# Create secrets
kubectl apply -f kubernetes/postgres-secret.yaml
kubectl apply -f kubernetes/backstage-secrets.yaml

# Deploy PostgreSQL
kubectl apply -f kubernetes/postgres.yaml

# Deploy Backstage
kubectl apply -f kubernetes/backstage.yaml
```

### Check Deployment

```powershell
# Check pods
kubectl get pods -n backstage

# View logs
kubectl logs -f deployment/backstage -n backstage

# Get service URL
kubectl get svc backstage -n backstage
```

### Access Backstage

For LoadBalancer:
```powershell
kubectl get svc backstage -n backstage
```

For port-forward (testing):
```powershell
kubectl port-forward svc/backstage 7007:80 -n backstage
```
Then access: http://localhost:7007

---

## ☁️ Option 3: Cloud Platform Deployment

### AWS (EKS)

1. **Create EKS cluster**:
   ```powershell
   eksctl create cluster --name backstage-cluster --region us-east-1
   ```

2. **Push image to ECR**:
   ```powershell
   aws ecr create-repository --repository-name backstage
   docker tag backstage:latest <aws-account>.dkr.ecr.us-east-1.amazonaws.com/backstage:latest
   docker push <aws-account>.dkr.ecr.us-east-1.amazonaws.com/backstage:latest
   ```

3. **Deploy using kubectl**:
   ```powershell
   .\deploy-k8s.ps1
   ```

### GCP (GKE)

1. **Create GKE cluster**:
   ```powershell
   gcloud container clusters create backstage-cluster --zone us-central1-a
   ```

2. **Push to GCR**:
   ```powershell
   docker tag backstage:latest gcr.io/<project-id>/backstage:latest
   docker push gcr.io/<project-id>/backstage:latest
   ```

3. **Deploy**:
   ```powershell
   .\deploy-k8s.ps1
   ```

### Azure (AKS)

1. **Create AKS cluster**:
   ```powershell
   az aks create --resource-group backstage-rg --name backstage-cluster
   ```

2. **Push to ACR**:
   ```powershell
   az acr create --resource-group backstage-rg --name backstageacr --sku Basic
   docker tag backstage:latest backstageacr.azurecr.io/backstage:latest
   docker push backstageacr.azurecr.io/backstage:latest
   ```

3. **Deploy**:
   ```powershell
   .\deploy-k8s.ps1
   ```

---

## 🔧 Production Configuration

### Update Secrets

**Kubernetes**: Edit `kubernetes/backstage-secrets.yaml`
```yaml
stringData:
  GITHUB_TOKEN: 'your-actual-github-token'
  POSTGRES_PASSWORD: 'strong-password-here'
```

**Docker Compose**: Edit `docker-compose.yml`
```yaml
environment:
  GITHUB_TOKEN: ${GITHUB_TOKEN}
```

### Update Production Config

Edit `app-config.production.yaml`:
```yaml
app:
  baseUrl: https://your-domain.com

backend:
  baseUrl: https://your-domain.com
  database:
    connection:
      password: ${POSTGRES_PASSWORD}
```

### Enable HTTPS

For production, use:
- **Kubernetes**: Ingress with cert-manager
- **Cloud**: Load balancer with SSL certificate
- **Docker**: Nginx reverse proxy

---

## 📊 Monitoring & Maintenance

### View Logs (Docker Compose)
```powershell
docker-compose logs -f backstage
```

### View Logs (Kubernetes)
```powershell
kubectl logs -f deployment/backstage -n backstage
```

### Scale Deployment (Kubernetes)
```powershell
kubectl scale deployment backstage --replicas=3 -n backstage
```

### Backup Database (Docker Compose)
```powershell
docker-compose exec postgres pg_dump -U backstage backstage > backup.sql
```

### Update Deployment
```powershell
# Rebuild image
.\build.ps1

# Restart services (Docker Compose)
docker-compose restart backstage

# Update deployment (Kubernetes)
kubectl rollout restart deployment/backstage -n backstage
```

---

## 🔍 Troubleshooting

### Check Container Status
```powershell
# Docker Compose
docker-compose ps

# Kubernetes
kubectl get pods -n backstage
```

### View Detailed Logs
```powershell
# Docker Compose
docker-compose logs --tail=100 backstage

# Kubernetes
kubectl describe pod <pod-name> -n backstage
```

### Connect to Database
```powershell
# Docker Compose
docker-compose exec postgres psql -U backstage

# Kubernetes
kubectl exec -it deployment/postgres -n backstage -- psql -U backstage
```

### Common Issues

1. **Container won't start**: Check logs for build errors
2. **Database connection failed**: Verify postgres is running
3. **Out of memory**: Increase Docker memory limit
4. **Port already in use**: Stop conflicting service

---

## 📚 Next Steps

1. **Configure Authentication**: Add OAuth providers in app-config
2. **Add Catalog Entities**: Import your services and components
3. **Install Plugins**: Extend functionality
4. **Set up CI/CD**: Automate deployments
5. **Configure Monitoring**: Add Prometheus/Grafana

For more information, see: https://backstage.io/docs/deployment/
