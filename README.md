# nixos-config-periapsis

This is the NixOS configuration for [periapsis.cc](https://periapsis.cc). It is hosted on a Google Cloud `e2-micro` instance in `us-west1-b`.

## Services

| Service | Description |
|---------|-------------|
| [caddy.service](./services/caddy.nix) | Serves the web content for periapsis.cc over HTTPS |
| [discord-overlay-updater.service](./services/discord-overlay-updater.nix) | Checks for Discord desktop app updates every 30 minutes |
| [nix-channel-watcher.service](./services/nix-channel-watcher.nix) | Checks for nixos-unstable channel updates every 5 minutes |
| [oobot.service](./services/oobot.nix) | Runs oobot, a Discord bot that goes "oob" |

## Useful Commands

#### Copy local configuration to remote

```bash
$ rsync -rzlp --delete --rsync-path="sudo rsync" . periapsis.cc:/etc/nixos
```

#### Build system configuration locally and activate on remote

```bash
$ nixos-rebuild switch --flake .#periapsis --target-host periapsis.cc --use-substitutes
```
