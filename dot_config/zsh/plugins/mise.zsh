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

# chezmoi command completion
if which chezmoi > /dev/null; then
  if [ ! -d ~/.config/zsh/site-functions/ ]; then
    mkdir -p ~/.config/zsh/site-functions
  fi
  chezmoi completion zsh > ~/.config/zsh/site-functions/_chezmoi
fi

# bw command completion
if which bw > /dev/null; then
  if [ ! -d ~/.config/zsh/site-functions/ ]; then
    mkdir -p ~/.config/zsh/site-functions
  fi
  bw completion --shell zsh > ~/.config/zsh/site-functions/_bw
fi
