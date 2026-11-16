{
  flake.modules.darwin.pam = {
    security.pam.services.sudo_local.touchIdAuth = true;
  };
}
