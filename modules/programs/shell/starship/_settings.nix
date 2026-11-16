{
  format = "[░▒▓](#a3aed2)$os$hostname[](bg:#769ff0 fg:#a3aed2)$directory[](fg:#769ff0 bg:#394260)$git_branch$git_status[ ](fg:#394260 bg:#212736)$package$c$cmake$cobol$daml$dart$deno$dotnet$docker_context$elixir$elm$erlang$fennel$gleam$golang$guix_shell$haskell$haxe$helm$java$julia$kotlin$gradle$lua$nim$nodejs$ocaml$opa$perl$php$pulumi$purescript$python$quarto$raku$rlang$red$ruby$rust$scala$solidity$swift$terraform$typst$vlang$vagrant$zig$buf$nix_shell$conda$meson$spack$memory_usage$aws$gcloud$openstack$azure$nats[](fg:#212736)$fill[](fg:#1d2230)$time[](fg:#1d2230)\n$character";
  aws = {
    style = "bg:#212736";
    symbol = "  ";
  };
  buf = {
    style = "bg:#212736";
    symbol = " ";
  };
  c = {
    format = "[via [\${symbol}(\${version} )](bg:#212736)]($style)";
    style = "bg:#212736";
    symbol = " ";
  };
  conda = {
    style = "bg:#212736";
    symbol = " ";
  };
  crystal = {
    style = "bg:#212736";
    symbol = " ";
  };
  dart = {
    format = "[via [\${symbol}(\${version} )](bg:#212736)]($style)";
    style = "bg:#212736";
    symbol = " ";
  };
  directory = {
    format = "[ $path ]($style)";
    read_only = "󰌾 ";
    style = "fg:#e3e5e5 bg:#769ff0";
    truncation_length = 3;
    truncation_symbol = "…/";
    substitutions = {
      Documents = "󰈙 ";
      Downloads = " ";
      Music = " ";
      Pictures = " ";
    };
  };
  docker_context = {
    detect_files = [
      "docker-compose.yml"
      "docker-compose.yaml"
      "compose.yaml"
      "compose.yml"
      "Dockerfile"
    ];
    format = "[via [\${symbol}(\${version}\${context} )](blue bold bg:#212736)]($style)";
    style = "bg:#212736";
    symbol = " ";
  };
  elixir = {
    format = "[via [\${symbol}(\${version} )](bg:#212736)]($style)";
    style = "bg:#212736";
    symbol = " ";
  };
  elm = {
    format = "[via [\${symbol}(\${version} )](bg:#212736)]($style)";
    style = "bg:#212736";
    symbol = " ";
  };
  fennel = {
    style = "bg:#212736";
    symbol = " ";
  };
  fill = {
    symbol = " ";
  };
  fossil_branch = {
    style = "bg:#212736";
    symbol = " ";
  };
  git_branch = {
    format = "[[ $symbol $branch ](fg:#769ff0 bg:#394260)]($style)";
    style = "bg:#394260";
    symbol = "";
  };
  git_status = {
    format = "[[($all_status$ahead_behind )](fg:#769ff0 bg:#394260)]($style)";
    style = "bg:#394260";
  };
  golang = {
    format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
    style = "bg:#212736";
    symbol = "";
  };
  gradle = {
    format = "[via [\${symbol}(\${version} )](bold bright-cyan bg:#212736)]($style)";
    style = "bg:#212736";
    symbol = " ";
  };
  guix_shell = {
    style = "bg:#212736";
    symbol = " ";
  };
  haskell = {
    format = "[via [\${symbol}(\${version} )](bg:#212736)]($style)";
    style = "bg:#212736";
    symbol = " ";
  };
  haxe = {
    style = "bg:#212736";
    symbol = " ";
  };
  hg_branch = {
    style = "bg:#212736";
    symbol = " ";
  };
  hostname = {
    format = "[$ssh_symbol$hostname]($style)";
    ssh_only = true;
    ssh_symbol = " ";
    style = "bg:#a3aed2 fg:#090c0c";
  };
  java = {
    format = "[via [\${symbol}(\${version} )](red dimmed bg:#212736)]($style)";
    style = "bg:#212736";
    symbol = " ";
  };
  julia = {
    format = "[via [\${symbol}(\${version} )](bg:#212736)]($style)";
    style = "bg:#212736";
    symbol = " ";
  };
  kotlin = {
    format = "[via [\${symbol}(\${version} )](bold blue bg:#212736)]($style)";
    style = "bg:#212736";
    symbol = " ";
  };
  lua = {
    format = "[via [\${symbol}(\${version} )](bg:#212736)]($style)";
    style = "bg:#212736";
    symbol = " ";
  };
  memory_usage = {
    style = "bg:#212736";
    symbol = "󰍛 ";
  };
  meson = {
    style = "bg:#212736";
    symbol = "󰔷 ";
  };
  nim = {
    format = "[via [\${symbol}(\${version} )](bg:#212736)]($style)";
    style = "bg:#212736";
    symbol = "󰆥 ";
  };
  nix_shell = {
    style = "bg:#212736";
    symbol = " ";
  };
  nodejs = {
    format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
    style = "bg:#212736";
    symbol = "";
  };
  ocaml = {
    format = "[via [\${symbol}(\${version} )](bg:#212736)]($style)";
    style = "bg:#212736";
    symbol = " ";
  };
  os = {
    disabled = false;
    format = "[ $symbol ](bg:#a3aed2 fg:#090c0c)";
    symbols = {
      AlmaLinux = " ";
      Alpaquita = " ";
      Alpine = " ";
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
      OracleLinux = "󰌷 ";
      Pop = " ";
      Raspbian = " ";
      RedHatEnterprise = " ";
      Redhat = " ";
      Redox = "󰀘 ";
      RockyLinux = " ";
      SUSE = " ";
      Solus = "󰠳 ";
      Ubuntu = " ";
      Unknown = " ";
      Void = " ";
      Windows = "󰍲 ";
      openSUSE = " ";
    };
  };
  package = {
    format = "[is [$symbol$version]($style) ](bg:#212736)";
    style = "208 bold bg:#212736";
    symbol = "󰏗 ";
  };
  perl = {
    format = "[via [\${symbol}(\${version} )](bg:#212736)]($style)";
    style = "bg:#212736";
    symbol = " ";
  };
  php = {
    format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
    style = "bg:#212736";
    symbol = "";
  };
  pijul_channel = {
    style = "bg:#212736";
    symbol = " ";
  };
  python = {
    format = "[via [\${symbol}(\${version} )](yellow bold bg:#212736)]($style)";
    style = "bg:#212736";
    symbol = " ";
  };
  rlang = {
    format = "[via [\${symbol}(\${version} )](bg:#212736)]($style)";
    style = "bg:#212736";
    symbol = "󰟔 ";
  };
  ruby = {
    format = "[via [\${symbol}(\${version} )](bg:#212736)]($style)";
    style = "bg:#212736";
    symbol = " ";
  };
  rust = {
    format = "[[ $symbol ($version) ](bold red bg:#212736)]($style)";
    style = "bg:#212736";
    symbol = "";
  };
  scala = {
    format = "[via [\${symbol}(\${version} )](bg:#212736)]($style)";
    style = "bg:#212736";
    symbol = " ";
  };
  swift = {
    format = "[via [\${symbol}(\${version} )](bg:#212736)]($style)";
    style = "bg:#212736";
    symbol = " ";
  };
  time = {
    disabled = false;
    format = "[[  $time ](fg:#a0a9cb bg:#1d2230)]($style)";
    style = "bg:#1d2230";
    time_format = "%R";
  };
  zig = {
    format = "[via [\${symbol}(\${version} )](bg:#212736)]($style)";
    style = "bg:#212736";
    symbol = " ";
  };
}
