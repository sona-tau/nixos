{ config, pkgs, lib, inputs, ... }: {
	imports = [
		./description.nix
	];

	system.stateVersion = "24.11"; # DO NOT CHANGE
	users.defaultUserShell = pkgs.zsh;
	time.timeZone = "America/Puerto_Rico";

	networking = {
		hostName = "hp";
		networkmanager.enable = true;
		firewall = {
			enable = true;
			allowedTCPPorts = [ 8096 8920 2283 ]; # Jellyfin HTTP/HTTPS, Immich
		};
	};

	i18n.defaultLocale = "en_US.UTF-8";

	services = {
		openssh.enable = true;
		tailscale.enable = true;

		jellyfin = {
			enable = true;
			openFirewall = true;
		};

		immich = {
			enable = true;
			openFirewall = true;
		};
	};

	users.users."sona" = {
		isNormalUser = true;
		description = "sona";
		shell = pkgs.zsh;

		extraGroups = [
			"networkmanager"
			"wheel"
		];

		packages = with pkgs; [
			home-manager
			neovim
			zsh
		];
	};

	nixpkgs.config = {
		allowUnfree = true;
		allowUnsupportedSystem = true;
	};

	environment = {
		sessionVariables = rec {
			XDG_CACHE_HOME  = "$HOME/.cache";
			XDG_CONFIG_HOME = "$HOME/.config";
			XDG_DATA_HOME   = "$HOME/.local/share";
			XDG_STATE_HOME  = "$HOME/.local/state";
			XDG_BIN_HOME    = "$HOME/.local/bin";
			PATH = [ "${XDG_BIN_HOME}" ];
		};

		systemPackages = with pkgs; [
			home-manager
			rsync
			borgbackup
			wget
			doas
			curl
			git
			inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
		];
	};

	programs = {
		zsh.enable = true;

		gnupg.agent = {
			enable = true;
			enableSSHSupport = true;
		};
	};

	security = {
		sudo.enable = false;
		polkit.enable = true;
		rtkit.enable = true;

		doas = {
			enable = true;

			extraRules = [{
				users = [ "sona" ];
				keepEnv = true;
				persist = true;
			}];
		};
	};

	nix = {
		package = pkgs.nixVersions.stable;
		settings.experimental-features = [ "nix-command" "flakes" ];
		extraOptions = ''
			warn-dirty = false
		'';
	};
}
