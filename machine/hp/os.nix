{ pkgs, ... }: {
	imports = [ ./hardware.nix ];

	system.stateVersion = "24.11"; # DO NOT CHANGE

	networking = {
		hostName = "hp";
		firewall.allowedTCPPorts = [ 8096 8920 2283 ];
	};

	services = {
		jellyfin = {
			enable = true;
			openFirewall = true;
		};

		immich = {
			enable = true;
			openFirewall = true;
		};
	};

	environment.systemPackages = with pkgs; [
		borgbackup
	];
}
