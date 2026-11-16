{
  # brew bundleはmasAppsの処理にHomebrewで導入したmasを要求するためhomebrewでmasを導入
  flake.modules.darwin.mas = {
    homebrew.brews = [ "mas" ];
  };
}
