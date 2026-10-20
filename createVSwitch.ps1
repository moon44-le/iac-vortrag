# Erstellt einen komplett isolierten Switch
New-VMSwitch -Name "vSwitch-Private" `
             -SwitchType Private `
             -Notes "Privater Switch für isolierte Testlabore (z.B. Test-Active-Directory)"