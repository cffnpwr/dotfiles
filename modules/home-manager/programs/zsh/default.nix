{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./plugins
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = false; # Managed by Sheldon

    dotDir = "${config.xdg.configHome}/zsh"; # zsh設定を~/.config/zsh/に配置

    # Shell aliases
    shellAliases = {
      # eza aliases
      ei = "eza --icons --git";
      ea = "eza -a --icons --git";
      ee = "eza -aahl --icons --git";
      et = "eza -T -L 3 -a -I 'node_modules|.git|.cache' --icons";
      eta = "eza -T -a -I 'node_modules|.git|.cache' --color=always --icons | less -r";
      ls = "ei";
      la = "ea";
      ll = "ee";
      lt = "et";
      lta = "eta";
      l = "clear && ls";
    };

    # Environment variables
    sessionVariables = {
      # XDG Base Directory
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";

      # Language
      LANGUAGE = "ja_JP.UTF-8";
      LANG = "ja_JP.UTF-8";
      LC_CTYPE = "ja_JP.UTF-8";

      # Editor
      EDITOR = "vim";
      CVSEDITOR = "vim";
      SVN_EDITOR = "vim";
      GIT_EDITOR = "vim";
    }
    // lib.optionalAttrs pkgs.stdenv.isDarwin {
      # SSH Agent (macOS only)
      SSH_AUTH_SOCK = "$HOME/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock";
    };

    # zshenv (ログインシェル/非ログインシェル共通の環境設定)
    envExtra = ''
      # 重複排除
      typeset -Ug path PATH fpath FPATH

      # PATH設定
      path=(
        $HOME/.local/bin(N-/)
        /usr/local/sbin(N-/)
        /usr/local/bin(N-/)
        $path
      )

      # mise - use shims for non-interactive shells, activate for interactive shells
      eval "$(mise activate zsh)"
      path=(
        $HOME/.local/share/mise/shims(N-/)
        $path
      )
    '';

    # zprofile (ログインシェル用の設定)
    profileExtra = ''
      # mise shims
      eval "$(mise activate zsh --shims)"
    '';

    # zshrc (インタラクティブシェル用の設定)
    initContent = ''
      # Sheldon plugin manager with caching
      cache_dir=''${XDG_CACHE_HOME:-$HOME/.cache}
      sheldon_cache="$cache_dir/sheldon.zsh"
      sheldon_toml="$HOME/.config/sheldon/plugins.toml"
      # キャッシュがない、またはキャッシュが古い場合にキャッシュを作成
      if [[ ! -r "$sheldon_cache" || "$sheldon_toml" -nt "$sheldon_cache" ]]; then
        mkdir -p $cache_dir
        sheldon source > $sheldon_cache
      fi
      source "$sheldon_cache"
      # 使い終わった変数を削除
      unset cache_dir sheldon_cache sheldon_toml

      # History settings
      # システムのHISTFILE設定を上書き
      export HISTFILE=''${XDG_STATE_HOME}/zsh/.zsh_history
      # メモリに保存される履歴の件数
      export HISTSIZE=1000
      # 履歴ファイルに保存される履歴の件数
      export SAVEHIST=100000
      export HISTFILESIZE=100000

      # 重複を記録しない
      setopt hist_ignore_dups
      # 開始と終了を記録
      setopt EXTENDED_HISTORY
      # ヒストリに追加されるコマンド行が古いものと同じなら古いものを削除
      setopt hist_ignore_all_dups
      # スペースで始まるコマンド行はヒストリリストから削除
      setopt hist_ignore_space
      # ヒストリを呼び出してから実行する間に一旦編集可能
      setopt hist_verify
      # 余分な空白は詰めて記録
      setopt hist_reduce_blanks
      # 古いコマンドと同じものは無視
      setopt hist_save_no_dups
      # historyコマンドは履歴に登録しない
      setopt hist_no_store
      # 保管時にヒストリを自動的に展開
      setopt hist_expand
      # history共有
      setopt share_history

      # Other zsh settings
      # zshの補完候補が画面から溢れ出る時、それでも表示するか確認
      export LISTMAX=50
      # バックグラウンドジョブの優先度(ionice)をbashと同じ挙動に
      unsetopt bg_nice
      # 補完候補を詰めて表示
      setopt list_packed
      # ピープオンを鳴らさない
      setopt no_beep
      # ファイル種別起動を補完候補の末尾に表示しない
      unsetopt list_types
      # スラッシュを区切り文字に含める
      export WORDCHARS="''${WORDCHARS//\/}"
    '';
  };
}
