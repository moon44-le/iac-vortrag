$VHDs = (Get-VM -Name "VM-Name").Harddrives.Path
Remove-VM -Name "VM-Name" -Force
$VHDs | Remove-Item -Force