# nixos config

Hello to all, this is my NixOS config!

This configuration follows the [dendritic pattern](https://github.com/mightyiam/dendritic)
using [flake-parts](https://flake.parts). Every file in `modules/` is a flake-parts module
that is automatically imported (no manual import lists anywhere).

## Structure

```txt
.
├── flake.nix       <-- entry point, auto-imports everything in modules/
├── flake.lock
├── assets/         <-- fonts, wallpapers, keyboard layouts, etc.
├── machine/        <-- machine-specific configuration and home tweaks
│   ├── hp/         <-- the coolest server of all time
│   ├── est/        <-- gaming PC
│   └── fw13/       <-- Framework 13 laptop
└── modules/        <-- everything lives here, flat and auto-imported
    ├── configurations.nix  <-- declares nixosConfigurations
    ├── flake-parts.nix     <-- enables flake.modules option
    ├── nixos.nix           <-- NixOS base config
    ├── roles/              <-- feature bundles composed from named modules
    └── *.nix               <-- individual feature modules
```

## Machines


| Hostname | Description |
|----------|-------------|
| `fw13`   | Framework 13th gen Intel laptop |
| `est`    | Server |
| `hp`     | Gaming PC |


## Philosophy

Every `.nix` file in `modules/` is a flake-parts module. Inside that directory
there are "feature files", they declare `flake.modules.homeManager.X` or
`flake.modules.nixos.X` named modules. Then, there are "roles", they compose
named modules together. Then, machines in `configurations.nix` import those
roles and named modules directly (inclusion is the enable mechanism, there are
no `mkEnableOption` flags).

## Usage

Check that everything still works:
```bash
nix eval .#nixosConfigurations.$(hostname).config.system.build.toplevel.drvPath
```

Build without switching:
```bash
rebuild build
```

Switch to new configuration:
```bash
rebuld switch
```

Update inputs:
```bash
nix flake update
```

## Credits

- [mightyiam/dendritic](https://github.com/mightyiam/dendritic): the pattern this config follows
- [flake-parts](https://flake.parts): flake framework
- [Misterio77/nix-starter-configs](https://github.com/Misterio77/nix-starter-configs): original inspiration
