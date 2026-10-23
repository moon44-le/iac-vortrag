# Idempotentes PowerShell-Skript zur Erstellung/Sicherstellung von 3 Hyper-V VMs

# Entspricht der Terraform Variable 'var.vm_ordner'
$VmOrdner = "C:\Hyper-V\VMs" 

# 1. Zielverzeichnis prüfen & erstellen
if (!(Test-Path -Path $VmOrdner)) {
    Write-Host "Erstelle Zielverzeichnis $VmOrdner..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $VmOrdner -Force | Out-Null
}

for ($i = 1; $i -le 3; $i++) {
    $vmName  = "server-$i"
    $vhdPath = Join-Path $VmOrdner "$vmName.vhdx"
    $vhdSize = 68719476736 # 60 GB

    Write-Host "`n--- Prüfe Zustand für $vmName ---" -ForegroundColor Cyan

    # ---------------------------------------------------------
    # STEP 1: VHDX prüfen & erstellen
    # ---------------------------------------------------------
    if (!(Test-Path -Path $vhdPath)) {
        Write-Host "VHDX existiert nicht. Erstelle: $vhdPath" -ForegroundColor Yellow
        New-VHD -Path $vhdPath -SizeBytes $vhdSize -Dynamic | Out-Null
    } else {
        Write-Host "VHDX bereits vorhanden. Überspringe Erstellung." -ForegroundColor Green
    }

    # ---------------------------------------------------------
    # STEP 2: VM prüfen & erstellen
    # ---------------------------------------------------------
    $vm = Get-VM -Name $vmName -ErrorAction SilentlyContinue

    if ($null -eq $vm) {
        Write-Host "VM '$vmName' existiert nicht. Erstelle Generation 2 VM..." -ForegroundColor Yellow
        $vm = New-VM -Name $vmName -Generation 2 -NoVHD
    } else {
        Write-Host "VM '$vmName' bereits vorhanden." -ForegroundColor Green
    }

    # ---------------------------------------------------------
    # STEP 3: vCPUs prüfen & anpassen
    # ---------------------------------------------------------
    if ($vm.ProcessorCount -ne 2) {
        Write-Host "Passe vCPU-Anzahl auf 2 an..." -ForegroundColor Yellow
        Set-VM -Name $vmName -ProcessorCount 2 | Out-Null
    } else {
        Write-Host "vCPU-Anzahl korrekt (2)." -ForegroundColor Green
    }

    # ---------------------------------------------------------
    # STEP 4: RAM & Dynamischer Arbeitsspeicher prüfen & anpassen
    # ---------------------------------------------------------
    $mem = Get-VMMemory -VMName $vmName
    if ($mem.Startup -ne 2147483648 -or $mem.DynamicMemoryEnabled -eq $true) {
        Write-Host "Passe Arbeitsspeicher an (Statisch: 2 GB)..." -ForegroundColor Yellow
        Set-VMMemory -VMName $vmName -StartupBytes 2147483648 -DynamicMemoryEnabled $false | Out-Null
    } else {
        Write-Host "Arbeitsspeicher-Konfiguration korrekt (2 GB Statisch)." -ForegroundColor Green
    }

    # ---------------------------------------------------------
    # STEP 5: SCSI-Festplatte prüfen & anbinden
    # ---------------------------------------------------------
    $existingDisk = Get-VMHardDiskDrive -VMName $vmName | Where-Object { $_.Path -eq $vhdPath }

    if ($null -eq $existingDisk) {
        Write-Host "Binde VHDX an SCSI-Controller (0,0) an..." -ForegroundColor Yellow
        Add-VMHardDiskDrive -VMName $vmName -ControllerType SCSI -ControllerNumber 0 -ControllerLocation 0 -Path $vhdPath | Out-Null
    } else {
        Write-Host "VHDX ist bereits ordnungsgemäß angebunden." -ForegroundColor Green
    }
}

Write-Host "`nAlle 3 VMs entsprechen dem Soll-Zustand." -ForegroundColor Magenta