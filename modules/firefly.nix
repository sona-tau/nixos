{ ... }: {
  flake.modules.nixos.firefly = { config, ... }: {
    sops.secrets = {
      "firefly-iii-data-importer/personal-access-token" = {
        sopsFile = ../secrets/hp.yaml;
        owner = config.services.firefly-iii-data-importer.user;
      };
      "firefly-iii/app-key" = {
        sopsFile = ../secrets/hp.yaml;
        owner = config.services.firefly-iii.user;
      };
    };

    services = {
      firefly-iii-data-importer = {
        enable = true;
        group = config.services.caddy.group;

        settings = {
          APP_ENV = "local";
          APP_DEBUG = true;
          LOG_LEVEL = "debug";
          LOG_CHANNEL = "stack";

          FIREFLY_III_ACCESS_TOKEN =
            config.sops.secrets."firefly-iii-data-importer/personal-access-token".path;
        };
      };

      firefly-iii = {
        enable = true;

        # Socket group must match Caddy so phpfpm socket is readable by the web server
        group = config.services.caddy.group;

        settings = {
          APP_KEY_FILE = config.sops.secrets."firefly-iii/app-key".path;
          APP_ENV = "local";
          APP_URL = "http://firefly.hp";
          SITE_OWNER = "sona@hp";
          LOG_CHANNEL = "stdout";
          MAIL_MAILER = "log";

          DB_CONNECTION = "pgsql";
          DB_DATABASE = "firefly-iii";
          DB_USERNAME = "firefly-iii";
        };
      };

      # Creates the firefly-iii PostgreSQL user and database.
      # Peer auth over the Unix socket (/run/postgresql) — no password needed.
      postgresql = {
        ensureDatabases = [ "firefly-iii" ];

        ensureUsers = [
          {
            name = "firefly-iii";
            ensureDBOwnership = true;
          }
        ];
      };

      # Caddy serves the PHP app via FastCGI directly to the phpfpm socket.
      # root must point at the package's public/ directory.
      caddy.virtualHosts = {
        "http://firefly.hp".extraConfig = ''
          					root * ${config.services.firefly-iii.package}/public
          					php_fastcgi unix/${config.services.phpfpm.pools.firefly-iii.socket}
          					file_server
          				'';
        "http://fidi.hp".extraConfig = "reverse_proxy localhost:8087";
      };
    };
  };
}
