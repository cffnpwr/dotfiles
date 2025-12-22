#!/bin/sh

# contains code from and inspired by
# https://github.com/client9/shlib
# https://get.chezmoi.io

set -euo pipefail

# gum style definitions
export GUM_INPUT_PROMPT_FOREGROUND=7
export GUM_INPUT_PROMPT_BOLD=true
export GUM_INPUT_CURSOR_FOREGROUND=7
export GUM_INPUT_CURSOR_MODE=blink
export GUM_CHOOSE_HEADER_FOREGROUND=7
export GUM_CHOOSE_HEADER_BOLD=true
export GUM_CONFIRM_PROMPT_FOREGROUND=7
export GUM_CONFIRM_PROMPT_BOLD=true
export GUM_CONFIRM_SELECTED_FOREGROUND=0
export GUM_CONFIRM_SELECTED_BACKGROUND=15

# Default values
DOTFILES_REPO="cffnpwr/dotfiles"
DEFAULT_REPO_PATH="$HOME/.dotfiles"
DEFAULT_BRANCH="main"
GUM_VERSION="0.17.0"
JQ_VERSION="1.8.1"

# Global variables
TMP_DIR="$(mktemp -d)"
mkdir -p "${TMP_DIR}/bin"
PATH="${TMP_DIR}/bin:${PATH}"
trap 'rm -rf -- "${TMP_DIR}"' EXIT
REPO_PATH=""
BRANCH=""
HOSTNAME=""
SKIP_CONFIRM=false

# Check if a command exists
# $1: command name
_is_command() {
  command -v "$1" >/dev/null
}

# Download a file via HTTP(S) using curl
# $1: file path
# $2: source URL
# $3: optional header
_http_download() {
  local_file="$1"
  source_url="$2"
  header="${3:-}"

  code=""
  if [ -z "${header}" ]; then
    code="$(curl -w '%{http_code}' -fsSL -o "${local_file}" "${source_url}")"
  else
    code="$(curl -w '%{http_code}' -fsSL -H "${header}" -o "${local_file}" "${source_url}")"
  fi
  if [ "${code}" != "200" ]; then
    printf 'http_download_curl received HTTP status %s\n' "${code}" >&2
    exit 1
  fi
}

# Compute SHA-256 hash of a file
# $1: file path
# Outputs: SHA-256 hash to stdout
_hash_sha256() {
  if _is_command "sha256sum"; then
    sha256sum "$1" | tr '\t' ' ' | cut -d ' ' -f 1
  elif _is_command "shasum"; then
    shasum -a 256 "$1" | tr '\t' ' ' | cut -d ' ' -f 1
  elif _is_command "sha256"; then
    sha256 -q "$1" | tr '\t' ' ' | cut -d ' ' -f 1
  elif _is_command "openssl"; then
    openssl dgst -sha256 "$1" | tr '\t' ' ' | cut -d ' ' -f 2
  else
    echo "Error: No SHA-256 hashing command found" >&2
    exit 1
  fi
}

# Verify SHA-256 checksum of a file
# $1: file path
# $2: expected SHA-256 hash
# Exits with error if verification fails
_verify_sha256() {
  local_file="$1"
  expected_hash="$2"
  got_hash="$(_hash_sha256 "${local_file}")"

  if [ "${expected_hash}" != "${got_hash}" ]; then
    printf 'Error: SHA-256 checksum verification failed for %s\n' "${local_file}" >&2
    printf 'Expected: %s\n' "${expected_hash}" >&2
    printf 'Got: %s\n' "${got_hash}" >&2
    exit 1
  fi
}

# Print prompt and answer in styled format
# $1: prompt
# $2: answer
_echoback() {
  prompt="$1"
  answer="$2"

  printf '%s %s\n' \
    "$(gum style --bold --foreground 7 "$prompt")" \
    "$(gum style --foreground 7 "$answer")"
}

# Show usage information
_usage() {
  cat << EOF
Usage: install.sh [OPTIONS]

Options:
  -p, --path PATH         Clone destination path (default: $DEFAULT_REPO_PATH)
  -h, --hostname NAME     Hostname for this machine
  -b, --branch BRANCH     Git branch to clone (default: $DEFAULT_BRANCH)
  -y, --yes               Skip confirmation prompt
  --help                  Show this help message

Examples:
  install.sh
  install.sh --path ~/.config/dotfiles --hostname my-mac
  install.sh --branch feature/nix --yes
EOF
  exit 0
}

# Parse command-line arguments
# $@: arguments
#
# Sets global variables:
# REPO_PATH: repository clone path
# BRANCH: git branch to clone
# HOSTNAME: machine hostname
# SKIP_CONFIRM: whether to skip confirmation prompt
_parse_args() {
  while [ $# -gt 0 ]; do
    case "$1" in
      -p|--path)
        REPO_PATH="$2"
        shift 2
        ;;
      -h|--hostname)
        HOSTNAME="$2"
        shift 2
        ;;
      -b|--branch)
        BRANCH="$2"
        shift 2
        ;;
      -y|--yes)
        SKIP_CONFIRM=true
        shift
        ;;
      --help)
        _usage
        ;;
      *)
        echo "Error: Unknown option $1" >&2
        _usage
        ;;
    esac
  done
}

# Detect operating system
# Prints GOOS value to stdout
_get_goos() {
  goos=""
  os="$(uname -s | tr '[:upper:]' '[:lower:]')"
  case "${os}" in
    cygwin_nt*) goos="windows" ;;
    linux)
      case "$(uname -o | tr '[:upper:]' '[:lower:]')" in
        android) goos="android" ;;
        *) goos="linux" ;;
      esac
      ;;
    mingw*) goos="windows" ;;
    msys_nt*) goos="windows" ;;
    *) goos="${os}" ;;
  esac
  echo "${goos}"
}

# Detect system architecture
# Prints GOARCH value to stdout
_get_goarch() {
  goarch=""
  arch="$(uname -m)"
  case "${arch}" in
    aarch64) goarch="arm64" ;;
    armv*) goarch="arm" ;;
    i386) goarch="386" ;;
    i686) goarch="386" ;;
    i86pc) goarch="amd64" ;;
    x86) goarch="386" ;;
    x86_64) goarch="amd64" ;;
    *) goarch="${arch}" ;;
  esac
  echo "${goarch}"
}

# Check if the current platform is supported
# $1: GOOS/GOARCH combination
_check_platform_support() {
  case "$1" in
    linux/amd64) return 0 ;;
    linux/arm64) return 0 ;;
    darwin/amd64) return 0 ;;
    darwin/arm64) return 0 ;;
    *)
      printf 'Error: Unsupported platform: %s\n' "$1" >&2
      return 1
      ;;
  esac
}

# Check for pre-required dependencies
_check_dependencies() {
  _check_command "curl"
  _check_sudo
}

# Check for command existence
# $1: command name
_check_command() {
  if ! _is_command "$1"; then
    echo "Error: $1 is not installed. Please install $1 and try again." >&2
    exit 1
  fi
}

# Check for sudo availability
_check_sudo() {
  _check_command "sudo"
  if ! sudo -v 2> /dev/null; then
    echo "Error: sudo is required to run this installer." >&2
    exit 1
  fi
}

# Install required tools
_install_tools() {
  _install_gum
  _install_jq
}

# Install gum
_install_gum() {
  gum_os="$(printf '%s' "${OS}" | awk '{print toupper(substr($0,1,1)) tolower(substr($0,2))}')"
  gum_arch=""
  case "${ARCH}" in
    amd64) gum_arch="x86_64" ;;
    386) gum_arch="i386" ;;
    *) gum_arch="${ARCH}" ;;
  esac

  gum_tarball="gum_${GUM_VERSION}_${gum_os}_${gum_arch}.tar.gz"
  gum_tarball_url="https://github.com/charmbracelet/gum/releases/download/v${GUM_VERSION}/${gum_tarball}"

  checksums_url="https://github.com/charmbracelet/gum/releases/download/v${GUM_VERSION}/checksums.txt"

  _http_download "${TMP_DIR}/${gum_tarball}" "${gum_tarball_url}"
  _http_download "${TMP_DIR}/gum-checksums.txt" "${checksums_url}"

  expected="$(grep -E "${gum_tarball}\$" "${TMP_DIR}/gum-checksums.txt" | tr '\t' ' ' | cut -d ' ' -f 1)"
  if ! _verify_sha256 "${TMP_DIR}/${gum_tarball}" "${expected}"; then
    echo "Error: gum checksum verification failed" >&2
    exit 1
  fi

  tar -xzf "${TMP_DIR}/${gum_tarball}" -C "${TMP_DIR}"
  mv "${TMP_DIR}/${gum_tarball%.tar.gz}/gum" "${TMP_DIR}/bin/gum"
  chmod +x "${TMP_DIR}/bin/gum"

  gum log --level info "Installed $(${TMP_DIR}/bin/gum --version)"
}

# Install jq
_install_jq() {
  jq_os=""
  case "${OS}" in
    darwin) jq_os="macos" ;;
    *) jq_os="${OS}" ;;
  esac
  jq_arch="${ARCH}"

  jq_binary="jq-${jq_os}-${jq_arch}"
  jq_binary_url="https://github.com/jqlang/jq/releases/download/jq-${JQ_VERSION}/${jq_binary}"

  checksums_url="https://github.com/jqlang/jq/releases/download/jq-${JQ_VERSION}/sha256sum.txt"

  _http_download "${TMP_DIR}/${jq_binary}" "${jq_binary_url}"
  _http_download "${TMP_DIR}/jq-checksums.txt" "${checksums_url}"

  expected="$(grep -E "${jq_binary}\$" "${TMP_DIR}/jq-checksums.txt" | tr '\t' ' ' | cut -d ' ' -f 1)"
  if ! _verify_sha256 "${TMP_DIR}/${jq_binary}" "${expected}"; then
    echo "Error: jq checksum verification failed" >&2
    exit 1
  fi

  mv "${TMP_DIR}/${jq_binary}" "${TMP_DIR}/bin/jq"
  chmod +x "${TMP_DIR}/bin/jq"

  gum log --level info "Installed $(${TMP_DIR}/bin/jq --version)"
}

_install_nix() {
  # Check if Nix is installed with Determinate Nix Installer
  if _is_command "nix"; then
    nix_version="$(nix --version 2>/dev/null)"s

    if echo "$nix_version" | grep -q "Determinate Nix"; then
      gum log -l info "Nix (Determinate) is already installed: $nix_version"
      return 0
    fi

    gum log --level warn "Nix is installed but not by Determinate Nix Installer: $nix_version"
    gum log --level info "Reinstalling with Determinate Nix Installer..."
  else
    gum log --level info "Installing Nix using Determinate Nix Installer..."
  fi

  if ${SKIP_CONFIRM}; then
    export NIX_INSTALLER_NO_CONFIRM=true
  fi
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

  # Load Nix environment
  if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
    . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
  fi

  gum log --level info "Nix installed successfully"
}

# Extract hosts from flake.nix content
# $1: flake.nix content
# $2: platform (darwin or linux)
# Outputs: list of hostnames (one per line)
_extract_hosts_from_flake() {
  flake_content="$1"
  platform="$2"

  # Remove comments
  flake_no_comments=$(echo "$flake_content" | grep -vE '^\s*#')

  os_type=""
  case "$platform" in
    darwin) os_type="darwin" ;;
    linux) os_type="nixos" ;;
    *)
      echo "Error: Unsupported platform for host extraction: $platform" >&2;
      return 1 ;;
  esac
  pattern="(${os_type}Configurations\.)?\"?[a-zA-Z0-9_-]+\"?\s*=\s*([a-zA-Z0-9_-]+\.)*${os_type}System"
  echo "$flake_no_comments" | \
    grep -oE "$pattern" | \
    grep -oE '"?[a-zA-Z0-9_-]+"?\s*=' | \
    tr -d '"= '
}

# Gather user inputs
# Sets global variables:
# REPO_PATH: repository clone path
# BRANCH: git branch to clone
# HOSTNAME: machine hostname
_gather_user_inputs() {
  gum log --level info "Gathering configuration information..."

  # 1. Clone destination
  prompt_path="Clone dotfiles to:"
  if [ -z "${REPO_PATH}" ]; then
    REPO_PATH=$(gum input --placeholder "${DEFAULT_REPO_PATH}" --prompt "${prompt_path} " --value "${DEFAULT_REPO_PATH}")
  fi
  REPO_PATH="${REPO_PATH/#\~/$HOME}"
  _echoback "${prompt_path}" "${REPO_PATH}"

  # 2. Branch selection from GitHub API
  prompt_branch="Git branch to clone:"
  if [ -z "${BRANCH}" ]; then
    branches=$(
      curl -sSfL "https://api.github.com/repos/${DOTFILES_REPO}/branches" | jq -r '.[].name'
    )

    if [ -z "${branches}" ]; then
      gum log --level error "Failed to fetch branches from Github"
      exit 1
    fi

    BRANCH=$(echo "${branches}" | gum choose --header "${prompt_branch}")
  fi
  _echoback "${prompt_branch}" "${BRANCH}"

  # 3. Hostname selection
  prompt_hostname="Hostname for this machine:"
  if [ -z "${HOSTNAME}" ]; then
    # Fetch flake.nix from GitHub to extract existing hosts
    flake_content=$(
      curl -sSfL "https://api.github.com/repos/${DOTFILES_REPO}/contents/flake.nix?ref=${BRANCH}" | jq -r '.content' | base64 -d 2>/dev/null
    )

    if [ -z "${flake_content}" ]; then
      gum log --level error "Failed to fetch flake.nix"
      exit 1
    fi

    existing_hosts=$(_extract_hosts_from_flake "$flake_content" "$OS")
    hostnames="$existing_hosts\n<Create new host>"
    HOSTNAME=$(echo "$hostnames" | gum choose --header "${prompt_hostname}")

    if [ "$HOSTNAME" = "<Create new host>" ]; then
      detected_hostname=$(hostname -s 2>/dev/null || hostname | cut -d. -f1)
      detected_hostname=$(echo "$detected_hostname" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
      prompt_new_hostname="Enter new hostname:"
      HOSTNAME=$(gum input --placeholder "${detected_hostname}" --prompt "${prompt_new_hostname} " --value "${detected_hostname}")
    fi
  fi
  _echoback "${prompt_hostname}" "${HOSTNAME}"

  # 4. Confirmation
  prompt_confirm="Proceed with installation?"
  if ! "${SKIP_CONFIRM}"; then
    if ! gum confirm "${prompt_confirm}"; then
      _echoback "${prompt_confirm}: " "No"
      gum log --level warn "Installation cancelled."
      exit 0
    fi
  fi
  _echoback "${prompt_confirm}: " "Yes"
}

# Clone dotfiles repository
_clone_repository() {
  gum log --level info "Cloning dotfiles repository..."

  git="git"
  if ! _is_command "$git"; then
    git="nix run nixpkgs#git --"
  fi

  # Check if the target directory already exists
  if [ -d "${REPO_PATH}" ]; then
    gum log --level warn "Directory ${REPO_PATH} already exists"

    # Check if it's a git repository
    if [ -d "${REPO_PATH}/.git" ]; then
      gum log --level info "Existing git repository found. Updating..."
      cd "${REPO_PATH}"
      $git fetch origin
      $git checkout "${BRANCH}"
      $git pull origin "${BRANCH}"
    else
      gum log --level error "Directory exists but is not a git repository"
      exit 1
    fi
  else
    # Clone the repository
    $git clone --branch "${BRANCH}" "https://github.com/${DOTFILES_REPO}.git" "${REPO_PATH}"
  fi

  gum log --level info "Repository cloned successfully to ${REPO_PATH}"
}

# Decrypt age key
_decrypt_age_key() {
  key_file="${REPO_PATH}/key.txt.age"
  output_key="${XDG_CONFIG_HOME:-"$HOME/.config"}/age/key.txt"


  age="age"
  if ! _is_command "age"; then
    age="nix run nixpkgs#age --"
  fi

  if [ ! -f "${output_key}" ]; then
    gum log --level info "Decrypting age key..."

    # Ensure output directory exists
    mkdir -p "$(dirname "${output_key}")"

    # Decrypt the key with passphrase
    gum log --level info "Enter passphrase to decrypt age key:"
    if ! $age --decrypt -o "${output_key}" "${key_file}"; then
      gum log --level error "Failed to decrypt age key"
      exit 1
    fi
    # Set appropriate permissions
    chmod 600 "${output_key}"

    gum log --level info "Age key decrypted successfully to ${output_key}"
  fi

}

# Apply dotfiles configuration
_apply_dotfiles() {
  gum log --level info "Applying dotfiles configuration..."

  switch_cmd=""
  system_type=""
  case "${OS}" in
    darwin)
      system_type="nix-darwin"
      switch_cmd="nix run nix-darwin --"
      ;;
    linux)
      system_type="NixOS"
      switch_cmd="nixos-rebuild"
      ;;
    *)
      gum log --level error "Unsupported OS: ${OS}"
      exit 1
      ;;
  esac

  gum log --level info "Building ${system_type} configuration for host: ${HOSTNAME}..."
  sudo NIX_CONFIG="${NIX_CONFIG:-}" $switch_cmd switch --flake "${REPO_PATH}#${HOSTNAME}"

  gum log --level info "Dotfiles applied successfully!"
  gum log --level info "Please restart your machine to ensure all changes take effect"
}

_main() {
  OS="$(_get_goos)"
  ARCH="$(_get_goarch)"

  _parse_args "$@"
  _check_platform_support "${OS}/${ARCH}"
  _check_dependencies

  _install_tools
  _gather_user_inputs

  _install_nix
  _clone_repository
  _decrypt_age_key
  _apply_dotfiles
}

_main "$@"
