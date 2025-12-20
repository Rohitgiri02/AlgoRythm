# AlgoRythm Docker Setup Script

Write-Host "==================================" -ForegroundColor Cyan
Write-Host "  AlgoRythm Docker Setup" -ForegroundColor Cyan  
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

# Check if Docker is installed
Write-Host "Checking Docker installation..." -ForegroundColor Yellow
try {
    $dockerVersion = docker --version
    Write-Host "✓ Docker found: $dockerVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ Docker not found. Please install Docker Desktop first." -ForegroundColor Red
    Write-Host "Download from: https://www.docker.com/products/docker-desktop/" -ForegroundColor Yellow
    exit 1
}

# Check if Docker is running
Write-Host "Checking if Docker is running..." -ForegroundColor Yellow
try {
    docker ps | Out-Null
    Write-Host "✓ Docker is running" -ForegroundColor Green
} catch {
    Write-Host "✗ Docker is not running. Please start Docker Desktop." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Starting AlgoRythm services..." -ForegroundColor Yellow
Write-Host ""

# Start services
docker-compose up -d

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "==================================" -ForegroundColor Green
    Write-Host "  Setup Complete!" -ForegroundColor Green
    Write-Host "==================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Services are starting up (this may take 30-60 seconds)..." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Access Points:" -ForegroundColor Cyan
    Write-Host "  Frontend:    http://localhost:3000" -ForegroundColor White
    Write-Host "  Backend API: http://localhost:8080/Algorythm" -ForegroundColor White
    Write-Host "  MySQL:       localhost:3306" -ForegroundColor White
    Write-Host ""
    Write-Host "Test Credentials:" -ForegroundColor Cyan
    Write-Host "  Email:    john@example.com" -ForegroundColor White
    Write-Host "  Password: password" -ForegroundColor White
    Write-Host ""
    Write-Host "Commands:" -ForegroundColor Cyan
    Write-Host "  View logs:  docker-compose logs -f" -ForegroundColor White
    Write-Host "  Stop:       docker-compose down" -ForegroundColor White
    Write-Host "  Restart:    docker-compose restart" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "Setup failed. Check the error messages above." -ForegroundColor Red
    Write-Host "Try running: docker-compose logs" -ForegroundColor Yellow
    exit 1
}
