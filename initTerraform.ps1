# 1. Parameter & Pfade definieren
$repoUrl   = "https://github.com/moon44-le/iac-vortrag.git" # Hier deine Repository-URL eintragen
$localPath = "C:\iac-vortrag-1"

# Guard Clause: Falls das Repo lokal noch fehlt, klonen wir es erst
if (-not (Test-Path -Path $localPath)) {
    Write-Host "Repository lokal nicht gefunden. Klone aus Git..." -ForegroundColor Yellow
    git clone $repoUrl $localPath
}

# 2. In den LOKALEN Arbeitsordner wechseln
Set-Location -Path $localPath

# 3. Code aus Git aktualisieren (falls schon vorhanden)
Write-Host "Aktualisiere Git-Repository..." -ForegroundColor Cyan
git pull

# 4. Terraform Workflow
Write-Host "1. Initialisiere Terraform..." -ForegroundColor Cyan
terraform init

Write-Host "2. Erstelle den Terraform Plan..." -ForegroundColor Cyan
terraform plan -out=tfplan

Write-Host "3. Wende die Konfiguration an (apply)..." -ForegroundColor Cyan
terraform apply -auto-approve tfplan