{ config, lib, hostname, ... }:
{
    wayland.windowManager.sway = {
        checkConfig = false;
        config = rec {
            modifier = "Mod4";
            terminal = "foot";
            startup = [
#{ command = "librewolf"; }
            ];
            down = "t";
            up = "n";
            left = "h";
#right = "s";
            menu = "tofi-run | xargs swaymsg exec --";
            gaps = {
                inner = 2;
                outer = 2;
#smartBorders = "on";
#smartGaps = "on";
            };
            input = {
                "1:1:AT_Translated_Set_2_keyboard" = {
                    xkb_layout = "us(dvorak)";
                    xkb_options = "caps:swapescape,grp:switch";
                };
                "type:touchpad" = {
                    tap = "enabled";
                    natural_scroll = "enabled";
                };
            };
            output = {
                "*" = {
                    bg = lib.mkForce "/home/diego/Media/Pictures/Wallpapers/rock-tile.png tile";
                };
            };
#            output = {
#                "*" = {
#                    bg = "/home/diego/Media/Pictures/Wallpapers/bliss.png center";
#                };
#            };
#			output = {
#				"*" = {
#					bg = "/home/diego/Media/Pictures/Wallpapers/kanagawa-dragon.png fill";
#				};
#			};
            keybindings = let
                m = config.wayland.windowManager.sway.config.modifier;
#drun = "tofi-run | xargs swaymsg exec --";
            in
                lib.mkOptionDefault {
                    "${m}+Shift+c" = "reload";
                    "${m}+Shift+r" = "restart";
                    "${m}+x" = "layout stacking";
                    "${m}+Shift+e" = "exec --no-startup-id \"sway-nagbar -t warning -m 'kill this window manager?' -B 'with HAMMERS' 'sway-msg exit'\"";

#"${m}+p" = "exec ${drun}";
                    "${m}+o" = "exec obsidian --ozone-platform-hint=auto";
                    "${m}+g" = "exec MOZ_ENABLE_WAYLLAND=1 librewolf";
                    "${m}+Shift+g" = "exec signal-desktop --ozone-platform-hint=auto";
                    "${m}+Shift+q" = "kill";
                    "${m}+s" = "focus right";
                    "${m}+l" = "grim -g \"$(slurp)\" - | tee /tmp/image.png | wl-copy";
                };
            window = {
                border = 2;
                titlebar = false;
            };
        };
        extraConfig = ''
#corner_radius 2
#smart_corner_radius on
#shadows on
#blur enable
#bar {
#    position top
#    # This makes the tabs come at the same height as the bar. We then make the bar transparent and we have them both "fused" 
#    mode overlay
#    # When the status_command prints a new line to stdout, swaybar updates.
#    # The default just shows the current date and time.
#    status_command while date +'%Y-%m-%d %l:%M:%S %p'; do sleep 1; done
#    # Workspace buttons don't look good when the bar is transparent
#    workspace_buttons no
#    colors {
#        statusline #ffffff
#        #background #323232
#        # Transparent bar
#        background #ffffff10
#        inactive_workspace #32323200 #32323200 #5c5c5c
#    }
#}
            '';
        swaynag.enable = true;
    };
}
