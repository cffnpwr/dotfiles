{
  flake.modules = {
    darwin.base = { ... }: {
      system.stateVersion = "7";
    };

    homeManager.base = { ... }: {
      home.stateVersion = "26.11";
    };
  };
}
