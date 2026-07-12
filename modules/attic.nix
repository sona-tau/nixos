{ ... }: {
	flake.modules.nixos.atticd = { config, ... }: {
		sops.secrets.atticd-env = {
			sopsFile = ../secrets/attic.yaml;
			owner = "root";
		};

		services.atticd = {
			enable = true;
			environmentFile = config.sops.secrets."atticd-env".path;

			settings = {
				listen = "[::]:8081";

				# SQLite + local storage (simplest for a NAS)
				# These are actually the module defaults, shown explicitly:
				database.url = "sqlite:///var/lib/atticd/server.db?mode=rwc";
				storage = {
					type = "local";
					path = "/var/lib/atticd/storage";
				};

				# Chunking config — defaults shown for reference.
				# WARNING: don't change these after data is stored,
				# it breaks deduplication.
				chunking = {
					nar-size-threshold = 64 * 1024;
					min-size = 16 * 1024;
					avg-size = 64 * 1024;
					max-size = 256 * 1024;
				};
			};
		};

		systemd.tmpfiles.rules = [ "d /var/lib/atticd/storage 0750 atticd atticd -" ];

		networking.firewall.allowedTCPPorts = [ 8081 ];
	};

	flake.modules.homeManager = {
		atticd = { pkgs, ... }: {
			home.packages = [ pkgs.attic-server ];
		};

		attic = { pkgs, ... }: {
			home.packages = [ pkgs.attic-client ];
		};
	};
}
