_: {
  flake.modules.nixos = {
    attic =
      {
        config,
        pkgs,
        lib,
        ...
      }:
      let
        hostname = config.networking.hostName;

        tokenSecret =
          if hostname == "hp" then
            "hp"
          else if hostname == "est" then
            "est"
          else if hostname == "fw13" then
            "fw13"
          else
            throw "Unknown hostname for attic token: ${hostname}";
      in
      {
        systemd.services.attic-watch-store = {
          description = "Push new /nix/store paths to the hp cache";
          wantedBy = [ "multi-user.target" ];
          after = [
            "network-online.target"
            "tailscaled.service"
          ];
          wants = [ "network-online.target" ];
          serviceConfig = {
            ExecStart = "${pkgs.attic-client}/bin/attic watch-store nixos-cache";
            Restart = "always";
            RestartSec = "10s";
            MemoryMax = "512M";
            User = "sona";
          };
        };

        environment.systemPackages = [ pkgs.attic-client ];

        sops.secrets."attic-token/${tokenSecret}" = {
          sopsFile = ../secrets/attic.yaml;
          owner = "root";
        };

        nix = {
          settings = {
            substituters = [
              "https://cache.nixos.org"
              "http://hp:8081/nixos-cache"
            ];

            trusted-public-keys = [
              "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
              "nixos-cache:sKr9AzJplaAjlwCzdxxf3jkSs669IvQTvO8W7xIx1Wg="
            ];
          };
        };
      };

    atticd = { config, pkgs, ... }: {
      environment.systemPackages = [ pkgs.attic-server ];

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
  };
}
