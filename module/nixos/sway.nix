{ config, lib, pkgs, user, ... }:
let
	cfg = config.backup-wm.sway;
	swayConfig = pkgs.writeText "greetd-sway-config" ''
		# `-l` activates layer-shell mode. Notice that `swaymsg exit` will run after gtkgreet.
		input * {
			xkb_layout mtgap-mod
		}

		exec "${pkgs.greetd.gtkgreet}/bin/gtkgreet -l; swaymsg exit"
		bindsym Mod4+shift+e exec swaynag -t warning -m 'What do you want to do?' -b 'Poweroff' 'systemctl poweroff' -b 'Reboot' 'systemctl reboot'
	'';
in {
	options.cfg.enable = lib.mkEnableOption "backup wayland windowmanager - sway";

	config = lib.mkIf cfg.enable {
		greetd = {
			enable = true;
			settings = {
				initial_session = "niri";
				user = "${user}";
				default_session = {
					command = "${pkgs.sway}/bin/sway --config ${swayConfig}";
				};
			};
		};
	};
}
