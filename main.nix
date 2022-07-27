{ config, lib, pkgs, ... }:
{
  imports = [
    ./modules/hardware.nix
    ./modules/network.nix
    ./modules/programs.nix
    ./modules/users.nix
  ];

  # Core
  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";
  services.timesyncd.enable = true;
  documentation.nixos.enable = false;
}
