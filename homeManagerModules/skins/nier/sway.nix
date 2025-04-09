{ config, pkgs, lib, hostname, ... }:
let cfg = config.rice.nier; in
{
    config = lib.mkIf cfg.enable {

        services.gammastep = {
            enable = true;
            dawnTime = "05:48-06:59";
            duskTime = "17:47-19:04";
            temperature = {
                night = 2000;
            };
        };

        programs.eww = {
            enable = true;
            configDir = ./eww;
        };
        home = {
            packages = with pkgs; [
                wl-clipboard
                tofi
                (lib.hiPrio swayfx)
            ];

            pointerCursor = {
                enable = true;
                name = "banana";
                package = pkgs.banana-cursor;
                size = lib.mkForce 64;
            };
        };
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
                    top = 3;
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
                shadows enable
                shadow_blur_radius 0
                shadow_color #00000000
                blur enable

                exec eww daemon
                exec eww open workspaces
                exec eww open clock
                exec eww open battery
                '';
            swaynag.enable = true;
        };
    };
}
