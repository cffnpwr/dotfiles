{ pkgs, lib, ... }:

{
  config = lib.mkIf pkgs.stdenv.isDarwin {
    programs.kmonad = {
      enable = true;

      keyboards = {
        macbook = {
          device = "Flow84-L@Lofree ";

          defcfg = {
            enable = true;
            fallthrough = true;
            allowCommands = false;
          };

          config = ''
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
              rkna (tap-hold-next-release 200 lang1 rmet)

              ;; 左Commandをタップで英数キー(lang2)、長押しでCmd
              leis (tap-hold-next-release 200 lang2 lmet)
            )

            (deflayer base
              esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
              grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
              tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
              lctl a    s    d    f    g    h    j    k    l    ;    '    ret
              lsft z    x    c    v    b    n    m    ,    .    /    rsft
              lctl lalt @leis spc                     @rkna fn  ralt
            )
          '';
        };
      };
    };
  };
}
