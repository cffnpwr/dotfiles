{
  flake.modules.darwin.zsh =
    { config, pkgs, ... }:
    {
      programs.zsh = {
        # nixpkgsのzshをログインシェルとして使うために必要
        enable = true;
        # 補完とプロンプトはhome-managerで初期化するため無効化
        enableCompletion = false;
        enableBashCompletion = false;
        promptInit = "";
      };
      environment.shells = [ pkgs.zsh ];
      users.users.${config.system.primaryUser}.shell = pkgs.zsh;
    };

  flake.modules.homeManager.zsh =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      home.sessionVariables = {
        CVSEDITOR = "vim";
        EDITOR = "vim";
        GIT_EDITOR = "vim";
        SVN_EDITOR = "vim";
        LANG = "ja_JP.UTF-8";
        LANGUAGE = "ja_JP.UTF-8";
        LC_CTYPE = "en_US.UTF-8";
      };
      home.sessionPath = [
        "$HOME/.local/bin"
        "/usr/local/sbin"
        "/usr/local/bin"
      ];

      programs.zsh = {
        enable = true;
        enableCompletion = true;
        completionInit = ''autoload -Uz compinit && compinit -d "$XDG_STATE_HOME/zsh/zcompdump"'';
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        history = {
          path = "${config.xdg.stateHome}/zsh/.zsh_history";
          size = 1000;
          save = 100000;
          extended = true;
          ignoreDups = true;
          ignoreAllDups = true;
          ignoreSpace = true;
          saveNoDups = true;
          share = true;
        };

        setOptions = [
          "HIST_VERIFY"
          "HIST_REDUCE_BLANKS"
          "HIST_NO_STORE"
          "HIST_EXPAND"
          "LIST_PACKED"
          "NO_BEEP"
          "NO_BG_NICE"
          "NO_LIST_TYPES"
        ];

        localVariables.LISTMAX = 50;

        plugins = [
          {
            name = "zsh-navigation-tools";
            src = "${pkgs.zsh-navigation-tools}/share/zsh/site-functions";
          }
        ];

        initContent = lib.mkMerge [
          # compinitより前に実行する必要がある処理
          (lib.mkOrder 560 ''
            mkdir -p "$XDG_STATE_HOME/zsh"
            source ${pkgs.zsh-autocomplete}/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
          '')
          ''
            # スラッシュを単語の区切りとして扱う
            WORDCHARS="''${WORDCHARS//\/}"

            autoload -Uz chpwd_recent_dirs cdr add-zsh-hook && add-zsh-hook chpwd chpwd_recent_dirs

            bindkey "^A"          beginning-of-line
            bindkey "^E"          end-of-line
            bindkey "^[f"         forward-word
            bindkey "^[b"         backward-word
            bindkey "^[[1;3C"     forward-word
            bindkey "^[[1;3D"     backward-word
            bindkey "^[^?"        backward-kill-word
            bindkey "^[[killline" vi-kill-line
            bindkey "^I"          menu-select

            bindkey               "$terminfo[kcbt]" menu-select
            bindkey -M menuselect              "^I" menu-complete
            bindkey -M menuselect "$terminfo[kcbt]" reverse-menu-complete
          ''
        ];
      };

      home.packages = [ pkgs.zsh-completions ];
    };
}
