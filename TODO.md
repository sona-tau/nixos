# TODO

## The Mission
Every decision in this config should serve three pillars:
- **Efficiency** — fast and/or low power consumption
- **Reproducibility** — system state and backups are fully declared and recoverable
- **Ease of management** — changes are simple, machines are easy to provision and maintain

---

## hp — quick wins (do these soon)

### ~~Close port 19999 immediately~~ ✓ done
### ~~Disable unfinished/unused services~~ ✓ done
lidarr, sonarr, radarr, jellyseerr, qbittorrent are commented out in `machine/hp/os.nix`.

### Finish traccar (port 8082)
Family members depend on this. Make it a priority. Put behind reverse proxy with TLS.

---

## Reverse proxy — nginx on hp
**Status:** Caddy was attempted before and was painful. Try nginx instead.
Nothing on hp should be directly port-exposed. Target state:
- **Tailscale-only (internal):** netdata, radicale, home-assistant, radarr, sonarr, lidarr,
  jellyseerr, traccar, the binary cache
- **Publicly exposed via reverse proxy + TLS:** Forgejo, Immich, Jellyfin, Traccar (for family)
`services.nginx` in NixOS is well-supported and straightforward to declare.

---

## sops-nix — declarative secrets management
**Status:** not started, high priority.
Use `sops-nix` to manage secrets (API keys, passwords, SSH keys) declaratively in the flake.
Currently things like pass and borgbackup have secrets living outside the config.
SSH key can double as the age key. Do this before nixos-anywhere — provisioning is cleaner
when secrets are already in the repo.

## ~~NixOS common.nix — shared OS config~~ ✓ done
`modules/nixos-common.nix` exists and is used by all three machines via `configurations.nix`.

## Declarative borgbackup
**Status:** not started, high priority — already in use on all machines.
borgbackup is already running (markdown wiki, code files, jellyfin on the server).
Use `services.borgbackup.jobs` in NixOS to fully declare repositories, schedules, retention
policies, and paths. Ties directly into the reproducibility pillar.
Pairs with sops-nix for repository passphrases.

## nixos-anywhere + disko — declarative provisioning
**Status:** not started, high priority. Previously attempted disko but couldn't get it working.
Declare disk partitioning in Nix (`disko`) and use `nixos-anywhere` to bootstrap a new machine
from scratch over SSH with a single command. Pairs with sops-nix for full zero-touch provisioning.

## Self-hosted binary cache — on hp
**Status:** not started.
Options: `attic` (modern, nice UX), `harmonia` (fast, Rust), or `nix-serve` (simple).
All machines on the tailnet can point to it as a substituter, eliminating redundant recompilation
across fw13, est, and hp. Serve it through the reverse proxy.

## Forgejo as canonical git remote
**Status:** was doing this before, stopped — resume it.
Forgejo on hp is the source of truth. GitHub and Tangled are read-only public mirrors via
Forgejo's mirroring feature. Never push to GitHub directly.
Set up Forgejo Actions for CI (`nix flake check` on every push).

## SSH hardening — key-only authentication
**Status:** not started, should be done soon.
Disable password authentication across all machines:
`services.openssh.settings.PasswordAuthentication = false`
Goes in common.nix since it applies everywhere. Pairs with sops-nix for key management.

## systemd service hardening — hp server
**Status:** not started.
Sandbox server services (Jellyfin, borgbackup, etc.) with systemd options:
`DynamicUser`, `ProtectSystem`, `PrivateTmp`, `NoNewPrivileges`, etc.
Use `systemd-analyze security <service>` to audit each one.
hp is a public-facing server so anything that reduces attack surface is a must.

## Flake checks + CI — via Forgejo Actions
**Status:** not started.
Run `nix flake check` on every push via Forgejo Actions (GitHub Actions-compatible).
Goal: anything on the live public repo evaluates correctly out of the box, enforced automatically
rather than by discipline. Keeps ci self-hosted on hp.

## CPU/power management — fw13
**Status:** investigate before implementing.
`fw13/os.nix` already enables `power-profiles-daemon`. Noctalia's energy saver/balanced/performance
modes likely hook into this. `auto-cpufreq` conflicts with `power-profiles-daemon` — do not run
both. `thermald` (thermal throttling) is complementary and safe to add alongside either.
Decision: keep power-profiles-daemon (noctalia already works with it), add thermald for thermal
safety.

## Impermanence
**Status:** backburner — some services (Jellyfin, Home Assistant) are easier to configure
manually than through Nix, so full impermanence is not worth it right now.
Revisit if the number of manually managed services decreases.

## Home Assistant
**Status:** backburner — not yet set up well enough to be worth declaring in Nix.

## Dotfiles consolidation
Neovim, tmux, zsh likely have config living in `~/.config` or `assets/` outside the module
system. For neovim specifically: nixvim is too slow to iterate on. A middle ground is declaring
plugins via `programs.neovim` in home-manager while keeping the config as a free-edited file
symlinked via `home.file`. Fully inlining tmux and zsh is more tractable.

## deploy-rs — remote deployment
**Status:** low priority — already easy to deploy via SSH into tailnet + nixos-rebuild.
deploy-rs adds auto-rollback on activation failure and a cleaner multi-machine story, but the
operational gain over SSH + rebuild is small given the current setup.

## Automated flake updates
A scheduled systemd timer that runs `nix flake update` and opens a PR on Forgejo,
keeping inputs current without manual effort.

## treefmt-nix — declarative formatting
**Status:** blocked — all mainstream Nix formatters (nixfmt, alejandra, nixpkgs-fmt) use spaces,
not tabs, and none are configurable to match the style used in this repo. Revisit if a
tab-supporting formatter appears.

### Formatting style rules (for reference)
- Tabs only (no spaces)
- Single-line options at the top of attrsets
- Multiline options preceded by one empty line
- Options nested as deep as possible
