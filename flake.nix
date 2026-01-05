{
	description = "Sona's super awesome flake.";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
		zen-browser.url = "github:0xc000022070/zen-browser-flake";
		stylix.url = "github:danth/stylix";

		niri = {
			url = "github:sodiboo/niri-flake";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		quickshell = {
			url = "git+https://git.outfoxxed.me/outfoxxed/quickshell"; # add ?ref=<tag> to track a tag
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	# The `inputs@` part binds all of the parameters here to `inputs`
	outputs = inputs@{ self, nixpkgs, home-manager, stylix, ... }:
	let
		# Expose this flake's own outputs as a value that can be passed to modules
		inherit (self) outputs;

		# Extra arguments injected into all NixOS / Home Manager modules. Allows
		# modules to access flake inputs and other outputs without threading
		# them manually through imports
		specialArgs = { inherit inputs outputs; };
	in rec {
		nixosConfigurations."fw13" = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			inherit specialArgs;

			modules = [
				./machine/fw13/configuration.nix
				stylix.nixosModules.stylix

				(home-manager.nixosModules.home-manager {
					home-manager = {
						useGlobalPkgs = true;
						useUserPackages = true;
						users."sona" = {
							imports = [
								# INFO: Everything is managed through configuration.nix.
							];
						};
						backupFileExtension = "bak";
					};
				})
			];
		};

		# Export all the modules in this configuration
		homeManagerModules = [
			./module/home/alacritty.nix
			./module/home/android.nix
			./module/home/applications.nix
			./module/home/atuin.nix
			./module/home/backup.nix
			./module/home/carapace.nix
			./module/home/direnv.nix
			./module/home/email.nix
			./module/home/eww.nix
			./module/home/firefox.nix
			./module/home/fonts.nix
			./module/home/foot.nix
			./module/home/fzf.nix
			./module/home/gammastep.nix
			./module/home/gtk.nix
			./module/home/ime.nix
			./module/home/minecraft.nix
			./module/home/niri.nix
			./module/home/nushell.nix
			./module/home/quickshell.nix
			./module/home/sh_prompt.nix
			./module/home/starship.nix
			./module/home/sway.nix
			./module/home/tealdeer.nix
			./module/home/tmux.nix
			./module/home/waybar.nix
			./module/home/waypaper.nix
			./module/home/zathura.nix
			./module/home/zen-browser.nix
			./module/home/zsh.nix
		];

		nixosModules = [
			./module/nixos/audio.nix
			./module/nixos/base.nix
			./module/nixos/cache.nix
			./module/nixos/env.nix
			./module/nixos/gpg.nix
			./module/nixos/i3.nix
			./module/nixos/iosevka.nix
			./module/nixos/keyboard.nix
			./module/nixos/locale.nix
			./module/nixos/network.nix
			./module/nixos/nix.nix
			./module/nixos/plymouth.nix
			./module/nixos/security.nix
			./module/nixos/stylix.nix
			./module/nixos/sway.nix
			./module/nixos/user.nix
		];

		roles = {
			aesthetic-nier = import ./role/aesthetic-nier.nix;
			backup = import ./role/backup.nix;
			base = import ./role/base.nix;
			boot = import ./role/boot.nix;
			cli = import ./role/cli.nix;
			desktop = import ./role/desktop.nix;
			email = import ./role/email.nix;
			fun = import ./role/fun.nix;
			lean = import ./role/lean.nix;
			message = import ./role/message.nix;
		};
	};
}
