{ ... }: {
  flake.modules.nixos.readeck =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      services.readeck = {
        enable = true;

        settings.server = {
          host = "127.0.0.1";
          port = 8090;
        };
      };

      # Readeck tries to write a generated secret_key back to its config file,
      # which lives in the read-only Nix store. Provide it via env instead.
      # The "-" prefix makes EnvironmentFile optional so first boot works.
      systemd.services.readeck = {
        preStart = ''
          				if [ ! -f /var/lib/readeck/.env ]; then
          					printf 'READECK_SECRET_KEY=%s\n' \
          						"$(${pkgs.openssl}/bin/openssl rand -hex 32)" \
          						> /var/lib/readeck/.env
          					chmod 600 /var/lib/readeck/.env
          				fi
          			'';

        serviceConfig.EnvironmentFile = "-/var/lib/readeck/.env";
      };
    };
}
