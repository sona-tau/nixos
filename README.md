# nixos config

Hello to all, this is my NixOS config!

File structure:
```txt
.
├── flake.lock
├── flake.nix
├── hm-modules
│   ├── default.nix
│   └── rices
│       ├── default.nix
│       └── eva
│           ├── default.nix
│           ├── eva.nix
│           └── mods
├── hosts
│   └── fw13
│       ├── configuration.nix
│       ├── hardware-configuration.nix
│       └── home.nix
├── LICENSE
├── nixos-modules
│   ├── default.nix
│   └── default-wm
│       └── sway.nix
└── README.md

9 directories, 13 files
```

My `hosts/` folder manages configurations per machine. Then `hm-modules/rices`
has a per-rice configuration I can enable/disable through home manager.
