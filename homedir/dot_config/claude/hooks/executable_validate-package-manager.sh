#!/bin/bash

# Package manager validation hook for Claude Code
# Prevents direct editing of package management files and suggests appropriate commands

# Extract the file path from the tool input
file_path=$(jq -r '.tool_input.file_path // empty' 2>/dev/null)

if [ -z "$file_path" ]; then
    exit 0
fi

# Get the basename of the file
filename=$(basename "$file_path")

# Function to detect package manager from lockfile
detect_package_manager() {
    local dir=$(dirname "$file_path")
    
    if [ -f "$dir/pnpm-lock.yaml" ]; then
        echo "pnpm"
    elif [ -f "$dir/yarn.lock" ]; then
        echo "yarn"
    elif [ -f "$dir/bun.lockb" ]; then
        echo "bun"
    elif [ -f "$dir/deno.lock" ]; then
        echo "deno"
    elif [ -f "$dir/package-lock.json" ]; then
        echo "npm"
    else
        echo "npm"  # Default fallback
    fi
}

# Function to get appropriate command suggestion
get_command_suggestion() {
    local file_type="$1"
    local package_manager="$2"
    
    case "$file_type" in
        "package.json")
            case "$package_manager" in
                "npm") echo "npm install <package>" ;;
                "yarn") echo "yarn add <package>" ;;
                "pnpm") echo "pnpm add <package>" ;;
                "bun") echo "bun add <package>" ;;
                "deno") echo "deno add <package>" ;;
            esac
            ;;
        "lockfile")
            case "$package_manager" in
                "npm") echo "npm install" ;;
                "yarn") echo "yarn install" ;;
                "pnpm") echo "pnpm install" ;;
                "bun") echo "bun install" ;;
                "deno") echo "deno install" ;;
            esac
            ;;
        "cargo")
            echo "cargo add <package>"
            ;;
        "cargo-lock")
            echo "cargo build または cargo update"
            ;;
        "go-mod")
            echo "go get <package>"
            ;;
        "go-sum")
            echo "go mod tidy"
            ;;
    esac
}

# Check JavaScript/TypeScript files
case "$filename" in
    "package.json")
        package_manager=$(detect_package_manager)
        command_suggestion=$(get_command_suggestion "package.json" "$package_manager")
        echo "{\"decision\": \"block\", \"reason\": \"package.jsonは${package_manager}パッケージマネージャで管理されています。依存関係の変更は '${command_suggestion}' コマンドを使用してください。\"}"
        exit 1
        ;;
    "package-lock.json")
        command_suggestion=$(get_command_suggestion "lockfile" "npm")
        echo "{\"decision\": \"block\", \"reason\": \"package-lock.jsonはnpmによって自動生成されるファイルです。依存関係の変更は '${command_suggestion}' コマンドを使用してください。\"}"
        exit 1
        ;;
    "yarn.lock")
        command_suggestion=$(get_command_suggestion "lockfile" "yarn")
        echo "{\"decision\": \"block\", \"reason\": \"yarn.lockはyarnによって自動生成されるファイルです。依存関係の変更は '${command_suggestion}' コマンドを使用してください。\"}"
        exit 1
        ;;
    "pnpm-lock.yaml")
        command_suggestion=$(get_command_suggestion "lockfile" "pnpm")
        echo "{\"decision\": \"block\", \"reason\": \"pnpm-lock.yamlはpnpmによって自動生成されるファイルです。依存関係の変更は '${command_suggestion}' コマンドを使用してください。\"}"
        exit 1
        ;;
    "bun.lockb")
        command_suggestion=$(get_command_suggestion "lockfile" "bun")
        echo "{\"decision\": \"block\", \"reason\": \"bun.lockbはbunによって自動生成されるファイルです。依存関係の変更は '${command_suggestion}' コマンドを使用してください。\"}"
        exit 1
        ;;
    "deno.lock")
        command_suggestion=$(get_command_suggestion "lockfile" "deno")
        echo "{\"decision\": \"block\", \"reason\": \"deno.lockはdenoによって自動生成されるファイルです。依存関係の変更は '${command_suggestion}' コマンドを使用してください。\"}"
        exit 1
        ;;
    "Cargo.toml")
        command_suggestion=$(get_command_suggestion "cargo")
        echo "{\"decision\": \"block\", \"reason\": \"Cargo.tomlはRustのパッケージマネージャcargoで管理されています。依存関係の変更は '${command_suggestion}' コマンドを使用してください。\"}"
        exit 1
        ;;
    "Cargo.lock")
        command_suggestion=$(get_command_suggestion "cargo-lock")
        echo "{\"decision\": \"block\", \"reason\": \"Cargo.lockはcargoによって自動生成されるファイルです。依存関係の変更は '${command_suggestion}' コマンドを使用してください。\"}"
        exit 1
        ;;
    "go.mod")
        command_suggestion=$(get_command_suggestion "go-mod")
        echo "{\"decision\": \"block\", \"reason\": \"go.modはGoのパッケージマネージャgo modで管理されています。依存関係の変更は '${command_suggestion}' コマンドを使用してください。\"}"
        exit 1
        ;;
    "go.sum")
        command_suggestion=$(get_command_suggestion "go-sum")
        echo "{\"decision\": \"block\", \"reason\": \"go.sumはgo modによって自動生成されるファイルです。依存関係の変更は '${command_suggestion}' コマンドを使用してください。\"}"
        exit 1
        ;;
esac

# Allow other files
exit 0