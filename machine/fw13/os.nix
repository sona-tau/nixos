{ pkgs, lib, inputs, ... }: {
	system.stateVersion = "23.11"; # DO NOT CHANGE

	boot = {
		loader.grub.theme = lib.mkForce pkgs.catppuccin-grub;

		plymouth = {
			enable = true;
			theme = "blahaj";
			themePackages = [ pkgs.plymouth-blahaj-theme ];
		};

		kernelParams = [
			"nvme.noacpi=1"           # NVMe power saving
			"pcie_aspm=force"         # PCIe Active State Power Management
			"mem_sleep_default=deep"  # S3 deep sleep (better suspend power draw)
		];
	};

	networking = {
		hostName = "fw13";

		extraHosts = ''127.0.0.1 localhost.localdomain localhost'';
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

	console.useXkbConfig = true;

	powerManagement.powertop.enable = true;

	services = {
		getty.autologinUser = "sona";
		gnome.gnome-keyring.enable = true;
		fprintd.enable = true;
		fwupd.enable = true;
		power-profiles-daemon.enable = true;
		thermald.enable = true;
		upower.enable = true;

		xserver.xkb = {
			layout = "mtgap-mod";

			extraLayouts."mtgap-mod" = {
				description = "MTGAP Layout (modified)";
				languages = [ "eng" ];
				symbolsFile = ../../assets/mtgap-mod.xkb;
			};
		};

		nfs.server = {
			enable = true;
			exports = ''
				~/omnium-gatherum  est(rw,nohide,insecure,no_subtree_check,no_root_squash)
			'';
		};

		pipewire = {
			enable = true;
			alsa.enable = true;
			alsa.support32Bit = true;
			pulse.enable = true;
			jack.enable = true;
		};
	};

	systemd.services.battery-charge-limit = {
		description = "Set battery charge limit to 80%";
		wantedBy = [ "multi-user.target" ];
		serviceConfig = {
			Type = "oneshot";
			RemainAfterExit = true;
			ExecStart = "${pkgs.bash}/bin/bash -c 'echo 80 > /sys/class/power_supply/BAT1/charge_control_end_threshold'";
		};
	};

	users.users."sona" = {
		packages = with pkgs; [
			neovim
			git
			curl
		];

		extraGroups = [
			"plugdev"
			"adbusers"
			"seat"
			"video"
			"input"
		];
	};

	nixpkgs.config.permittedInsecurePackages = [ "quickjs-2025-09-13-2" ];

	environment = {
		variables.GLFW_IM_MODULE = "ibus";

		systemPackages = with pkgs; [
			borgbackup
			onedrive
			pass
			powertop
			linuxPackages.turbostat    # Intel RAPL power/freq per-core breakdown (works where powertop doesn't)
			qemu
			ed
			just
			# firefoxpwa
			inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
		];
	};

	fonts = {
		enableDefaultPackages = true;

		packages = with pkgs; [
			cozette
			scientifica
			ipafont
			dejavu_fonts
			ipaexfont
			ibm-plex
			ocr-a
			apl386
			bqn386
			hermit
			# toki pona
			nasin-nanpa
			nasin-nanpa-helvetica
			nasin-nanpa-ucsur
			linja-pi-pu-lukin
			hunspellDicts.tok
		] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
	};

	security.pki.certificateFiles = [ ../../assets/certs/protonmail-bridge.pem ];
	security.pam.services.doas.fprintAuth = true;

	programs = {
		firefox = {
			enable = true;
			package = pkgs.firefox;
			# nativeMessagingHosts.packages = [ pkgs.firefoxpwa ];
		};
	};

	nix.settings = {
		substituters = [ "https://cache.iog.io" ];
		extra-substituters = [ "https://noctalia.cachix.org" ];
		trusted-public-keys = [ "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=" ];
		extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
	};
}
