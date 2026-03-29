# nixos config

Hello to all, this is my NixOS config!

I take heavy inspiration from: https://github.com/Misterio77/nix-starter-configs

File structure:
```txt
.
├── LICENSE
├── flake.lock
├── flake.nix
├── nixpkgs.nix <-- Allows me to pin nixpkgs
├── assets/     <-- general assets
├── home/       <-- home manager config entry points
├── machine/    <-- machine-specifig configuration
├── myLib/      <-- general helper functions for files
├── modules/    <-- both Home Manager and NixOS modules live here
├── overlays/   <-- for all the overlays
├── pkgs/       <-- define custom packages
├── README.md
.
├── LICENSE
├── flake.lock
├── flake.nix
├── nixpkgs.nix <-- Allows me to pin nixpkgs
├── assets/     <-- general assets
├── home/       <-- home manager config entry points
├── machine/    <-- machine-specifig configuration
├── myLib/      <-- general helper functions for files
├── modules/    <-- both Home Manager and NixOS modules live here
├── overlays/   <-- for all the overlays
├── pkgs/       <-- define custom packages
├── README.md

```

My `hosts/` folder manages configurations per machine. Then `hm-modules/rices`
has a per-rice configuration I can enable/disable through home manager.
