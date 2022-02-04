{
  description = "NixOS configuration for periapsis.cc";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: {
    nixosConfigurations."periapsis-cc.c.elite-avatar-187222.internal" =
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./configuration.nix ];
      };
  };
}
