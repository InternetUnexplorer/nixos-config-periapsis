{ config, pkgs, lib, modulesPath, ... }:

# The oobot service runs oobot, a Discord bot that goes "oob" (to keep us
# company in #oob).
#
# It expects /etc/oobot-env to exist and contain DISCORD_TOKEN=<token> and
# DISCORD_CHANNELS=<channel>. Refer to oobot's README for more information.

let
  oobot = pkgs.fetchFromGitHub {
    owner = "InternetUnexplorer";
    repo = "oobot";
    rev = "2365f9ba21b69b95fda59f166aa60ecff8af6cdf";
    hash = "sha256-kmtlSOYr2n9Ds3uWQQyqJCWKGPh/6g1/Ht241W7djlY=";
  };

in {
  systemd.services.oobot = {
    description = "oobot";

    path = [
      (pkgs.python3.withPackages
        (p: [ (p.discordpy.override { withVoice = false; }) ]))
    ];

    script = "python3 ${oobot}/oobot.py";

    serviceConfig = {
      DynamicUser = true;
      EnvironmentFile = "/etc/oobot-env";

      Environment = [ "PYTHONUNBUFFERED=1" "VERBOSE=1" ];

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

    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
  };
}
