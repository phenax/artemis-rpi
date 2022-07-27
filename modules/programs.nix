{ config, lib, pkgs, ... }:
{
  services.sshd.enable = true;
  systemd.services.sshd.wantedBy = lib.mkOverride 40 [ "multi-user.target" ];
  services.openssh.permitRootLogin = "yes";

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  environment.systemPackages = with pkgs; [
    wget
    curl
    bc
    jq
    unzip
    file
    gotop
    libraspberrypi
  ];

  programs.bash = {
    enableCompletion = true;
    enableLsColors = true;
    loginShellInit = '''';
    shellInit = '''';
  };
}
