# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, modulesPath, inputs, ... }:

{
  imports = [
    (modulesPath + "/virtualisation/google-compute-image.nix")
    ./services/caddy.nix
    ./services/discord-overlay-updater.nix
    ./services/nix-channel-watcher.nix
    ./services/oobot.nix
  ];

  system.name = "periapsis";

  nix.settings = {
    auto-allocate-uids = true;
    auto-optimise-store = true;
    experimental-features = [ "auto-allocate-uids" "flakes" "nix-command" ];
    trusted-users = [ "@wheel" ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-old";
  };

  boot.kernelPackages = pkgs.linuxPackages_hardened;

  # For serial rescue
  users.mutableUsers = false;
  users.users.root.hashedPassword =
    "$y$j9T$IlbbRs13NNzbfaycUIeTF.$NS9xUhNuPhZANu9pkRKsrlImDEUWpjVD42WlV7Sit48";

  services.tailscale.enable = true;
  services.tailscale.extraUpFlags = [ "--advertise-exit-node" "--ssh" ];
  services.tailscale.useRoutingFeatures = "server";

  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;
  services.fail2ban.enable = true;

  networking.firewall.enable = lib.mkForce true;

  programs.fish = {
    enable = true;
    useBabelfish = true;
  };

  programs.command-not-found.enable = false;

  security.sudo.wheelNeedsPassword = false;

  users.users.alex = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" ];
    createHome = true;
  };

  environment = {
    variables.EDITOR = "nvim";
    systemPackages = with pkgs; [ busybox git htop neovim tmux ];
  };

  documentation.man.generateCaches = false;

  system.stateVersion = "22.05";
}
