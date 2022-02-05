{ config, pkgs, lib, modulesPath, ... }:

let
  discord-overlay = pkgs.fetchFromGitHub {
    owner = "InternetUnexplorer";
    repo = "discord-overlay";
    rev = "6c1d450ca11bc660895965d221eeac293bba2ca4";
    hash = "sha256-NnczpFxFnJWKsq0Z+whSaTxRwViDyGZuG33tn+k2RlM=";
  };

in {
  systemd.services.discord-overlay-updater = {
    description = "check for Discord updates";

    path = [ pkgs.python3 ];

    script = ''
      cd $STATE_DIRECTORY
      python3 ${discord-overlay}/update.py check
    '';

    startAt = "*:0/30"; # Every 30 minutes

    serviceConfig = {
      DynamicUser = true;
      EnvironmentFile = "/etc/github-token";
      StateDirectory = "discord-overlay-updater";
      TimeoutSec = 60;

      PrivateDevices = true;
      PrivateMounts = true;
      PrivateUsers = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
    };
  };
}
