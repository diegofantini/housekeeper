$sqlServices = Get-Service | Where-Object { $_.DisplayName -like "*SQL*" }

foreach ($service in $sqlServices) {
    $serviceName = $service.DisplayName
    try {
        Restart-Service -Name $service.ServiceName -Force
        Write-Host "O service $serviceName foi reiniciado com sucesso."
    } catch {
        Write-Host "Falha ao reiniciar o service $serviceName"
    }
}
