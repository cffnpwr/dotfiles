#!/usr/bin/env bash
set -eu
set -o pipefail

readonly USAGE='usage: install.sh [-h|--help] [-b|--branch <branch>] [--host <host>]'
readonly HELP="$USAGE

Install the Command Line Tools (macOS only) and Nix if missing, apply the dotfiles configuration,
and clone this repository with ghq.

options:
  -h, --help             show this help and exit
  -b, --branch <branch>  branch to apply and clone (default: the default branch)
  --host <host>          host configuration to apply (default: the host name)"
readonly NIX_INSTALLER_URL='https://install.determinate.systems/nix/tag/v3.24.2'
readonly NIX_DAEMON_PROFILE='/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
readonly NIX_CUSTOM_CONF='/etc/nix/nix.custom.conf'
readonly REPOSITORY='cffnpwr/dotfiles'
readonly CLT_DIR='/Library/Developer/CommandLineTools'
readonly CLT_ON_DEMAND_FILE='/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress'

# Command Line ToolsはHomebrewがbottleの無いformulaを導入するために必要なため導入
install_command_line_tools() (
  if [[ -e $CLT_DIR/usr/bin/git ]]; then
    exit 0
  fi
  trap 'sudo rm -f "$CLT_ON_DEMAND_FILE"' EXIT
  sudo touch "$CLT_ON_DEMAND_FILE"
  label=$(softwareupdate --list |
    sed -n 's/^\* Label: \(Command Line Tools.*\)$/\1/p' |
    sort -V |
    tail -n 1)
  if [[ -z $label ]]; then
    printf 'softwareupdate found no Command Line Tools; xcode-select --install installs them interactively\n' >&2
    exit 1
  fi
  sudo softwareupdate --install "$label"
)

setup_nix() {
  if [[ ! -e $NIX_DAEMON_PROFILE ]]; then
    curl --proto '=https' --tlsv1.2 -sSf -L "$NIX_INSTALLER_URL" |
      sh -s -- install --no-confirm
  fi
  # shellcheck source=/dev/null
  . "$NIX_DAEMON_PROFILE"
}

fetch_dotfiles() {
  local -r branch=${1:-}
  DOTFILES_FLAKE_REF="github:$REPOSITORY${branch:+?ref=$branch}" \
    nix eval --impure --raw --expr '(builtins.fetchTree (builtins.getEnv "DOTFILES_FLAKE_REF")).outPath'
}

# ghqの設定で指定したディレクトリにdotfilesをclone
clone_dotfiles() {
  local -r source_dir=$1
  local -r branch=${2:-}
  nix shell --inputs-from "$source_dir" nixpkgs#ghq nixpkgs#git --command \
    ghq get ${branch:+--branch "$branch"} "$REPOSITORY"
}

# nix-darwinの導入前に/etc/nix/nix.custom.confを退避
move_nix_custom_conf() {
  if [[ -f $NIX_CUSTOM_CONF && ! -L $NIX_CUSTOM_CONF ]]; then
    sudo mv "$NIX_CUSTOM_CONF" "$NIX_CUSTOM_CONF.before-nix-darwin"
  fi
}

exit_with_usage() {
  printf '%s\n' "$USAGE" >&2
  exit 1
}

main() {
  local branch=''
  local host=''
  while [[ $# -gt 0 ]]; do
    case "$1" in
    -h | --help)
      printf '%s\n' "$HELP"
      exit 0
      ;;
    -b | --branch)
      [[ $# -ge 2 ]] || exit_with_usage
      branch=$2
      shift 2
      ;;
    --host)
      [[ $# -ge 2 ]] || exit_with_usage
      host=$2
      shift 2
      ;;
    *)
      exit_with_usage
      ;;
    esac
  done

  local os
  os=$(uname -s)
  case "$os" in
  Darwin)
    install_command_line_tools
    setup_nix
    move_nix_custom_conf
    ;;
  Linux)
    if grep -Eq '^ID="?nixos"?$' /etc/os-release; then
      # NixOSの既定ではflakesが無効なため有効化
      export NIX_CONFIG='extra-experimental-features = nix-command flakes'
    else
      setup_nix
    fi
    ;;
  *)
    printf 'unsupported OS: %s (supported: Darwin, Linux)\n' "$os" >&2
    exit 1
    ;;
  esac

  local source_dir
  source_dir=$(fetch_dotfiles "$branch")
  "$source_dir/mise-tasks/apply" ${host:+"$host"}
  clone_dotfiles "$source_dir" "$branch"
}

main "$@"
