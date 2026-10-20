# Zielverzeichnis erstellen
New-Item -ItemType Directory -Force -Path "C:\terraform"

# Terraform herunterladen (Beispiel Version 1.7.5, x64)
$url = "https://releases.hashicorp.com/terraform/1.7.5/terraform_1.7.5_windows_amd64.zip"
$output = "C:\terraform\terraform.zip"

Invoke-WebRequest -Uri $url -OutFile $output

# Entpacken
Expand-Archive -Path $output -DestinationPath "C:\terraform" -Force

# ZIP-Datei löschen
Remove-Item $output

# Umgebungsvariable setzen
$oldPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
[Environment]::SetEnvironmentVariable("Path", "$oldPath;C:\terraform", "Machine")

# Umgebungsvariablen für aktuelle Session aktualisieren
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

# Check
terraform -version