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

			settings.server = {
				http_addr = "127.0.0.1";
				http_port = 3001;
				domain = "grafana.hp";
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
