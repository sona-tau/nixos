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

### ~~Finish traccar (port 8082)~~ ✓ done
Running behind Caddy at traccar.hp. Registration disabled. Owner's phone confirmed tracking.

---

## ~~Reverse proxy~~ ✓ done
Caddy is in use on hp. All services are tailnet-only — no public exposure.
Current virtual hosts: git.hp, immich.hp, jellyfin.hp, navidrome.hp, traccar.hp, netdata.hp,
homeassistant.hp, radicale.hp, syncthing.hp.

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

## ~~SSH hardening — key-only authentication~~ ✓ done
`PasswordAuthentication`, `KbdInteractiveAuthentication`, and `PermitRootLogin` are all locked
down in `modules/nixos-common.nix`. Applies to all three machines.

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

## Monitoring — Prometheus + Grafana
**Status:** not started, high priority. Currently using netdata; considering a switch for more
control over data and dashboards. Inspiration: https://github.com/ibizaman/selfhostblocks
`services.prometheus` + `services.grafana` in NixOS are well-supported.
Expose via Caddy at grafana.hp. Replace or run alongside netdata until stable.

## Glance — homepage dashboard
**Status:** not started, high priority.
A single-page homepage aggregating: Prometheus/Grafana stats widgets, RSS feeds, news.
`services.glance` is in nixpkgs. Expose at glance.hp (or hp/ root).

## Readeck — read-it-later
**Status:** not started, high priority.
Self-hosted Pocket/Instapaper alternative. Good for the HN backlog.
Available as `pkgs.readeck`. Expose at readeck.hp.

## Pinchflat — YouTube media manager
**Status:** not started, high priority.
Declarative YouTube subscriptions/downloads. Replaces ad-hoc yt-dlp scripts.
NixOS module available. Expose UI at pinchflat.hp. Store media alongside Jellyfin/Navidrome.

## *arr stack — media automation
**Status:** commented out (lidarr, sonarr, radarr, jellyseerr). Interesting but lower priority.
Services are already in nixpkgs — just need enabling + configuration + Caddy virtual hosts.
Pairs with qbittorrent (also commented out) and Pinchflat for a complete media pipeline.

## Firefly III — personal finance
**Status:** not started.
Self-hosted budgeting/transaction tracker. NixOS module via `services.firefly-iii`.
Expose at firefly.hp. Needs a database (postgres preferred).

### Transaction import
USAA supports CSV export (manual download from website). Import via Firefly III Data Importer (FIDI).
GoCardless (automatic open banking) does not cover US banks. Plaid and SimpleFIN (~$15/yr) are
options for automation later, but manual CSV is the baseline.
- Set up FIDI as a companion service (`services/fidi.nix`) — no nixpkgs module, needs custom derivation or container
- Configure a CSV import profile for USAA's export format
- Optionally wire to SimpleFIN for scheduled automatic pulls

## Vaultwarden — password manager
**Status:** not started.
Bitwarden-compatible self-hosted vault. `services.vaultwarden` in nixpkgs.
Expose at vault.hp. High value: removes dependency on external password manager.

## Beets — music library metadata
**Status:** incomplete. Songs were moved to /storage/storage/Music without metadata tagging.
Run beets import on the library to tag tracks correctly before Navidrome scrapes them again.
Config can be declared via `programs.beets` in home-manager.

## spotdl — headless Spotify sync
**Status:** blocked by Spotify rate limit. Ran `spotdl --user-auth` on laptop to complete OAuth,
but got a rate limit error (86400 second / 24 hour cooldown) immediately before any songs
downloaded. Copy `~/.spotdl/credentials.json` from laptop to hp once the cooldown expires, then
retry — spotdl will run headlessly with saved credentials.

## treefmt-nix — declarative formatting
**Status:** blocked — all mainstream Nix formatters (nixfmt, alejandra, nixpkgs-fmt) use spaces,
not tabs, and none are configurable to match the style used in this repo. Revisit if a
tab-supporting formatter appears.

### Formatting style rules (for reference)
- Tabs only (no spaces)
- Single-line options at the top of attrsets
- Multiline options preceded by one empty line
- Options nested as deep as possible

---

## Life Dashboard — Home Assistant

A time-gated HA dashboard that shifts throughout the day. Sections visible at wake-up differ from
midday, evening, and night. Covers five domains: Technology, Health, Finance, Wellbeing, Social/Hobbies.

**Time gates (rough schedule):**
- Wake-up (6–9am): appointments today, finance summary
- Morning (5–7am): skincare/hair routine, meal suggestions
- Daytime: server status, geofences, Anki due, Readeck queue
- Evening (6–8pm): meal suggestions, today's workout, evening routine
- Night (9pm+): nighttime skincare, day summary

**Locked decisions:**
- Finance backbone: Firefly III (via `services/firefly.nix` + PostgreSQL)
- Sleep data: Sleep as Android → HA native integration (Polar Flow deferred)
- Bloodwork: manual YAML per lab visit (Phase 8a), OCR pipeline later (Phase 8b)
- Contact tracking: manual HA button per person to stamp last-contacted
- Anki: local Anki + AnkiConnect add-on; HA REST sensor over Tailscale

### Phase 0 — Infrastructure prerequisites
**Status:** in progress. Unblocks all REST sensor and finance work.
- ~~`services/firefly.nix`~~ ✓ done — Firefly III NixOS service, second PostgreSQL DB, Caddy vhost at firefly.hp
- `services/grocy.nix` — Grocy household manager: meals/recipes, shopping list, medications, stock
  `services.grocy` in nixpkgs. Caddy vhost at grocy.hp. Covers Phases 1 (pills), 5 (meals/shopping), 9 (stock).
- `services/monica.nix` — Monica personal CRM: contact frequency, interaction log, upcoming activities
  `services.monica` in nixpkgs. Caddy vhost at monica.hp. Covers Phase 6 (friends & family).
- sops-nix secrets: HA long-lived access token + Firefly API key + Grocy API key + Monica API key

### Phase 1 — HA foundations
**Status:** not started. Pure HA UI config. Delivers immediate visible value.
- Wire CalDAV calendar entities: Radicale → HA integration
- Wire Traccar geofence/zone entities (`traccar` already in `extraComponents`)
- Confirm Met.no weather entity active
- Pill tracker: Grocy medication tracking (stock count, last-taken, reorder threshold)
  Surface in HA via Grocy API REST sensors. Dependency: Phase 0 (Grocy running).
- Deliverable: test Lovelace view with calendar, weather, pill tracker

### Phase 2 — Technology section
**Status:** not started. Dependency: Phase 0 (sops, for Tailscale API key).
- HA REST sensors against Prometheus HTTP API: CPU, memory, ZFS pool health, disk
- HA REST sensor against Tailscale API for active tailnet machines
- Traccar geofence badge display
- New config: sensor block in `machine/hp/os.nix` or `services/ha-sensors.nix`

### Phase 3 — Finance section
**Status:** not started. Dependency: Phase 0 (Firefly III running).
- Manually populate Firefly III: accounts, recurring bills, subscriptions, income
- HA REST sensors: balance, spendable-today, upcoming bills (Firefly API v1)
- Subscriptions + income markdown card (next 5 recurring transactions)
- Jobs/scholarships: RSS feeds added to Glance + iframe or sensor in HA

### Phase 4 — Health: sleep and appointments
**Status:** not started. Pure HA config. Dependency: Phase 1 (CalDAV entities).
- Sleep as Android → HA webhook/MQTT integration (HACS or built-in)
  Entities: sleep_duration, sleep_efficiency, sleep_phase
- Template sensors: next appointment per doctor type (H-doctor, dentist, therapist)
- Health Lovelace view: calendar card, sleep stats, appointment sensors

### Phase 5 — Wellbeing: routines, meals, workout
**Status:** not started. Pure HA config. Parallel with Phase 4.
- Skincare/hair routines: `input_boolean` per step, conditional cards (5–9am / 9pm+)
- Workout schedule: `command_line` sensor reading `/var/lib/hass/workout_schedule.yaml`
- Meal suggestions: Grocy recipe database + meal plan feature
  Surface in HA via Grocy API (today's planned meal, upcoming suggestions).
  Grocy also handles the shopping list natively; sync to HA `todo` entity or iframe.
  Dependency: Phase 0 (Grocy running).

### Phase 6 — Friends and family
**Status:** not started. Dependency: Phase 0 (Monica running) + Phase 1 (CalDAV entities).
- Monica personal CRM as the data backend: log interactions, set contact frequency goals,
  track upcoming activities per person. Monica handles the "last contacted" and overdue logic natively.
- HA REST sensors against Monica API: overdue contacts count, next upcoming activity
- Upcoming activities card from Radicale social calendar (or Monica's own calendar feed)
- Dashboard: Monica iframe or summary cards with overdue alerts

### Phase 7 — Hobbies: Anki and calligraphy
**Status:** not started. Dependency: Tailscale (already operational).
- AnkiConnect REST sensor → fw13/est over Tailscale (port 8765)
  Graceful degradation via `availability_template` when Anki is closed
- Calligraphy: `command_line` sensor + `counter` helper + `/var/lib/hass/calligraphy.yaml`
  Rotates through exercise list; counter increments at midnight

### Phase 8 — Health: bloodwork
**Status:** not started. Most complex pipeline.
- Define YAML schema: `/var/lib/hass/bloodwork/<date>.yaml`
  Fields: date, markers [{name, value, unit, low, high}]
- Phase 8a (manual): populate YAML files from lab papers by hand
  command_line sensors for latest values, binary in_range sensors, trend graphs
- Phase 8b (OCR): NixOS systemd oneshot using tesseract + parser script
  Input: photo dropped in watched dir → output: new dated YAML file
  New config: `services/bloodwork-ocr.nix` or block in `machine/hp/os.nix`

### Phase 9 — Time-gated dashboard and polish
**Status:** not started. Assembly phase — all data sources must exist first.
- Template sensor: `time_of_day` returning wake_up|morning|daytime|evening|night
- Conditional cards wrapping each section, gated on `time_of_day` sensor
- Readeck REST sensor: unread article count (Readeck API at 127.0.0.1:8090)
- Stock items: Grocy product stock tracking (dehumidifiers, pencils, paper, etc.)
  HA REST sensor for low-stock products via Grocy API. Alert automation on threshold breach.
- Final master dashboard replaces all test views from earlier phases
