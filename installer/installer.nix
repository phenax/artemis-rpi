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

  systemd.services.artemis-init = {
    description = "Setup new configuration";

    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    requires = [ "network-online.target" ];

    restartIfChanged = false;
    unitConfig.X-StopOnRemoval = false;

    script =
      let
        configurationFile = pkgs.writeText "configuration.nix" ''
          { config, lib, pkgs, ... }:
          {
            imports = [
              ./hardware-configuration.nix
              ./config/main.nix
            ];
          }
        '';
        path = pkgs.lib.makeBinPath [
          config.nix.package
          pkgs.systemd
          pkgs.gnugrep
          pkgs.git
          pkgs.gnutar
          pkgs.gzip
          pkgs.gnused
          config.system.build.nixos-rebuild
          config.system.build.nixos-generate-config
        ];
      in
      ''#!${pkgs.runtimeShell} -eu

        export PATH=${path}:$PATH
        export NIX_PATH=nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos:nixos-config=/etc/nixos/configuration.nix:/nix/var/nix/profiles/per-user/root/channels

        nixos-generate-config;
        cp ${configurationFile} /etc/nixos/configuration.nix

        if [ -f /etc/nixos/channels ]; then
          cp /etc/nixos/config/channels /root/.nix-channels
          nix-channel --update;
        fi;

        nixos-rebuild switch;
      '';

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };
}
