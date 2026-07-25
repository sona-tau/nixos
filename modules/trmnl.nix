_: {
  flake.modules.nixos.trmnl =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      sops.secrets = {
        "trmnl/app_secret" = { };
        "trmnl/database_password" = { };
      };

      services.postgresql = {
        enable = true;
        ensureDatabases = [ "terminus" ];
        ensureUsers = [
          {
            name = "terminus";
            ensureDBOwnership = true;
          }
        ];
      };

      # --- Valkey, native ---
      services.valkey.servers.terminus = {
        enable = true;
        port = 6379;
        bind = "127.0.0.1";
      };

      # --- Terminus, containerized ---
      virtualisation = {
        podman.enable = true;
        oci-containers = {
          backend = "podman";
          containers.terminus = {
            image = "ghcr.io/usetrmnl/terminus:latest";
            autoStart = true;
            environmentFiles = [ config.sops.secrets.terminus-env.path ];
            environment = {
              API_URI = "localhost:2300";
              HANAMI_PORT = "2300";
              DATABASE_URL = "postgres://terminus@127.0.0.1:5432/terminus";
              KEYVALUE_URL = "redis://127.0.0.1:6379";
            };
            # host networking so 127.0.0.1 inside the container reaches
            # the natively-run Postgres/Valkey on the host
            extraOptions = [ "--network=host" ];
            volumes = [ "/var/lib/terminus/public:/app/public" ];
          };
        };
      };

      networking.firewall.allowedTCPPorts = [ 2300 ];
      systemd.tmpfiles.rules = [ "d /var/lib/terminus/public 0755 root root -" ];
    };
}
