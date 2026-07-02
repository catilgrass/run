$tempDir = "./run_script_temp"
$repoDir = "$tempDir/run"

Write-Host "Creating temporary directory..."
$null = New-Item -ItemType Directory -Path $tempDir -Force

Write-Host "Cloning https://github.com/catilgrass/run ..."
git clone "https://github.com/catilgrass/run" $repoDir

Write-Host "Removing unwanted files..."
Remove-Item -Path "$repoDir/README.md", "$repoDir/LICENSE" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$repoDir/.nojekyll", "$repoDir/index.html" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$repoDir/install" -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "Removing git data..."
Remove-Item -Path "$repoDir/.git" -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "Installing files..."
Get-ChildItem -Path $repoDir -Force | ForEach-Object {
    $dest = Join-Path (Get-Location) $_.Name
    if ($_.PSIsContainer) {
        Copy-Item -Path $_.FullName -Destination $dest -Recurse -Force
    } else {
        Copy-Item -Path $_.FullName -Destination $dest -Force
    }
}

Write-Host "Cleaning up temporary directory..."
[System.GC]::Collect()
Start-Sleep -Milliseconds 200
Remove-Item -Path $tempDir -Recurse -Force

Write-Host "Done!"
