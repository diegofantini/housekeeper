Import-Module ActiveDirectory

$userProfiles = Get-ChildItem -Path C:\Users -Directory

$numericProfiles = $userProfiles | Where-Object { $_.PSIsContainer -and $_.Name -match '^\d+$' }

if ($numericProfiles.Count -eq 0) {
    Write-Host "Nenhum perfil numerico encontrado."
} else {
    $numericUsers = @()

    
    foreach ($profile in $numericProfiles) {
        $samAccountName = $profile.Name

        
        $userSessionActive = quser | Where-Object { ($_.Split(' '))[1] -eq $samAccountName }

        
        if (-not $userSessionActive) {
            $numericUsers += New-Object PSObject -Property @{
                SamAccountName = $samAccountName
                Sid = $profile.Name
            }
        }
    }

    
    if ($numericUsers.Count -eq 0) {
        Write-Host "Nada a fazer por aqui."
    } else {
        
        foreach ($user in $numericUsers) {
            $userFolder = "C:\Users\$($user.SamAccountName)"

            
            try {
                Write-Host "Removendo arquivos do user: $($user.SamAccountName)"
                Remove-Item -Path $userFolder -Force -Recurse -ErrorAction Stop
            } catch {
                Write-Host "Erro ao remover arquivos do user $($user.SamAccountName): $_"
                continue
            }

            
            $registryPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$($user.Sid)"

            try {
                Write-Host "Removendo Registro do user: $($user.SamAccountName)"
                Remove-Item -Path $registryPath -Force -Recurse -ErrorAction Stop
            } catch {
                Write-Host "Erro ao remover Registro do user $($user.SamAccountName): $_"
                continue
            }
        }

        Write-Host "Tudo pronto! Procedimento realizado com sucesso."
    }
}
