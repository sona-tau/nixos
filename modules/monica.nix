{ ... }: {
	flake.modules.nixos.monica = { config, lib, pkgs, ... }: let
		monicaPkg = pkgs.monica.override { dataDir = config.services.monica.dataDir; };
	in {
		sops.secrets."monica/app-key" = {
			sopsFile = ../secrets/hp.yaml;
			owner = "monica";
		};

		services.monica = {
			enable = true;
			hostname = "monica.hp";
			appKeyFile = config.sops.secrets."monica/app-key".path;

			poolConfig = {
				"listen.owner" = "caddy";
				"listen.group" = "caddy";
				"listen.mode"  = "0660";
				"pm"                   = "dynamic";
				"pm.max_children"      = 5;
				"pm.start_servers"     = 2;
				"pm.min_spare_servers" = 1;
				"pm.max_spare_servers" = 3;
			};
		};

		# monica enables nginx by default; use Caddy instead.
		# Preserve the nginx group and user to satisfy monica's internal user configuration.
		services.nginx.enable = lib.mkForce false;
		users.groups.nginx = {};
		users.users.nginx = {
			isSystemUser = lib.mkDefault true;
			group        = "nginx";
		};

		services.caddy.virtualHosts."http://monica.hp".extraConfig = ''
			root * ${monicaPkg}/public
			php_fastcgi unix/${config.services.phpfpm.pools.monica.socket}
			file_server
		'';
	};
}
