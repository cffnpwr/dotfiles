{ ... }:
{
  system = {
    # The primaryUser property is required for macOS system defaults configuration
    # This property can be removed once the transition to the `users.users.*` namespace is complete.
    # Ref: https://github.com/nix-darwin/nix-darwin/issues/1462
    primaryUser = builtins.getEnv "USER";

    # macOS system defaults
    defaults = {
      dock = {
        autohide = true;
        orientation = "bottom";
      };

      finder = {
        AppleShowAllExtensions = true;
        FXEnableExtensionChangeWarning = false;
      };

      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        InitialKeyRepeat = 15;
        KeyRepeat = 2;
      };
    };
  };
}
