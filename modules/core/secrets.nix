{ inputs, ... }:
{
  flake.modules.homeManager.secrets =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      identity = "${config.xdg.configHome}/age/key.txt";
    in
    {
      imports = [ inputs.agenix.homeManagerModules.default ];

      age.identityPaths = [ identity ];

      # age鍵が無い場合だけ、パスフレーズを入力して復号
      home.activation.decryptAgeIdentity = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        if [[ ! -f ${lib.escapeShellArg identity} ]]; then
          run mkdir -p ${lib.escapeShellArg (dirOf identity)}
          run ${lib.getExe pkgs.age} --decrypt --output ${lib.escapeShellArg identity} ${../../secrets/identity.age}
          run chmod 600 ${lib.escapeShellArg identity}
        fi
      '';
    };
}
