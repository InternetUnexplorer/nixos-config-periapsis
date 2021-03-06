# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/virtualisation/google-compute-image.nix")
    ./services/caddy.nix
    ./services/discord-overlay-updater.nix
    ./services/nix-channel-watcher.nix
    ./services/oobot.nix
  ];

  nix = {
    package = pkgs.nixFlakes;
    settings.auto-optimise-store = true;
    settings.experimental-features = "nix-command flakes";
    settings.trusted-users = [ "@wheel" ];
  };

  system.autoUpgrade = {
    enable = true;
    flake = "/etc/nixos";
    dates = "monthly";
    flags = [ "--update-input" "nixpkgs" ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-old";
  };

  boot.kernelPackages = pkgs.linuxPackages_hardened;

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    kbdInteractiveAuthentication = false;
  };

  networking.firewall.enable = true;

  services.fail2ban.enable = true;

  programs = {
    fish.enable = true;
    command-not-found.enable = false;
  };

  security.sudo.wheelNeedsPassword = false;

  users.users.alex = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keyFiles = [ ./authorized_keys ];
  };

  environment = {
    variables.EDITOR = "nvim";
    systemPackages = with pkgs; [
      busybox
      git
      htop
      neovim
      tmux
    ];
  };

  system.stateVersion = "22.05";
}
