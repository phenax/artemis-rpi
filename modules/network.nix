{ config, lib, pkgs, ... }:
let
  secrets = import ../secrets.nix;
in
{
  # Network
  networking = {
    hostName = "artemis";

    wireless = {
      enable = true;
      networks."${secrets.wireless.ssid}".psk = "${secrets.wireless.password}";
      interfaces = [ "wlan0" ];
    };

    useDHCP = false;
    interfaces.eth0.useDHCP = true;
    interfaces.wlan0.useDHCP = true;
  };

  systemd.services.wpa_supplicant.wantedBy = lib.mkOverride 10 [ "default.target" ];
}
