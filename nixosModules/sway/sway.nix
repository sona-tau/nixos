{ lib, ... }:
let
cfg = config.backup-wm;
swayConfig = pkgs.writeText "greetd-sway-config" ''
# `-l` activates layer-shell mode. Notice that `swaymsg exit` will run after gtkgreet.
input * {
    xkb_layout mtgap-mod
}
exec "${pkgs.greetd.gtkgreet}/bin/gtkgreet -l; swaymsg exit"
bindsym Mod4+shift+e exec swaynag \
            -t warning \
            -m 'What do you want to do?' \
            -b 'Poweroff' 'systemctl poweroff' \
            -b 'Reboot' 'systemctl reboot'
'';
in {
    options.backup-wm = {
        sway.enable = lib.mkEnableOption "enable";
    };

#		greetd = {
#			enable = true;
#			settings = {
#				initial_session = "niri";
#				user = "diego";
#				default_session = {
#					command = "${pkgs.sway}/bin/sway --config ${swayConfig}";
#				};
#			};
#		};

}
