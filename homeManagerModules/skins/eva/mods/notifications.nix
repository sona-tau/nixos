{ config, lib, pkgs, ... }:
let cfg = config.notifications; in
{
	options.notifications = {
		enable = lib.mkEnableOption "notifications";
	};

	config = lib.mkIf cfg.enable {
		services = {
			mako = {
				enable = true;
			};
		};

		home.packages = [
			pkgs.libnotify
		];
	};
}
