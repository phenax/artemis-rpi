{ config, options, ... }:
{
  imports = [ ./main.nix ];

  fileSystems = {
    "/" = {
      device = "/dev/disks/by-label/whatever";
      fsType = "ext4";
    };
  };
}
