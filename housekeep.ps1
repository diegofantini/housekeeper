$serviceName = "SQL Server (PRONIM_DW)"

#Function pra listar os cpfs com active session
function QueryUser($userName) {
    $userSession = quser | ForEach-Object {
        $user = ($_ -split '\s+')[1]
        if ($user -eq $userName) {
            return $true
        }
    }
    return $userSession
}

#Deletando cpf users
$localUsers = Get-LocalUser

$numericUsers = $localUsers | Where-Object { $_.Name -match "^[0-9]+$" -and -not (QueryUser $_.Name) }

if ($numericUsers.Count -eq 0) {
    Write-Host "Não foram encontrados users com CPF."
} else {
    foreach ($user in $numericUsers) {
      $sid = $user | Select-Object -Expand SID
      Get-WmiObject Win32_UserProfile -Filter "sid='${sid}'" | ForEach-Object {$_.Delete()}
      Remove-LocalUser -InputObject $user -Confirm:$false
      Write-Host "O usuario local $($user.Name) foi removido com sucesso."
    }
}

#####################################################################################################

#Higienizando IIS
$items = Get-ChildItem -Path $path -Recurse -Attributes !Hidden

foreach ($item in $items) {
    Remove-Item -Path $item.FullName -Force -Confirm:$false -Recurse
}

Write-Host "Logs IIS higienizados."

#####################################################################################################

#Reiniciando service DB
try {
Restart-Service -Name $serviceName -Force
Write-Host "O serviço $serviceName foi reiniciado com sucesso."
} catch {
Write-Host "Falha ao reiniciar o serviço $serviceName"
}