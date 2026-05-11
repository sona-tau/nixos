{ ... }: {
	services = {
		prometheus = {
			enable = true;
			listenAddress = "127.0.0.1";
			port = 9090;

			exporters = {
				node = {
					enable = true;
					listenAddress = "127.0.0.1";
					port = 9100;

					enabledCollectors = [
						"systemd"
						"processes"
						"zfs"
					];
				};

				smartctl = {
					enable = true;
					listenAddress = "127.0.0.1";
					port = 9633;
				};
			};

			scrapeConfigs = [
				{
					job_name = "node";
					static_configs = [{ targets = [ "127.0.0.1:9100" ]; }];
				}
				{
					job_name = "smartctl";
					static_configs = [{ targets = [ "127.0.0.1:9633" ]; }];
				}
			];
		};

		grafana = {
			enable = true;

			settings = {
				server = {
					http_addr = "127.0.0.1";
					http_port = 3001;
					domain = "grafana.hp";
				};

				# TODO: move to sops secret once sops-nix is wired in
				security.secret_key = "SW2YcwTIb9zpOOhoPsMm";
			};

			provision = {
				enable = true;

				datasources.settings.datasources = [{
					name = "Prometheus";
					type = "prometheus";
					url = "http://127.0.0.1:9090";
					isDefault = true;
				}];
			};
		};
	};
}
