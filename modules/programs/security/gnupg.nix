{
  flake.modules.homeManager.gnupg =
    { lib, ... }:
    {
      programs.gpg.enable = true;

      # gpgはパーミッションの緩い~/.gnupgを拒否するので権限を700に設定
      home.activation.gnupgDirectoryPermission = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run install -d -m 700 "$HOME/.gnupg"
      '';
    };
}
