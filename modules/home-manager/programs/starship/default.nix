{ ... }:
{
  programs.starship = {
    enable = true;
    enableZshIntegration = false; # Managed by Sheldon

    settings = {
      format = builtins.concatStringsSep "" [
        "[░▒▓](#a3aed2)"
        "$os"
        "$hostname"
        "[](bg:#769ff0 fg:#a3aed2)"
        "$directory"
        "[](fg:#769ff0 bg:#394260)"
        "$git_branch"
        "$git_status"
        "[ ](fg:#394260 bg:#212736)"
        "$package"
        "$c"
        "$cmake"
        "$cobol"
        "$daml"
        "$dart"
        "$deno"
        "$dotnet"
        "$docker_context"
        "$elixir"
        "$elm"
        "$erlang"
        "$fennel"
        "$gleam"
        "$golang"
        "$guix_shell"
        "$haskell"
        "$haxe"
        "$helm"
        "$java"
        "$julia"
        "$kotlin"
        "$gradle"
        "$lua"
        "$nim"
        "$nodejs"
        "$ocaml"
        "$opa"
        "$perl"
        "$php"
        "$pulumi"
        "$purescript"
        "$python"
        "$quarto"
        "$raku"
        "$rlang"
        "$red"
        "$ruby"
        "$rust"
        "$scala"
        "$solidity"
        "$swift"
        "$terraform"
        "$typst"
        "$vlang"
        "$vagrant"
        "$zig"
        "$buf"
        "$nix_shell"
        "$conda"
        "$meson"
        "$spack"
        "$memory_usage"
        "$aws"
        "$gcloud"
        "$openstack"
        "$azure"
        "$nats"
        "[](fg:#212736)"
        "$fill"
        "[](fg:#1d2230)"
        "$time"
        "[](fg:#1d2230)"
        "\n$character"
      ];

      fill = {
        symbol = " ";
      };

      directory = {
        style = "fg:#e3e5e5 bg:#769ff0";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
        read_only = "󰌾 ";
        substitutions = {
          Documents = "󰈙 ";
          Downloads = " ";
          Music = " ";
          Pictures = " ";
        };
      };

      git_branch = {
        symbol = "";
        style = "bg:#394260";
        format = "[[ $symbol $branch ](fg:#769ff0 bg:#394260)]($style)";
      };

      git_status = {
        style = "bg:#394260";
        format = "[[($all_status$ahead_behind )](fg:#769ff0 bg:#394260)]($style)";
      };

      nodejs = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
      };

      rust = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol ($version) ](bold red bg:#212736)]($style)";
      };

      golang = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
      };

      php = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
      };

      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:#1d2230";
        format = "[[  $time ](fg:#a0a9cb bg:#1d2230)]($style)";
      };

      aws = {
        symbol = "  ";
        style = "bg:#212736";
      };

      buf = {
        symbol = " ";
        style = "bg:#212736";
      };

      c = {
        symbol = " ";
        style = "bg:#212736";
        format = "[via [\${symbol}(\${version} )](bg:#212736)]($style)";
      };

      conda = {
        symbol = " ";
        style = "bg:#212736";
      };

      crystal = {
        symbol = " ";
        style = "bg:#212736";
      };

      dart = {
        symbol = " ";
        style = "bg:#212736";
        format = "[via [\${symbol}(\${version} )](bg:#212736)]($style)";
      };

      docker_context = {
        symbol = " ";
        style = "bg:#212736";
        format = "[via [\${symbol}(\${version}\${context} )](blue bold bg:#212736)]($style)";
        detect_files = [
          "docker-compose.yml"
          "docker-compose.yaml"
          "compose.yaml"
          "compose.yml"
          "Dockerfile"
        ];
      };

      elixir = {
        symbol = " ";
        style = "bg:#212736";
        format = "[via [\${symbol}(\${version} )](bg:#212736)]($style)";
      };

      elm = {
        symbol = " ";
        style = "bg:#212736";
        format = "[via [\${symbol}(\${version} )](bg:#212736)]($style)";
      };

      fennel = {
        symbol = " ";
        style = "bg:#212736";
      };

      fossil_branch = {
        symbol = " ";
        style = "bg:#212736";
      };

      gradle = {
        symbol = " ";
        style = "bg:#212736";
        format = "[via [\${symbol}(\${version} )](bold bright-cyan bg:#212736)]($style)";
      };

      guix_shell = {
        symbol = " ";
        style = "bg:#212736";
      };

      haskell = {
        symbol = " ";
        style = "bg:#212736";
        format = "[via [\${symbol}(\${version} )](bg:#212736)]($style)";
      };

      haxe = {
        symbol = " ";
        style = "bg:#212736";
      };

      hg_branch = {
        symbol = " ";
        style = "bg:#212736";
      };

      hostname = {
        ssh_only = true;
        ssh_symbol = " ";
        style = "bg:#a3aed2 fg:#090c0c";
        format = "[$ssh_symbol$hostname]($style)";
      };

      java = {
        symbol = " ";
        style = "bg:#212736";
        format = "[via [\${symbol}(\${version} )](red dimmed bg:#212736)]($style)";
      };

      julia = {
        symbol = " ";
        style = "bg:#212736";
        format = "[via [\${symbol}(\${version} )](bg:#212736)]($style)";
      };

      kotlin = {
        symbol = " ";
        style = "bg:#212736";
        format = "[via [\${symbol}(\${version} )](bold blue bg:#212736)]($style)";
      };

      lua = {
        symbol = " ";
        style = "bg:#212736";
        format = "[via [\${symbol}(\${version} )](bg:#212736)]($style)";
      };

      memory_usage = {
        symbol = "󰍛 ";
        style = "bg:#212736";
      };

      meson = {
        symbol = "󰔷 ";
        style = "bg:#212736";
      };

      nim = {
        symbol = "󰆥 ";
        style = "bg:#212736";
        format = "[via [\${symbol}(\${version} )](bg:#212736)]($style)";
      };

      nix_shell = {
        symbol = " ";
        style = "bg:#212736";
      };

      ocaml = {
        symbol = " ";
        style = "bg:#212736";
        format = "[via [\${symbol}(\${version} )](bg:#212736)]($style)";
      };

      os = {
        disabled = false;
        format = "[ $symbol ](bg:#a3aed2 fg:#090c0c)";
        symbols = {
          Alpaquita = " ";
          Alpine = " ";
          AlmaLinux = " ";
          Amazon = " ";
          Android = " ";
          Arch = " ";
          Artix = " ";
          CentOS = " ";
          Debian = " ";
          DragonFly = " ";
          Emscripten = " ";
          EndeavourOS = " ";
          Fedora = " ";
          FreeBSD = " ";
          Garuda = "󰛓 ";
          Gentoo = " ";
          HardenedBSD = "󰞌 ";
          Illumos = "󰈸 ";
          Kali = " ";
          Linux = " ";
          Mabox = " ";
          Macos = " ";
          Manjaro = " ";
          Mariner = " ";
          MidnightBSD = " ";
          Mint = " ";
          NetBSD = " ";
          NixOS = " ";
          OpenBSD = "󰈺 ";
          openSUSE = " ";
          OracleLinux = "󰌷 ";
          Pop = " ";
          Raspbian = " ";
          Redhat = " ";
          RedHatEnterprise = " ";
          RockyLinux = " ";
          Redox = "󰀘 ";
          Solus = "󰠳 ";
          SUSE = " ";
          Ubuntu = " ";
          Unknown = " ";
          Void = " ";
          Windows = "󰍲 ";
        };
      };

      package = {
        symbol = "󰏗 ";
        format = "[is [$symbol$version]($style) ](bg:#212736)";
        style = "208 bold bg:#212736";
      };

      perl = {
        symbol = " ";
        style = "bg:#212736";
        format = "[via [\${symbol}(\${version} )](bg:#212736)]($style)";
      };

      pijul_channel = {
        symbol = " ";
        style = "bg:#212736";
      };

      python = {
        symbol = " ";
        style = "bg:#212736";
        format = "[via [\${symbol}(\${version} )](yellow bold bg:#212736)]($style)";
      };

      rlang = {
        symbol = "󰟔 ";
        style = "bg:#212736";
        format = "[via [\${symbol}(\${version} )](bg:#212736)]($style)";
      };

      ruby = {
        symbol = " ";
        style = "bg:#212736";
        format = "[via [\${symbol}(\${version} )](bg:#212736)]($style)";
      };

      scala = {
        symbol = " ";
        style = "bg:#212736";
        format = "[via [\${symbol}(\${version} )](bg:#212736)]($style)";
      };

      swift = {
        symbol = " ";
        style = "bg:#212736";
        format = "[via [\${symbol}(\${version} )](bg:#212736)]($style)";
      };

      zig = {
        symbol = " ";
        style = "bg:#212736";
        format = "[via [\${symbol}(\${version} )](bg:#212736)]($style)";
      };
    };
  };
}
