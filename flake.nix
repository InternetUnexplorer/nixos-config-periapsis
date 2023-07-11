{
  description = "NixOS configuration for periapsis.cc";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    authorized-keys.url = "https://github.com/InternetUnexplorer.keys";
    authorized-keys.flake = false;

    discord-overlay.url = "github:InternetUnexplorer/discord-overlay";
    discord-overlay.flake = false;

    nix-channel-watcher.url = "github:InternetUnexplorer/nix-channel-watcher";
    nix-channel-watcher.flake = false;

    oobot.url = "github:InternetUnexplorer/oobot";
    oobot.flake = false;
  };

  outputs = inputs: {
    nixosConfigurations.periapsis = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./configuration.nix ];
      specialArgs = { inherit inputs; };
    };
  };
}
