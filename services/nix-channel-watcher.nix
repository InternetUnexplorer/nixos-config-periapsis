{ config, pkgs, lib, modulesPath, inputs, ... }:

# The nix-channel-watcher service checks the nixos-unstable channel periodically
# and sends repository_dispatch events to a list of repositories when the
# channel is updated.
#
# It expects /etc/github-token to exist and contain GITHUB_TOKEN=<token>, where
# <token> is a GitHub fine-grained personal access token with write access for
# the "Contents" permission (used to send the repository_dispatch events).

let
  repositories = [ "InternetUnexplorer/nixpkgs-overlay" ];

  nixos-unstable-hooks = let
    requestData = builtins.toJSON {
      event_type = "Channel updated: $1@\${3:0:10}";
      client_payload.channel = "$1";
    };

    mkHook = repo:
      pkgs.writers.writeBash "/dispatch-${builtins.baseNameOf repo}" ''
        set -eu
        curl -X POST \
          -H "Accept: application/vnd.github.v3+json" \
          -H "Authorization: token $GITHUB_TOKEN" \
          -d "${lib.escape [ ''"'' ] requestData}" \
          https://api.github.com/repos/${repo}/dispatches
      '';

  in pkgs.symlinkJoin {
    name = "nixos-unstable.hooks";
    paths = map mkHook repositories;
  };

in {
  systemd.services.nix-channel-watcher = {
    description = "Nix channel watcher";

    path = [ pkgs.curlMinimal pkgs.python3 ];

    script = ''
      cd $STATE_DIRECTORY

      # Create channels.txt if it does not exist
      [ -f channels.txt ] || cat > channels.txt << EOF
      nixos-unstable https://nixos.org/channels/nixos-unstable none
      EOF

      # Set up the hooks
      ln -snf ${nixos-unstable-hooks} ./nixos-unstable.hooks

      # Run the script
      python3 ${inputs.nix-channel-watcher}/channel-watcher.py
    '';

    startAt = "*:0/5"; # Every 5 minutes

    serviceConfig = {
      DynamicUser = true;
      EnvironmentFile = "/etc/github-token";
      StateDirectory = "nix-channel-watcher";
      TimeoutSec = 30;

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
