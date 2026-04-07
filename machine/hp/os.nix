{ config, pkgs, lib, ... }: {
	imports = [ ./hardware.nix ];

	system.stateVersion = "25.05"; # DO NOT CHANGE

	boot = {
		kernelPackages = pkgs.linuxPackages_hardened;
		supportedFilesystems.zfs = true;
		kernelModules = [ "cdrom" ];
	};

	networking = {
		hostName = "hp";
		hostId = "924e4a77";
	};

	users.users."sona" = {
		packages = with pkgs; [
			caddy
			aerc
			aria2
			borgbackup
			curl
			gcc
			git
			neovim
			pass
			yt-dlp
			just
			wget
			nnn
			zellij
			gum
			python3
			onedrive
			gawk
			coreutils-full
			findutils
			jq
			par2cmdline
			gnutar
			xz
			mpv
			libdvdcss
			libdvdread
			libdvdnav
			libbluray
			libbdplus
			libaacs
			libcdr
			libcdio
			libcdaudio
			libcdio-paranoia
			vlc
			sway
			kiwix
			kiwix-tools
			libkiwix
			zim
			zim-tools
			jellyfin
			jellyfin-web
			jellyfin-ffmpeg
			immich
			immich-cli
			smartmontools
			tmux
		] ++ (with pkgs.python313Packages; [
			zlib-ng
			isal
		]);
	};

	environment.systemPackages = with pkgs; [ ed zfs ];

	services = {
		# lidarr.enable = true;    # TODO: not finished
		# sonarr.enable = true;    # TODO: not finished
		# radarr.enable = true;    # TODO: not finished
		# jellyseerr.enable = true; # TODO: not finished
		traccar.enable = true;
		logrotate.checkConfig = false; # Required by hardened profile

		smartd = {
			enable = true;
			autodetect = true;
			defaults.monitored = "-a -o on -s (S/../.././02|L/../../7/04) -m sona@stau.space -M exec /etc/smartd-ntfy.sh -M test";

			notifications = {
				mail.enable = false;
				wall.enable = false;
				test.enable = true;
			};
		};

		zfs = {
			autoScrub.enable = true;

			autoSnapshot = {
				enable = true;
				flags = "-k -p --utc";
			};
		};

		# qbittorrent — TODO: rarely used, prefer aria2c; re-enable when needed

		netdata = {
			enable = true;

			package = pkgs.netdata.override {
				withCloudUi = true;
			};

			config.global = {
				"memory mode" = "ram";
				"debug log" = "none";
				"access log" = "none";
				"error log" = "syslog";
			};
		};

		radicale = {
			enable = true;

			settings = {
				server.hosts = [ "0.0.0.0:5232" "[::]:5232" ];
				storage.filesystem_folder = "/var/lib/radicale/collections";

				auth = {
					type = "htpasswd";
					htpasswd_filename = "/etc/radicale/users";
					htpasswd_encryption = "bcrypt";
				};
			};

			rights = {
				root = {
					user = ".+";
					collection = "";
					permissions = "RWrw";
				};

				principal = {
					user = ".+";
					collection = "{user}";
					permissions = "RWrw";
				};

				calendars = {
					user = ".+";
					collection = "{user}/[^/]+";
					permissions = "RWrw";
				};
			};
		};

		openssh.settings.AcceptEnv = [ "GIT_PROTOCOL" ];

		jellyfin = {
			enable = true;
			openFirewall = true;
		};

		home-assistant = {
			enable = true;
			openFirewall = true;

			extraComponents = [
				"esphome"
				"met"
				"isal"
				"radio_browser"
			];

			config.default_config = {};
		};

		immich = {
			enable = true;
			port = 2283;
			host = "0.0.0.0";
			mediaLocation = "/var/lib/immich";
			openFirewall = true;
			machine-learning.enable = true;
		};

		forgejo = {
			enable = true;
			database.type = "postgres";
			lfs.enable = true;

			settings = {
				service.DISABLE_REGISTRATION = false;

				ui = {
					DEFAULT_THEME = "custom";
					THEMES = "catppuccin-latte-rosewater,catppuccin-latte-flamingo,catppuccin-latte-pink,catppuccin-latte-mauve,catppuccin-latte-red,catppuccin-latte-maroon,catppuccin-latte-peach,catppuccin-latte-yellow,catppuccin-latte-green,catppuccin-latte-teal,catppuccin-latte-sky,catppuccin-latte-sapphire,catppuccin-latte-blue,catppuccin-latte-lavender,catppuccin-frappe-rosewater,catppuccin-frappe-flamingo,catppuccin-frappe-pink,catppuccin-frappe-mauve,catppuccin-frappe-red,catppuccin-frappe-maroon,catppuccin-frappe-peach,catppuccin-frappe-yellow,catppuccin-frappe-green,catppuccin-frappe-teal,catppuccin-frappe-sky,catppuccin-frappe-sapphire,catppuccin-frappe-blue,catppuccin-frappe-lavender,catppuccin-macchiato-rosewater,catppuccin-macchiato-flamingo,catppuccin-macchiato-pink,catppuccin-macchiato-mauve,catppuccin-macchiato-red,catppuccin-macchiato-maroon,catppuccin-macchiato-peach,catppuccin-macchiato-yellow,catppuccin-macchiato-green,catppuccin-macchiato-teal,catppuccin-macchiato-sky,catppuccin-macchiato-sapphire,catppuccin-macchiato-blue,catppuccin-macchiato-lavender,catppuccin-mocha-rosewater,catppuccin-mocha-flamingo,catppuccin-mocha-pink,catppuccin-mocha-mauve,catppuccin-mocha-red,catppuccin-mocha-maroon,catppuccin-mocha-peach,catppuccin-mocha-yellow,catppuccin-mocha-green,catppuccin-mocha-teal,catppuccin-mocha-sky,catppuccin-mocha-sapphire,catppuccin-mocha-blue,catppuccin-mocha-lavender";
				};

				server.SSH_PORT = lib.head config.services.openssh.ports;

				actions = {
					ENABLED = true;
					DEFAULT_ACTIONS_URL = "github";
				};
			};
		};
	};

	systemd.tmpfiles.rules = [
		"d '${config.services.forgejo.stateDir}/public' - forgejo forgejo - -"
		"d '${config.services.forgejo.stateDir}/public/assets' - forgejo forgejo - -"
		"d '${config.services.forgejo.stateDir}/public/assets/css' - forgejo forgejo - -"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-blue-auto.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-blue-auto.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-flamingo-auto.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-flamingo-auto.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-frappe-blue.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-frappe-blue.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-frappe-flamingo.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-frappe-flamingo.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-frappe-green.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-frappe-green.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-frappe-lavender.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-frappe-lavender.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-frappe-maroon.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-frappe-maroon.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-frappe-mauve.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-frappe-mauve.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-frappe-peach.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-frappe-peach.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-frappe-pink.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-frappe-pink.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-frappe-red.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-frappe-red.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-frappe-rosewater.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-frappe-rosewater.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-frappe-sapphire.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-frappe-sapphire.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-frappe-sky.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-frappe-sky.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-frappe-teal.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-frappe-teal.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-frappe-yellow.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-frappe-yellow.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-green-auto.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-green-auto.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-latte-blue.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-latte-blue.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-latte-flamingo.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-latte-flamingo.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-latte-green.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-latte-green.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-latte-lavender.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-latte-lavender.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-latte-maroon.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-latte-maroon.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-latte-mauve.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-latte-mauve.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-latte-peach.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-latte-peach.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-latte-pink.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-latte-pink.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-latte-red.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-latte-red.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-latte-rosewater.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-latte-rosewater.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-latte-sapphire.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-latte-sapphire.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-latte-sky.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-latte-sky.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-latte-teal.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-latte-teal.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-latte-yellow.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-latte-yellow.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-lavender-auto.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-lavender-auto.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-macchiato-blue.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-macchiato-blue.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-macchiato-flamingo.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-macchiato-flamingo.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-macchiato-green.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-macchiato-green.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-macchiato-lavender.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-macchiato-lavender.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-macchiato-maroon.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-macchiato-maroon.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-macchiato-mauve.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-macchiato-mauve.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-macchiato-peach.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-macchiato-peach.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-macchiato-pink.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-macchiato-pink.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-macchiato-red.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-macchiato-red.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-macchiato-rosewater.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-macchiato-rosewater.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-macchiato-sapphire.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-macchiato-sapphire.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-macchiato-sky.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-macchiato-sky.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-macchiato-teal.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-macchiato-teal.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-macchiato-yellow.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-macchiato-yellow.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-maroon-auto.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-maroon-auto.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-mauve-auto.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-mauve-auto.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-mocha-blue.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-mocha-blue.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-mocha-flamingo.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-mocha-flamingo.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-mocha-green.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-mocha-green.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-mocha-lavender.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-mocha-lavender.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-mocha-maroon.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-mocha-maroon.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-mocha-mauve.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-mocha-mauve.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-mocha-peach.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-mocha-peach.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-mocha-pink.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-mocha-pink.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-mocha-red.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-mocha-red.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-mocha-rosewater.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-mocha-rosewater.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-mocha-sapphire.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-mocha-sapphire.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-mocha-sky.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-mocha-sky.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-mocha-teal.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-mocha-teal.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-mocha-yellow.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-mocha-yellow.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-peach-auto.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-peach-auto.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-pink-auto.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-pink-auto.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-red-auto.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-red-auto.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-rosewater-auto.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-rosewater-auto.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-sapphire-auto.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-sapphire-auto.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-sky-auto.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-sky-auto.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-teal-auto.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-teal-auto.css}"
		"C+ '${config.services.forgejo.stateDir}/public/assets/css/theme-catppuccin-yellow-auto.css' - forgejo forgejo - ${../../assets/forgejo-css/catppuccin-gitea/theme-catppuccin-yellow-auto.css}"
	];

	nix = {
		optimise.automatic = true;
		settings.auto-optimise-store = true;

		gc = {
			automatic = true;
			dates = "weekly";
			options = "--delete-older-than 30d";
		};
	};
}
