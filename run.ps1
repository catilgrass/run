Set-Location -Path (Split-Path -Parent $MyInvocation.MyCommand.Path) -ErrorAction Stop

$tools = @{}

if (Test-Path ".run/src/bin/*.cs") {
    Get-ChildItem -Path ".run/src/bin/*.cs" | ForEach-Object {
        $tools[$_.BaseName] = @{ Type = "cs"; Path = $_.FullName }
    }
}

if (Test-Path ".run/src/bin/*.rs") {
    Get-ChildItem -Path ".run/src/bin/*.rs" | ForEach-Object {
        $tools[$_.BaseName] = @{ Type = "rs"; Path = $_.FullName }
    }
}

if (Test-Path ".run/src/bin/*.py") {
    Get-ChildItem -Path ".run/src/bin/*.py" | ForEach-Object {
        $tools[$_.BaseName] = @{ Type = "py"; Path = $_.FullName }
    }
}

if (Test-Path ".run/src/bin/*.ps1") {
    Get-ChildItem -Path ".run/src/bin/*.ps1" | ForEach-Object {
        $tools[$_.BaseName] = @{ Type = "ps1"; Path = $_.FullName }
    }
}

if ($args.Count -eq 0) {
    $sorted = $tools.Keys | Sort-Object
    $total = $sorted.Count
    $num_w = $total.ToString().Length

    $max_name = ($sorted | ForEach-Object { $_.Length } | Measure-Object -Maximum).Maximum

    $inner_w = 2 + $num_w + 1 + 1 + $max_name + 2 + 10 + 1 + 2
    if ($inner_w -lt 38) { $inner_w = 38 }

    $title = '.\run.ps1 <NUMBER/NAME> [ARGS...]'
    $title_len = $title.Length
    $dash_total = $inner_w - 2 - $title_len
    $dash_left = [Math]::Floor($dash_total / 2)
    $dash_right = $dash_total - $dash_left

    Write-Host ("┌" + ("─" * $dash_left) + " " + $title + " " + ("─" * $dash_right) + "┐")
    Write-Host ("│" + (" " * $inner_w) + "│")

    $i = 1
    foreach ($name in $sorted) {
        $type = $tools[$name].Type
        $lang = switch ($type) {
            "cs"  { "C#" }
            "py"  { "Python" }
            "rs"  { "Rust" }
            "ps1" { "PowerShell" }
        }
        $entry = "  " + $i.ToString().PadRight($num_w) + ") " + $name.PadRight($max_name) + " [$lang]"
        Write-Host ("│" + $entry.PadRight($inner_w) + "│")
        $i++
    }

    Write-Host ("│" + (" " * $inner_w) + "│")
    Write-Host ("└" + ("─" * $inner_w) + "┘")
    exit 1
}

$target_name = $args[0]

if ($target_name -match '^\d+$') {
    $sorted = $tools.Keys | Sort-Object
    $idx = [int]$target_name - 1
    if ($idx -ge 0 -and $idx -lt $sorted.Count) {
        $target_name = $sorted[$idx]
    } else {
        Write-Host "Error: invalid number '$target_name', valid range is 1-$($sorted.Count)"
        exit 1
    }
}

if (-not $tools.ContainsKey($target_name)) {
    Write-Host "Error: target '$target_name' does not exist"
    exit 1
}

$script_args = $args[1..$args.Count]
$info = $tools[$target_name]

switch ($info.Type) {
    "ps1" {
        & $info.Path @script_args
    }
    "py" {
        python $info.Path $script_args
    }
    "rs" {
        if (-not (Test-Path ".run/Cargo.toml")) {
@"
[package]
name = "run_rust"
version = "0.1.0"
edition = "2024"

[workspace]

[dependencies]
"@ | Set-Content -Path ".run/Cargo.toml"
        }
        cargo build --manifest-path ".run/Cargo.toml" --target-dir ".run/target" --bin $target_name --quiet
        $binary = ".run/target/debug/$target_name.exe"
        if (-not (Test-Path $binary)) {
            $binary = ".run/target/debug/$target_name"
        }
        & $binary $script_args
    }
    "cs" {
        $temp_dir = ".run/target/csproj/$target_name"
        $null = New-Item -ItemType Directory -Path $temp_dir -Force

        $props_content = @'
<Project>
  <PropertyGroup>
    <BaseOutputPath>$(MSBuildThisFileDirectory)../../csharp/bin</BaseOutputPath>
    <BaseIntermediateOutputPath>$(MSBuildThisFileDirectory)../../csharp/obj</BaseIntermediateOutputPath>
  </PropertyGroup>
</Project>
'@
        Set-Content -Path "$temp_dir/Directory.Build.props" -Value $props_content

        $csproj_content = @"
<Project Sdk="Microsoft.NET.Sdk">

    <PropertyGroup>
        <OutputType>Exe</OutputType>
        <TargetFramework>net8.0</TargetFramework>
        <ImplicitUsings>enable</ImplicitUsings>
        <Nullable>enable</Nullable>
    </PropertyGroup>

</Project>
"@
        Set-Content -Path "$temp_dir/$target_name.csproj" -Value $csproj_content
        Copy-Item -Path $info.Path -Destination "$temp_dir/Program.cs" -Force

        dotnet run --project "$temp_dir/$target_name.csproj" -- $script_args
    }
}
