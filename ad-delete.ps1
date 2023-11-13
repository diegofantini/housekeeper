Import-Module ActiveDirectory


$allUsers = Get-ADUser -Filter {Enabled -eq $true} -Properties SamAccountName, Sid


$numericUsers = $allUsers | Where-Object { $_.SamAccountName -notmatch '\D' }

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
            
            Write-Host "Removendo user do AD: $($user.SamAccountName)"
            Remove-ADUser -Identity $user.SamAccountName -Confirm:$false

            
            $userFolder = "C:\Users\" + $user.SamAccountName
            Write-Host "Removendo arquivos do user: $($user.SamAccountName)"
            Remove-Item $userFolder -Force -Confirm:$false -Recurse -ErrorAction Ignore


            $registryPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$($user.Sid)"
            Write-Host "Removendo arquivos do registro do user: $($user.SamAccountName)"
            Remove-Item -Path $registryPath -Force -Confirm:$false -Recurse -ErrorAction Ignore
        } else {
            Write-Host "User $($user.SamAccountName) está atualmente logado e não será removido."
        }
    }
}
