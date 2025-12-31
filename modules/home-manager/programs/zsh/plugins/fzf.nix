{ pkgs, lib, ... }:
let
  mkFzfTool =
    {
      name,
      procedure,
      comment ? "",
      keyBinding ? "",
    }:
    let
      commentStr =
        if comment != "" then
          let
            lines = lib.splitString "\n" comment;
          in
          lib.concatMapStringsSep "\n" (line: "# " + line) lines + "\n"
        else
          "";
    in
    {
      inherit name keyBinding;
      function = ''
        ${commentStr}
        function ${name}() {
          ${procedure}
        }
        zle -N ${name}
      '';
    };

  fnDef = [
    {
      name = "fzf_history";
      procedure = ''
        BUFFER=$(history -r -n 1 | ${lib.getExe' pkgs.fzf "fzf"} --layout reverse --height 40% --query "$LBUFFER")
        CURSOR=$#BUFFER
        zle clear-screen
      '';
      comment = "Fuzzy search through command history";
      keyBinding = "^R";
    }
    {
      name = "fzf_cd_ghq";
      procedure = ''
        local selected_dir=$(${lib.getExe' pkgs.ghq "ghq"} list -p | ${lib.getExe' pkgs.fzf "fzf"} --layout reverse --height 40% --query "$LBUFFER")
        if [ -n "$selected_dir" ]; then
            BUFFER="${lib.getExe' pkgs.zoxide "z"} ''${selected_dir}"
            zle accept-line
        fi
      '';
      comment = "Fuzzy change directory to a ghq repository";
      keyBinding = "^X";
    }
    {
      name = "fzf_cd_git_worktree";
      procedure = ''
        local selected_dir=$(${lib.getExe' pkgs.git "git"} worktree list | ${lib.getExe' pkgs.fzf "fzf"} --layout reverse --height 40% --query "$LBUFFER")
        if [ -n "$selected_dir" ]; then
            local worktree_path=''${selected_dir%% *}
            BUFFER="${lib.getExe' pkgs.zoxide "z"} $worktree_path"
            zle accept-line
        fi
      '';
      comment = "Fuzzy change directory to a git worktree";
      keyBinding = "^G";
    }
  ];
  functions = builtins.map mkFzfTool fnDef;
in
{
  xdg.configFile."zsh/plugins/fzf.zsh".text = ''
    #!${lib.getExe' pkgs.zsh "zsh"}

    # fzf plugin functions for zsh

    ${lib.concatMapStringsSep "\n\n" (fn: fn.function) functions}

    # Bindings
    ${lib.concatMapStringsSep "\n" (fn: "bindkey '${fn.keyBinding}' ${fn.name}") (
      builtins.filter (fn: fn.keyBinding != "") functions
    )}
  '';
}
