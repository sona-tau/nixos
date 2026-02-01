{ config, inputs, lib, pkgs, ... }:
let cfg = config.wayland; in
{
    options.wayland = with lib; {
        enable = mkEnableOption "wayland";
        niri = {
            enable = mkEnableOption "niri";
        };
        sway = {
            enable = mkEnableOption "sway";
        };
        waybar = {
            enable = mkEnableOption "waybar";
        };
    };

    config = with lib; {
        wayland.windowManager.sway = mkIf cfg.sway.enable {
            enable = true;
        };

        home.packages = with pkgs; mkIf cfg.enable [
            (mkIf cfg.waybar.enable waybar)
            (mkIf cfg.niri.enable inputs.niri.packages.x86_64-linux.niri-stable)
            (mkIf cfg.niri.enable cage)
            wl-clipboard
            swww
            swaylock
            tofi
            execline
        ];

        home.sessionVariables = mkIf cfg.enable {
#XDG_SESSION_TYPE = "wayland";
            GDK_BACKEND = "wayland";
            MOZ_ENABLE_WAYLAND = 1;
            QT_QPA_PLATFORM = "wayland";
            QT_QPA_PLATFORMTHEME = "qt5ct";
            NIXOS_OZONE_WL = "1";
        };
    };
}
