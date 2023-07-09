{ config, pkgs, lib, modulesPath, inputs, ... }:

# The nix-channel-watcher service checks for Discord desktop app version updates
# periodically and sends a repository_dispatch event to
# InternetUnexplorer/discord-overlay when a version update is available.
#
# It expects /etc/github-token to exist and contain GITHUB_TOKEN=<token>, where
# <token> is a GitHub fine-grained personal access token with write access for
# the "Contents" permission (used to send the repository_dispatch events).

{
  systemd.services.discord-overlay-updater = {
    description = "Discord update checker";

    path = [ pkgs.python3 ];

    script = ''
      cd $STATE_DIRECTORY
      python3 ${inputs.discord-overlay}/update.py check
    '';

    startAt = "*:0/30"; # Every 30 minutes

    serviceConfig = {
      DynamicUser = true;
      EnvironmentFile = "/etc/github-token";
      StateDirectory = "discord-overlay-updater";
      TimeoutSec = 60;

      Environment = "PYTHONUNBUFFERED=1";

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
