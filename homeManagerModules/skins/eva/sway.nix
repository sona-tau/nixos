{
    config,
    lib,
    ...
}: let cfg = config.eva; in {
    wayland.windowManager.sway = lib.mkIf cfg.enable {
        enable = true;
        checkConfig = false;
        config = rec {
            modifier = "Mod4";
            terminal = "foot";
            startup = [
                { command = "floorp"; }
                { command = "waybar"; }
            ];
            down = "t";
            up = "n";
            left = "h";
            menu = "tofi-run | xargs swaymsg exec --";
            gaps = {
                inner = 2;
                outer = 2;
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
            keybindings = let
                m = config.wayland.windowManager.sway.config.modifier;
            in lib.mkForce {
                "${m}+Shift+c" = "reload";
                "${m}+Shift+r" = "restart";
                "${m}+x" = "layout stacking";
                "${m}+Shift+e" = "exec --no-startup-id \"sway-nagbar -t warning -m 'kill this window manager?' -B 'with HAMMERS' 'sway-msg exit'\"";
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
        swaynag.enable = true;
    };
}
