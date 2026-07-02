$tempDir = "./run_script_temp"
$repoDir = "$tempDir/run"

Write-Host "Creating temporary directory..."
$null = New-Item -ItemType Directory -Path $tempDir -Force

Write-Host "Cloning https://github.com/catilgrass/run ..."
git clone "https://github.com/catilgrass/run" $repoDir

Write-Host "Installing files..."
Copy-Item -Path "$repoDir/run.sh" -Destination (Get-Location) -Force
Copy-Item -Path "$repoDir/run.ps1" -Destination (Get-Location) -Force
Copy-Item -Path "$repoDir/.run" -Destination (Get-Location) -Recurse -Force

Write-Host "Cleaning up..."
[System.GC]::Collect()
Start-Sleep -Milliseconds 200
Remove-Item -Path $tempDir -Recurse -Force

Write-Host "Done!"
