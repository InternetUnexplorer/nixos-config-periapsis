{ config, pkgs, lib, modulesPath, inputs, ... }:

# The oobot service runs oobot, a Discord bot that goes "oob" (to keep us
# company in #oob).
#
# It expects /etc/oobot-env to exist and contain DISCORD_TOKEN=<token> and
# DISCORD_CHANNELS=<channel>. Refer to oobot's README for more information.

{
  systemd.services.oobot = {
    description = "oobot";

    path = [
      (pkgs.python3.withPackages
        (p: [ (p.discordpy.override { withVoice = false; }) ]))
    ];

    script = "python3 ${inputs.oobot}/oobot.py";

    serviceConfig = {
      DynamicUser = true;
      EnvironmentFile = "/etc/oobot-env";

      Restart = "on-failure";
      RestartSec = 5;

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
