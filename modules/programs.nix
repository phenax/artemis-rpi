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

  programs.git = {
    enable = true;
    config = rec {
      user = {
        email = "phenax5@gmail.com";
        name = "Akshay Nair";
        # signingKey = "---";
      };
      # commit.gpgSign = true;
      author = user;
      init = {
        defaultBranch = "main";
      };
      pull = { rebase = false; };
    };
  };

  programs.bash = {
    enableCompletion = true;
    enableLsColors = true;
    loginShellInit = '''';
    shellInit = '''';
  };

  environment.shellAliases = {
    pihole = "sudo podman exec pihole pihole";

    # Git
    gcm = "git commit -m";
    gst = "git status";
    gd = "git diff";

    # Nix
    rebuild = "sudo nixos-rebuild switch";
    update = "sudo nixos-rebuild switch --upgrade";
    auto-remove = "sudo nix-collect-garbage -d";

    # Others
    ll = "ls -lA";
    la = "ls -A";
  };
}
