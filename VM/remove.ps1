# Alle VMs auf dem Host abrufen und nacheinander verarbeiten
foreach ($vm in Get-VM) {
    $vmName = $vm.Name
    
    # Die Festplattenpfade der aktuellen VM ermitteln
    $vhdPaths = $vm.Harddrives.Path
    
    Write-Host "Lösche VM '$vmName'..." -ForegroundColor Yellow
    
    # VM löschen (-Force schaltet sie bei Bedarf vorher automatisch aus)
    Remove-VM -VM $vm -Force
    
    # Die zugehörigen Festplattendateien löschen, falls Pfade vorhanden sind
    if ($vhdPaths) {
        Write-Host "Entferne zugehörige Festplatten für '$vmName'..." -ForegroundColor Cyan
        $vhdPaths | Remove-Item -Force
    }
}

Write-Host "`nAlle VMs und zugehörigen Festplatten wurden erfolgreich gelöscht." -ForegroundColor Green