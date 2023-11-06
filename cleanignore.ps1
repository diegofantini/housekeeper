$path = "$env:USERPROFILE\AppData\Local\Temp"

$items = Get-ChildItem -Path $path -Recurse -Attributes !Hidden

foreach ($item in $items) {
    Remove-Item -Path $item.FullName -Force -Confirm:$false -Recurse -ErrorAction Ignore
}

Write-Host "Foi deletado tudo que era possivel"
