{
  config,
  inputs,
  withSystem,
  ...
}:
let
  mkHomeManager = extraSpecialArgs: {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
    extraSpecialArgs = {
      inherit inputs;
      homeModules = config.flake.modules.homeManager;
    }
    // extraSpecialArgs;
  };
in
{
  flake.nixosConfigurations = {
    "fw13" = withSystem "x86_64-linux" (
      perSystem@{ ... }:
      inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          inputs.nixos-hardware.nixosModules.framework-13th-gen-intel
          inputs.home-manager.nixosModules.home-manager
          inputs.sops-nix.nixosModules.sops
          config.flake.modules.nixos.base
          config.flake.modules.nixos.common
          config.flake.modules.nixos.niri
          config.flake.modules.nixos.wayland
          config.flake.modules.nixos.plan9
          config.flake.modules.nixos.attic
          config.flake.modules.nixos.distributed-client
          ../machine/fw13/hardware.nix
          ../machine/fw13/os.nix
          {
            home-manager = (mkHomeManager { zen-browser = perSystem.config.packages.zen-browser; }) // {
              users."sona".imports = [ ../machine/fw13/user.nix ];
            };
          }
        ];
      }
    );

    "est" = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        inputs.home-manager.nixosModules.home-manager
        inputs.sops-nix.nixosModules.sops
        config.flake.modules.nixos.base
        config.flake.modules.nixos.common
        config.flake.modules.nixos.plan9
        config.flake.modules.nixos.attic
        config.flake.modules.nixos.distributed-host
        ../machine/est/hardware.nix
        ../machine/est/os.nix
        {
          home-manager = (mkHomeManager { }) // {
            users."sona".imports = [ ../machine/est/user.nix ];
          };
        }
      ];
    };

    "hp" = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        inputs.home-manager.nixosModules.home-manager
        inputs.sops-nix.nixosModules.sops
        config.flake.modules.nixos.base
        config.flake.modules.nixos.common
        config.flake.modules.nixos.monitoring
        config.flake.modules.nixos.glance
        config.flake.modules.nixos.readeck
        config.flake.modules.nixos.pinchflat
        config.flake.modules.nixos.firefly
        config.flake.modules.nixos.kubo
        # config.flake.modules.nixos.metube  # WIP: fetcherVersion 3 migration on feat/metube
        config.flake.modules.nixos.grocy
        config.flake.modules.nixos.monica
        config.flake.modules.nixos.atticd
        config.flake.modules.nixos.attic
        config.flake.modules.nixos.plan9
        ../machine/hp/hardware.nix
        ../machine/hp/os.nix
        {
          home-manager = (mkHomeManager { }) // {
            users."sona".imports = [ ../machine/hp/user.nix ];
          };
        }
      ];
    };
  };
}
