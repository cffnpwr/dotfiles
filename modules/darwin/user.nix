{ config, lib, ... }:
{
  homeDirectory = lib.mkDefault "/Users/${config.username}";
}
