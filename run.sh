#!/bin/bash

cd "$(dirname "$0")" || exit 1

declare -A tools

for file in .run/src/bin/*.cs; do
    if [ -f "$file" ]; then
        name=$(basename "$file" .cs)
        tools["$name"]="cs"
    fi
done

for file in .run/src/bin/*.rs; do
    if [ -f "$file" ]; then
        name=$(basename "$file" .rs)
        tools["$name"]="rs"
    fi
done

for file in .run/src/bin/*.py; do
    if [ -f "$file" ]; then
        name=$(basename "$file" .py)
        tools["$name"]="py"
    fi
done

for file in .run/src/bin/*.sh; do
    if [ -f "$file" ]; then
        name=$(basename "$file" .sh)
        tools["$name"]="sh"
    fi
done

if [ $# -eq 0 ]; then
    sorted_names=($(echo "${!tools[@]}" | tr ' ' '\n' | sort))
    total=${#sorted_names[@]}
    num_w=${#total}

    max_name=0
    for name in "${sorted_names[@]}"; do
        len=${#name}
        ((len > max_name)) && max_name=$len
    done

    inner_w=$((2 + num_w + 1 + 1 + max_name + 2 + 6 + 1 + 2))
    ((inner_w < 38)) && inner_w=38

    title="./run.sh <NUMBER/NAME> [ARGS...]"
    title_len=${#title}
    dash_total=$((inner_w - 2 - title_len))
    dash_left=$((dash_total / 2))
    dash_right=$((dash_total - dash_left))

    echo "┌$(printf '─%.0s' $(seq 1 $dash_left)) $title $(printf '─%.0s' $(seq 1 $dash_right))┐"
    printf "│%*s│\n" $inner_w ""

    i=1
    for name in "${sorted_names[@]}"; do
        type="${tools[$name]}"
        case "$type" in
            cs) lang="C#";;
            py) lang="Python";;
            rs) lang="Rust";;
            sh) lang="Shell";;
        esac
        entry=$(printf "  %-*d) %-*s [%s]" $num_w $i $max_name $name $lang)
        printf "│%-*s│\n" $inner_w "$entry"
        i=$((i + 1))
    done

    printf "│%*s│\n" $inner_w ""
    echo "└$(printf '─%.0s' $(seq 1 $inner_w))┘"
    exit 1
fi

target_name="$1"
shift

if [[ "$target_name" =~ ^[0-9]+$ ]]; then
    sorted=($(echo "${!tools[@]}" | tr ' ' '\n' | sort))
    idx=$((target_name - 1))
    if [ "$idx" -ge 0 ] && [ "$idx" -lt "${#sorted[@]}" ]; then
        target_name="${sorted[$idx]}"
    else
        echo "Error: invalid number '$target_name', valid range is 1-${#sorted[@]}"
        exit 1
    fi
fi

if [ -z "${tools[$target_name]}" ]; then
    echo "Error: target '$target_name' does not exist"
    exit 1
fi

type="${tools[$target_name]}"

case "$type" in
    sh)
        chmod +x ".run/src/bin/$target_name.sh"
        ".run/src/bin/$target_name.sh" "$@"
        ;;
    py)
        python ".run/src/bin/$target_name.py" "$@"
        ;;
    rs)
        if [ ! -f ".run/Cargo.toml" ]; then
            cat > ".run/Cargo.toml" <<'EOF'
[package]
name = "run_rust"
version = "0.1.0"
edition = "2024"

[workspace]

[dependencies]
EOF
        fi
        cargo build --manifest-path ".run/Cargo.toml" --target-dir ".run/target" --bin "$target_name" --quiet
        ".run/target/debug/$target_name" "$@"
        ;;
    cs)
        temp_dir=".run/target/csproj/$target_name"
        mkdir -p "$temp_dir"
        cat > "$temp_dir/Directory.Build.props" <<'PROPS'
<Project>
  <PropertyGroup>
    <BaseOutputPath>$(MSBuildThisFileDirectory)../../csharp/bin</BaseOutputPath>
    <BaseIntermediateOutputPath>$(MSBuildThisFileDirectory)../../csharp/obj</BaseIntermediateOutputPath>
  </PropertyGroup>
</Project>
PROPS
        cat > "$temp_dir/$target_name.csproj" <<'CSPROJ'
<Project Sdk="Microsoft.NET.Sdk">

    <PropertyGroup>
        <OutputType>Exe</OutputType>
        <TargetFramework>net8.0</TargetFramework>
        <ImplicitUsings>enable</ImplicitUsings>
        <Nullable>enable</Nullable>
    </PropertyGroup>

</Project>
CSPROJ
        cp ".run/src/bin/$target_name.cs" "$temp_dir/Program.cs"
        dotnet run --project "$temp_dir/$target_name.csproj" -- "$@"
        ;;
esac
