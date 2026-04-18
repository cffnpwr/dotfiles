{ pkgs, lib, config, ... }:

{
  config = lib.mkIf pkgs.stdenv.isDarwin {
    services.kanata = {
      enable = true;
      configSource = pkgs.writeText "kanata.kbd" ''
        (defcfg
          process-unmapped-keys yes
        )

        (defsrc
          esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
          grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
          tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
          caps a    s    d    f    g    h    j    k    l    ;    '    ret
          lsft z    x    c    v    b    n    m    ,    .    /    rsft
          lctl lalt lmet spc                      rmet fn   ralt
        )

        (defalias
          ;; 右Commandをタップでかなキー(lang1)、長押しでCmd
          rkna (tap-hold-release 200 200 Lang1 rmet)

          ;; 左Commandをタップで英数キー(lang2)、長押しでCmd
          leis (tap-hold-release 200 200 Lang2 lmet)

          ;; fnキーでレイヤー切り替え
          fn (tap-hold 250 250 fn (layer-toggle fn))
        )

        (deflayer base
          esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
          grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
          tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
          lctl a    s    d    f    g    h    j    k    l    ;    '    ret
          lsft z    x    c    v    b    n    m    ,    .    /    rsft
          lctl lalt @leis spc                     @rkna @fn  ralt
        )

        (deflayer fn
          esc  brdn brup mctl sls  dtn  dnd  prev pp   next mute vold volu
          _    _    _    _    _    _    _    _    _    _    _    _    _    _
          _    _    _    _    _    _    _    _    _    _    _    _    _    _
          _    _    _    _    _    _    _    _    _    _    _    _    _
          _    _    _    _    _    _    _    _    _    _    _    _
          _    _    _    _                        _    _    _
        )
      '';
      daemon.enable = true;
    };
  };
}
