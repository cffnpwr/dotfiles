{
  flake.modules.darwin.dollar-cmd = {
    homebrew = {
      taps = [
        {
          name = "cffnpwr/tap";
          trusted = true;
        }
      ];
      brews = [ "cffnpwr/tap/dollar-cmd" ];
    };
  };
}
