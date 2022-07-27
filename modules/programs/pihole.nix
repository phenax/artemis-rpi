{ config, lib, pkgs, ... }:
let
  secrets = import ../../secrets.nix;
in
{
  virtualisation.oci-containers.backend = "podman";

  virtualisation.oci-containers.containers.pihole = {
    image = "pihole/pihole:2022.05";
    ports = [
      "53:53/udp"
      "53:53/tcp"
      "80:${toString secrets.tcpPorts.pihole}/tcp"
    ];
    environment = {
      TZ = config.time.timeZone;
      WEB_PORT = "80";
      WEBPASSWORD = "toor";
      PIHOLE_DNS_ = "127.0.0.1#5353";
      REV_SERVER = "true";
      REV_SERVER_DOMAIN = "router.lan";
      REV_SERVER_TARGET = "192.168.1.1";
      REV_SERVER_CIDR = "192.168.1.0/16";
      DNSMASQ_LISTENING = "local";
    };
    extraOptions = [
      "--network=host"
    ];
  };

  # TODO: Create service for pihole configuration and starting
}
