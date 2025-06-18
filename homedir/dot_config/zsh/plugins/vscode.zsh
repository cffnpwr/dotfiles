#!/bin/zsh

if [[ ${TERM_PROGRAM} == "vscode" ]]; then
  source "$(code --locate-shell-integration-path zsh)"
  export VSCODE_SHELL_INTEGRATION=1
fi
