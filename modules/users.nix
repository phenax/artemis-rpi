{ config, lib, pkgs, ... }:
let
  secrets = import ../secrets.nix;
in
{
  services.openssh.permitRootLogin = "yes";
  users.users.root.password = secrets.installerPasswords.root;
}
