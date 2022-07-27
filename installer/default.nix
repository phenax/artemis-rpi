{ config, lib, pkgs, modulesPath, ... }:

let
  secrets = import ../secrets.nix;
in
{
  imports = [
    ./installer.nix
  ];

  # SSH
  services.sshd.enable = true;
  systemd.services.sshd.wantedBy = lib.mkOverride 40 [ "multi-user.target" ];
  services.openssh.permitRootLogin = "yes";

  # User setup
  users.users = {
    root = {
      password = secrets.installerPasswords.root;
    };
  };

  # Packages
  environment.systemPackages = with pkgs; [
    vim
    git
    curl
  ];

  # Networking wireless
  networking = {
    hostName = "artemis-live";
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

  documentation.nixos.enable = false;
  services.timesyncd.enable = true;
}
