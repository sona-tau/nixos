{ ... }: {
	flake.modules.nixos.fidi = { config, ... }: {
		sops.secrets."fidi/access-token" = {
			sopsFile = ../secrets/hp.yaml;
		};

		# FIDI is a separate PHP app (not in nixpkgs), run as an OCI container.
		# It reaches Firefly via the Tailscale IP since *.hp resolves through
		# dnsmasq on the host, not inside the container.
		virtualisation.oci-containers.containers.fidi = {
			image = "fireflyiii/data-importer:latest";

			environment = {
				FIREFLY_III_URL = "http://firefly.hp";
				VANITY_URL = "http://fidi.hp";
				TRUSTED_PROXIES = "**";
			};

			environmentFiles = [ config.sops.secrets."fidi/access-token".path ];
			ports = [ "127.0.0.1:8087:8080" ];
			extraOptions = [ "--add-host=firefly.hp:10.88.0.1" ];
		};

		# Allow the Podman bridge to reach Caddy on port 80 so FIDI can talk to Firefly.
		networking.firewall.interfaces.podman0.allowedTCPPorts = [ 80 ];

		services.caddy.virtualHosts."http://fidi.hp".extraConfig = "reverse_proxy localhost:8087";
	};
}
