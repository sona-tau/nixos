{ config, lib, pkgs, ... }:
let
	cfg = config.backup-wm.i3;
in {
	options.cfg.enable = lib.mkEnableOption "backup window manager - i3";

	config = lib.mkIf cfg.enable;
		environment.pathsToLink = [ "/libexec" ];

		services.xserver = {
			enable = true;
			desktopManager.xterm.enable = false;
			displayManager.startx.enable = true;

			windowManager.i3 = {
				enable = true;
				extraPackages = with pkgs; [
					dmenu
					i3status
					i3lock
					i3blocks
				];
			};
		};
	};
}
