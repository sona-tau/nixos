{ config, lib, ... }:
let
	cfg = config.my.network;
in {
	options.cfg = {
		enableTailscale = lib.mkEnableOption "tailscale";
	};

	config = {
		services = {
			openssh.enable = true;
			tailscale.enable = lib.mkIf cfg.enableTailscale true;
		};

		networking = {
			networkmanager.enable = true;
			firewall.enable = true;

			extraHosts = ''
				127.0.0.1 localhost.localdomain localhost
			'';
		};
	};
}
