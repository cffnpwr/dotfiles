#!/bin/zsh

set -o pipefail

# install
mise install

# gh command completion
if which gh > /dev/null; then
  if [ ! -d ~/.config/zsh/site-functions/ ]; then
    mkdir -p ~/.config/zsh/site-functions
  fi
  gh completion -s zsh > ~/.config/zsh/site-functions/_gh
fi