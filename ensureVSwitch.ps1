$SwitchName  = "vSwitch-External"
$AdapterName = "Ethernet"
$DesiredType = "External"
$Notes       = "Erstellt via IaC (Terraform-Logik)"

# 1. IST-ZUSTAND PRÜFEN (Entspricht dem Terraform "Refresh" / "Read")
$existingSwitch = Get-VMSwitch -Name $SwitchName -ErrorAction SilentlyContinue

if (-not $existingSwitch) {
    # ERSTELLEN: Wenn der Switch noch nicht existiert (Terraform "Create")
    Write-Host "-> Switch '$SwitchName' nicht gefunden. Erstelle neuen Switch..." -ForegroundColor Yellow
    
    New-VMSwitch -Name $SwitchName `
                 -NetAdapterName $AdapterName `
                 -AllowManagementOS $true `
                 -Notes $Notes
                 
    Write-Host "-> Switch erfolgreich erstellt." -ForegroundColor Green
    return
}

# 2. ABGLEICH: Existiert er, stimmen die Eigenschaften überein? (Terraform "Plan / Update")
Write-Host "-> Switch '$SwitchName' existiert bereits. Prüfe Konfiguration..." -ForegroundColor Cyan

$needsUpdate = $false

if ($existingSwitch.SwitchType -ne $DesiredType) {
    Write-Host "   [!] Abweichung erkannt: SwitchType ist '$($existingSwitch.SwitchType)',soll aber '$DesiredType' sein." -ForegroundColor Yellow
    $needsUpdate = $true
}

if ($needsUpdate) {
    # HINWEIS: Bei Hyper-V müssen manche Switches neu erstellt werden, wenn sich Kernparameter ändern.
    Write-Host "-> Aktualisiere Switch (Löschen & Neu erstellen wegen geänderter Parameter)..." -ForegroundColor Yellow
    Remove-VMSwitch -Name $SwitchName -Force
    
    New-VMSwitch -Name $SwitchName `
                 -NetAdapterName $AdapterName `
                 -AllowManagementOS $true `
                 -Notes $Notes
                 
    Write-Host "-> Switch erfolgreich aktualisiert." -ForegroundColor Green
} else {
    Write-Host "-> Ist-Zustand entspricht dem Soll-Zustand. Keine Aktion erforderlich." -ForegroundColor Green
}