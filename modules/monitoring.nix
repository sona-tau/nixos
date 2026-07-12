{ ... }: {
  flake.modules.nixos.monitoring = { config, ... }: {
    sops.secrets."grafana/secret-key".sopsFile = ../secrets/hp.yaml;

    sops.templates."grafana.env" = {
      content = ''
        				GF_SECURITY_SECRET_KEY=${config.sops.placeholder."grafana/secret-key"}
        			'';
      owner = "grafana";
      mode = "0400";
    };

    systemd.services.grafana.serviceConfig.EnvironmentFile = config.sops.templates."grafana.env".path;

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
            static_configs = [ { targets = [ "127.0.0.1:9100" ]; } ];
          }
          {
            job_name = "smartctl";
            static_configs = [ { targets = [ "127.0.0.1:9633" ]; } ];
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

          security.secret_key = "$__env{GF_SECURITY_SECRET_KEY}";
        };

        provision = {
          enable = true;

          datasources.settings.datasources = [
            {
              name = "Prometheus";
              type = "prometheus";
              url = "http://127.0.0.1:9090";
              isDefault = true;
            }
          ];
        };
      };
    };
  };
}
