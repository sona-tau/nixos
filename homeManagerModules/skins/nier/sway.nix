{ config, pkgs, lib, hostname, ... }:
let cfg = config.rice.nier; in
{
    config = lib.mkIf cfg.enable {
        programs.eww = {
            enable = true;
        };
        home.packages = with pkgs; [
            wl-clipboard
            tofi
            (lib.hiPrio swayfx)
        ];
        wayland.windowManager.sway = {
            enable = true;
            package = pkgs.swayfx;
            checkConfig = false;
            config = rec {
                bars = [
                    { command = "${pkgs.eww}/bin/eww open bar"; }
                    { command = "${pkgs.eww}/bin/eww open clock"; }
                    { command = "${pkgs.eww}/bin/eww open battery"; }
                ];
                modifier = "Mod4";
                terminal = "alacritty";
                startup = [
                    #{ command = "librewolf"; }
                ];
                down = "t";
                up = "n";
                left = "h";
                menu = "tofi-run | xargs swaymsg exec --";
                gaps = {
                    top = 6;
                    inner = 4;
                    outer = 10;
                };
                input = {
                    "1:1:AT_Translated_Set_2_keyboard" = {
                        xkb_layout = "us(dvorak)";
                        xkb_options = "caps:swapescape,grp:switch";
                    };
                    "type:touchpad" = {
                        tap = "enabled";
                        natural_scroll = "enabled";
                        scroll_factor = "0.1";
                        accel_profile = "flat";
                        pointer_accel = "0.0";
                    };
                };
                keybindings = let
                    m = config.wayland.windowManager.sway.config.modifier;
                in
                    lib.mkOptionDefault {
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
            extraConfig = ''
                corner_radius 7
                smart_corner_radius on
                shadows on
                blur enable
                '';
            swaynag.enable = true;
        };
    };
}
