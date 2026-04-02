{ config, pkgs, lib, inputs, ... }: {
	imports = [
		./description.nix
	];

	system.stateVersion = "24.11"; # DO NOT CHANGE
	users.defaultUserShell = pkgs.zsh;
	time.timeZone = "America/Puerto_Rico";

	boot.loader.grub.theme = lib.mkForce pkgs.catppuccin-grub;

	networking = {
		hostName = "est";
		networkmanager.enable = true;
		firewall.enable = true;
	};

	i18n.defaultLocale = "en_US.UTF-8";

	services = {
		getty.autologinUser = "sona";
		openssh.enable = true;
		tailscale.enable = true;

		pipewire = {
			enable = true;
			alsa.enable = true;
			alsa.support32Bit = true;
			pulse.enable = true;
			jack.enable = true;
		};
	};

	hardware = {
		graphics.enable = true;
		graphics.enable32Bit = true;
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
			wget
			doas
			curl
			git
			inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
		];
	};

	fonts = {
		packages = with pkgs; [
			dejavu_fonts
			hermit
		] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
		enableDefaultPackages = true;
	};

	programs = {
		zsh.enable = true;
		steam.enable = true;

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
