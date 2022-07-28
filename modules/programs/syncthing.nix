{ config, lib, pkgs, ... }:
let
  secrets = import ../../secrets.nix;
  username = "artemis";
  dataDir = "${config.users.users."${username}".home}/syncthing";
  devices = {
    dickhead = "dickhead";
    sakomadik = "sakomadik";
  };
  allDevices = lib.attrValues devices;
in
{
  users.groups.syncthing = { };

  services.syncthing = {
    enable = true;
    user = username;
    dataDir = dataDir;
    guiAddress = "0.0.0.0:${toString secrets.syncthing.gui.port}";
    overrideDevices = true;
    overrideFolders = true;

    devices = {
      "${devices.dickhead}" = {
        id = secrets.syncthing.devices."${devices.dickhead}";
      };
      "${devices.sakomadik}" = {
        id = secrets.syncthing.devices."${devices.sakomadik}";
      };
    };

    folders = {
      artemis-others = {
        path = "${dataDir}/others";
        devices = allDevices;
      };
      artemis-photos = {
        path = "${dataDir}/photos";
        devices = allDevices;
      };
    };

    extraOptions = {
      gui = {
        enabled = true;
        theme = "black";
        user = secrets.syncthing.gui.username;
        password = secrets.syncthing.gui.password;
      };
    };
  };
}
