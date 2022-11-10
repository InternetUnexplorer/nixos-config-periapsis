{ config, pkgs, lib, modulesPath, ... }:

# The oobot service runs oobot, a Discord bot that goes "oob" (to keep us
# company in #oob).
#
# It expects /etc/oobot-env to exist and contain DISCORD_TOKEN=<token> and
# DISCORD_CHANNEL=<channel>, where <token> is the token for the bot and
# <channel> is the channel it should run in.

let
  oobot = pkgs.fetchFromGitHub {
    owner = "InternetUnexplorer";
    repo = "oobot";
    rev = "6c85c57dfeffd99a9ee06c018d77e21f4dc3a154";
    hash = "sha256-EBnLk8ZefRhk6AtLs60gfViPf7gAEDhEeB8aJrnI5nA=";
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
