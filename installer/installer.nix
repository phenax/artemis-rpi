{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/sd-image-aarch64.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];

  hardware.enableRedistributableFirmware = true;

  sdImage = {
    compressImage = false;

    populateRootCommands = ''
      echo "--------------------------------------------------------";
      echo "-------------- Replacing firmware files ----------------";
      echo "--------------------------------------------------------";
      mkdir -p ./files/boot;
      cp -r ${./bootfiles}/* ./files/boot;
      echo "--------------------------------------------------------";
    '';
  };

  boot = {
    initrd.availableKernelModules = [ "uas" "sdhci_pci" "xhci_pci" "usbhid" "usb_storage" ];

    kernelParams = [
      "8250.nr_uarts=1"
      "console=ttyS0,115200n8"
      "console=ttyAMA0,115200n8"
      "console=tty0"
    ];
  };
}
