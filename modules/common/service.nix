{ ... }:
{
  config = {
    services = {
      tailscale = {
        enable = true;
        overrideLocalDns = true;
      };
    };
  };
}
