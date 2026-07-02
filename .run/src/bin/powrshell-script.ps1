Write-Host ""
Write-Host '  Welcome to use `run.sh` / `run.ps1`'
Write-Host ""
Write-Host '  > "Hello World"'
Write-Host "  > cwd  : `"$(Get-Location)`""
$items = ($args | ForEach-Object { "`"$_`"" }) -join ", "
Write-Host "  > args : $items"
Write-Host ""
