Import-Module ActiveDirectory

$numericProfiles = Get-ChildItem -Path C:\Users | Where-Object { $_.PSIsContainer -and $_.Name -match '^\d+$' }

if ($numericProfiles.Count -eq 0) {
    Write-Host "Nenhum perfil numerico encontrado."
} else {
    $numericUsers = @()

    foreach ($profile in $numericProfiles) {
        $samAccountName = $profile.Name

        try {
            $adUser = Get-ADUser -Filter { SamAccountName -eq $samAccountName -and Enabled -eq $true } -Properties SamAccountName, Sid, DistinguishedName -ErrorAction Stop
            $userSessionActive = quser | ForEach-Object {
                $sessionUser = ($_ -split '\s+')[1]
                if ($sessionUser -eq $adUser.SamAccountName) {
                    return $true
                }
            }

            if (-not $userSessionActive) {
                $numericUsers += $adUser
            }
        } catch {
            Write-Host "Erro ao obter info. do user $samAccountName no AD: $_"
            continue
        }
    }


    if ($numericUsers.Count -eq 0) {
        Write-Host "Nada a fazer por aqui."
    } else {
        
        foreach ($user in $numericUsers) {
            $userFolder = "C:\Users\$($user.SamAccountName)"

            try {
                Write-Host "Removendo arquivos do user: $($user.SamAccountName)"
                Remove-Item $userFolder -Force -Confirm:$false -Recurse -ErrorAction Stop
            } catch {
                Write-Host "Erro ao remover arquivos do user $($user.SamAccountName): $_"
                continue
            }

            $registryPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$($user.Sid)"

            try {
                Write-Host "Removendo entradas do Registro do user: $($user.SamAccountName)"
                Remove-Item -Path $registryPath -Force -Confirm:$false -Recurse -ErrorAction Stop
            } catch {
                Write-Host "Erro ao remover entradas do Registro do user $($user.SamAccountName): $_"
                continue
            }
        }

        Write-Host "Tudo pronto! Procedimento realizado com sucesso."
    }
}
