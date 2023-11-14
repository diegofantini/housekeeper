Import-Module ActiveDirectory


$numericUsers = Get-ADUser -Filter {Enabled -eq $true} -Properties SamAccountName, Sid |
                Where-Object { $_.SamAccountName -notlike '*[a-zA-Z]*' }

if ($numericUsers.Count -eq 0) {
    Write-Host "Nenhum user numerico ativo encontrado."
} else {
    
    foreach ($user in $numericUsers) {
        $isSessionActive = quser | ForEach-Object {
            $sessionUser = ($_ -split '\s+')[1]
            if ($sessionUser -eq $user.SamAccountName) {
                return $true
            }
        }

        if (-not $isSessionActive) {

            $userFolder = "C:\Users\" + $user.SamAccountName
            Write-Host "Removendo arquivos do user: $($user.SamAccountName)"
            Remove-Item $userFolder -Force -Confirm:$false -Recurse -ErrorAction Ignore

            
            $registryPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$($user.Sid)"
            Write-Host "Removendo arquivos do registro do user: $($user.SamAccountName)"
            Remove-Item -Path $registryPath -Force -Confirm:$false -Recurse -ErrorAction Ignore
        } else {
            Write-Host "User $($user.SamAccountName) esta atualmente logado e nao sera removido."
        }
    }
}
