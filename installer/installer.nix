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
      echo "-------------- Replacing firmware files... ----------------";
      mkdir -p ./files/boot;
      cp -r ${./firmware}/* ./files/boot;
      echo "";
      echo "------------------- Copying config... ---------------------";
      mkdir -p ./files/etc/nixos/config;
      cp -r \
        `ls -A -d ${./..}/* | grep -E -v '/(nixpkgs|output|result)$'` \
        ./files/etc/nixos/config/;
      echo "-----------------------------------------------------------";
    '';
  };

  boot = {
    initrd.availableKernelModules = [
      "uas"
      "sdhci_pci"
      "xhci_pci"
      "usbhid"
      "usb_storage"
    ];

    kernelParams = [
      "8250.nr_uarts=1"
      "console=ttyS0,115200n8"
      "console=ttyAMA0,115200n8"
      "console=tty0"
    ];
  };
}
