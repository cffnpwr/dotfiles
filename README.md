# Dotfiles for cffnpwr

## About

My personal dotfiles repository.

## Usage

### Pre-requirements

- curl
- sudo and sudo privileges

### Install

```sh
curl -fsSL https://raw.githubusercontent.com/cffnpwr/dotfiles/main/install.sh | sh
```

## Architecture

```text
.
├── hosts/            # Host-specific configurations
├── modules/          # Modular configurations
│   ├── common/       # Common modules for all systems
│   ├── darwin/       # Modules specific to macOS
│   └── home-manager/ # Home Manager modules
│       ├── packages/ # Packages
│       ├── programs/ # Programs configurations
│       └── services/ # Services configurations
├── secrets           # Encrypted secrets
├── flake.nix         # Nix flake configuration
├── flake.lock        # Nix flake lock file
├── install.sh        # Installation script
└── README.md         # This file
```

## See Also

- [cffnpwr/nixpkgs](https://github.com/cffnpwr/nixpkgs) - My personal Nix packages repository.

## License

[MIT License](LICENSE)
