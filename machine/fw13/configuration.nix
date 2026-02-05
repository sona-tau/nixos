{ config, pkgs, lib, inputs, outputs, system, myLib, stylix, nixos-hardware, ... }: {
	imports = [
		./description.nix
		../../modules/nixos
		# outputs.roles.nixos.hello
	];

	system.stateVersion = "23.11"; # DO NOT CHANGE
	users.defaultUserShell = pkgs.zsh;
	time.timeZone = "America/Puerto_Rico";
	console.useXkbConfig = true;

	boot = {
		loader.grub.theme = lib.mkForce pkgs.catppuccin-grub;

		plymouth = {
			enable = true;
			theme = "blahaj";
			themePackages = [ pkgs.plymouth-blahaj-theme ];
		};
	};

	networking = {
		hostName = "fw13";
		networkmanager.enable = true;
		firewall.enable = true;

		extraHosts = ''
			127.0.0.1 localhost.localdomain localhost
		'';
	};

	i18n = {
		defaultLocale = "en_US.UTF-8";

		extraLocaleSettings = {
			LC_ADDRESS = "es_PR.UTF-8";
			LC_IDENTIFICATION = "es_PR.UTF-8";
			LC_MEASUREMENT = "es_PR.UTF-8";
			LC_MONETARY = "es_PR.UTF-8";
			LC_NAME = "es_PR.UTF-8";
			LC_NUMERIC = "es_PR.UTF-8";
			LC_PAPER = "es_PR.UTF-8";
			LC_TELEPHONE = "es_PR.UTF-8";
			LC_TIME = "es_PR.UTF-8";
		};

		inputMethod = {
			type = "fcitx5";
			enable = true;

			fcitx5.addons = with pkgs; [
				fcitx5-anthy
				fcitx5-gtk
				qt6Packages.fcitx5-configtool
			];

			ibus.engines = [ pkgs.ibus-engines.anthy ];
		};
	};

	services = {
		getty.autologinUser = "sona";
		openssh.enable = true;
		tailscale.enable = true;

		xserver = {
			xkb = {
				layout = "mtgap-mod";

				extraLayouts."mtgap-mod" = {
					description = "MTGAP Layout (modified)";
					languages = ["eng"];
					symbolsFile = ./mtgap-mod.xkb;
				};
			};
		};

		pipewire = {
			enable = true;
			alsa.enable = true;
			alsa.support32Bit = true;
			pulse.enable = true;
			jack.enable = true;
		};
	};

	users = {
		groups."plugdev" = {};

		users."sona" = {
			isNormalUser = true;
			description = "sona";
			shell = pkgs.zsh;

			extraGroups = [
				"networkmanager"
				"wheel"
				"plugdev"
				"adbusers"
				"docker"
			];

			packages = with pkgs; [
				home-manager
				neovim
				helix
				zsh
			];
		};
	};

	nixpkgs.config = {
		allowUnfree = true;
		allowUnsupportedSystem = true;
		permittedInsecurePackages = [
			"quickjs-2025-09-13-2"
		];
	};

	environment = {
		variables.GLFW_IM_MODULE = "ibus";
		sessionVariables = rec {
			XDG_CACHE_HOME  = "$HOME/.cache";
			XDG_CONFIG_HOME = "$HOME/.config";
			XDG_DATA_HOME   = "$HOME/.local/share";
			XDG_STATE_HOME  = "$HOME/.local/state";

			# Not officially in the specification
			XDG_BIN_HOME	= "$HOME/.local/bin";

			PATH = [ "${XDG_BIN_HOME}" ];
		};

		systemPackages = let
			system = "x86_64-linux";
		in [
			pkgs.home-manager
			pkgs.rsync
			pkgs.borgbackup
			pkgs.onedrive
			pkgs.wget
			pkgs.doas
			pkgs.ed
			pkgs.curl
			pkgs.pass
			pkgs.git
			pkgs.qemu
			pkgs.jellyfin
			pkgs.jellyfin-web
			pkgs.jellyfin-ffmpeg
			pkgs.just
			pkgs.firefoxpwa
			inputs.quickshell.packages."${system}".default
			(inputs.zen-browser.packages."${system}".default.overrideAttrs (final: prev: {
				policies = { # find more options here: https://mozilla.github.io/policy-templates/
					AutofillAddressEnabled = true;
					AutofillCreditCardEnabled = false;
					DisableAppUpdate = true;
					DisableFeedbackCommands = true;
					DisableFirefoxStudies = true;
					DisablePocket = true;
					DisableTelemetry = true;
					DontCheckDefaultBrowser = true;
					NoDefaultBookmarks = true;
					OfferToSaveLogins = false;
					EnableTrackingProtection = {
						Value = true;
						Locked = true;
						Cryptomining = true;
						Fingerprinting = true;
					};
				};
				nativeMessagingHosts.packages = [ pkgs.firefoxpwa ];
			 }))
		];
	};

# Fonts
	fonts = {
		packages = with pkgs; [
			cozette
			scientifica
			ipafont
			dejavu_fonts
			ipaexfont
			nasin-nanpa
			linja-pi-pu-lukin
			ibm-plex
			ocr-a
			apl386
			bqn386
			hermit
		] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
		enableDefaultPackages = true;
	};

	programs = {
		zsh.enable = true;

		gnupg.agent = {
			enable = true;
			enableSSHSupport = true;
		};

		firefox = {
			enable = true;
			package = pkgs.firefox;
			nativeMessagingHosts.packages = [ pkgs.firefoxpwa ];
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

	nix.settings = {
		substituters = [ "https://cache.iog.io" ];
		trusted-public-keys = [ "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=" ];

		experimental-features = [
			"nix-command"
			"flakes"
		];
	};

	nix = {
		package = pkgs.nixVersions.stable;
		extraOptions = ''
			experimental-features = nix-command flakes
			warn-dirty = false
		'';
	};
}
