# Entspricht der Terraform Variable 'var.vm_ordner'
$VmOrdner = "C:\Hyper-V\VMs" 

# Sicherstellen, dass das Zielverzeichnis existiert
if (!(Test-Path -Path $VmOrdner)) {
    New-Item -ItemType Directory -Path $VmOrdner -Force | Out-Null
}

for ($i = 1; $i -le 3; $i++) {
    $vmName  = "server-$i"
    $vhdPath = Join-Path $VmOrdner "$vmName.vhdx"
    
    Write-Host "Verarbeite $vmName..." -ForegroundColor Cyan

    # 1. VHDX erstellen (Dynamic, 60 GB = 68719476736 Bytes)
    New-VHD -Path $vhdPath -SizeBytes 68719476736 -Dynamic | Out-Null
    
    # 2. VM erstellen (Generation 2, ohne direktes Startlaufwerk, da wir es gezielt per SCSI anhängen)
    New-VM -Name $vmName -Generation 2 -NoVHD | Out-Null
    
    # 3. Prozessoren konfigurieren (2 vCPUs)
    Set-VM -Name $vmName -ProcessorCount 2 | Out-Null
    
    # 4. Arbeitsspeicher konfigurieren (Statisch: 2 GB = 2147483648 Bytes)
    Set-VMMemory -VMName $vmName -StartupBytes 2147483648 -DynamicMemoryEnabled $false | Out-Null
    
    # 5. Festplatte an SCSI-Controller (Controller 0, Location 0) anbinden
    Add-VMHardDiskDrive -VMName $vmName -ControllerType SCSI -ControllerNumber 0 -ControllerLocation 0 -Path $vhdPath | Out-Null
    
    Write-Host "$vmName erfolgreich erstellt." -ForegroundColor Green
}