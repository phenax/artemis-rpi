{ config, lib, pkgs, ... }:
let
  secrets = import ../secrets.nix;
in
{
  # services.openssh.permitRootLogin = "no";

  networking = {
    firewall.allowedTCPPorts = [ 53 22000 ] ++ lib.attrValues secrets.tcpPorts;
    firewall.allowedUDPPorts = [ 53 22000 21027 ];
  };
}
