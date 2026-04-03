{ pkgs, lib, inputs, ... }: {
	imports = [ ./hardware.nix ];

	system.stateVersion = "23.11"; # DO NOT CHANGE

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

		extraHosts = ''
			127.0.0.1 localhost.localdomain localhost
		'';
	};

	i18n = {
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
		power-profiles-daemon.enable = true;
		upower.enable = true;

		xserver.xkb = {
			layout = "mtgap-mod";

			extraLayouts."mtgap-mod" = {
				description = "MTGAP Layout (modified)";
				languages = [ "eng" ];
				symbolsFile = ../../assets/mtgap-mod.xkb;
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

	users.users."sona" = {
		extraGroups = [ "plugdev" "adbusers" "docker" ];
		packages = with pkgs; [ helix ];
	};

	nixpkgs.config.permittedInsecurePackages = [
		"quickjs-2025-09-13-2"
	];

	environment = {
		variables.GLFW_IM_MODULE = "ibus";

		systemPackages = with pkgs; [
			borgbackup
			onedrive
			pass
			qemu
			ed
			just
			firefoxpwa
			jellyfin
			jellyfin-web
			jellyfin-ffmpeg
		];
	};

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
		firefox = {
			enable = true;
			package = pkgs.firefox;
			nativeMessagingHosts.packages = [ pkgs.firefoxpwa ];
		};
	};

	nix.settings = {
		substituters = [ "https://cache.iog.io" ];
		extra-substituters = [ "https://noctalia.cachix.org" ];
		trusted-public-keys = [ "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=" ];
		extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
	};
}
