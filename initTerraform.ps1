# 1. In den lokalen Projektordner wechseln
Set-Location "C:\iac-vortrag-1"

# 2. Terraform Workflow ausführen
Write-Host "1. Initialisiere Terraform..." -ForegroundColor Cyan
terraform init

Write-Host "2. Erstelle den Terraform Plan..." -ForegroundColor Cyan
terraform plan -out=tfplan

Write-Host "3. Wende die Konfiguration an (apply)..." -ForegroundColor Cyan
terraform apply -auto-approve tfplan