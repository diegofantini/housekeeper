$paths = @(
    "$env:USERPROFILE\Documents\teste1",
    "$env:USERPROFILE\Documents\teste2",
    "$env:USERPROFILE\Documents\teste3"
)

foreach ($path in $paths) {

    $items = Get-ChildItem -Path $path -Recurse -Attributes !Hidden

    foreach ($item in $items) {

        Remove-Item -Path $item.FullName -Force -Confirm:$false -Recurse
    }

    Write-Host "/Temp limpa com sucesso em $path."
}
