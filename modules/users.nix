{ config, lib, pkgs, ... }:
let
  secrets = import ../secrets.nix;
in
{
  # users.mutableUsers = false;

  # TODO: Remove root login?
  services.openssh.permitRootLogin = "yes";
  users.users.root.password = secrets.installerPasswords.root;

  # TODO: Set encrypted password via config
  users.users.artemis = {
    isNormalUser = true;
    shell = pkgs.bash;
    extraGroups = [
      "wheel"
      "syncthing"
      "gpio"
    ];
    openssh.authorizedKeys.keys = secrets.ssh.authorizedKeys;
  };
}
