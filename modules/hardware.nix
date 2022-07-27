{ config, lib, pkgs, modulesPath, ... }:

let
  nixHardware = rec {
    ref = "936e4649098d6a5e0762058cb7687be1b2d90550";
    source = fetchTarball "https://github.com/NixOS/nixos-hardware/archive/${ref}.tar.gz";
  };
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    "${nixHardware.source}/raspberry-pi/4"
  ];

  boot = {
    initrd.availableKernelModules = [ "uas" "sdhci_pci" "xhci_pci" "usbhid" "usb_storage" ];

    kernelParams = [
      "8250.nr_uarts=1"
      "console=ttyS0,115200n8"
      "console=ttyAMA0,115200n8"
      "console=tty0"
    ];

    loader.grub.enable = false;
    loader.generic-extlinux-compatible.enable = true;
  };

  swapDevices = [ ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
}
