{
    config,
    inputs,
    pkgs,
    lib,
    ...
}: let cfg = config.eva; in {
    home.packages = with pkgs; lib.mkIf cfg.enable [
        waybar
        inputs.niri.packages.x86_64-linux.niri-stable
        cage
        wl-clipboard
        swww
        swaylock
        tofi
        execline
    ];

    home.sessionVariables = lib.mkIf cfg.enable {
        XDG_SESSION_TYPE = "wayland";
        GDK_BACKEND = "wayland";
        MOZ_ENABLE_WAYLAND = 1;
        QT_QPA_PLATFORM = "wayland";
        QT_QPA_PLATFORMTHEME = "qt5ct";
        NIXOS_OZONE_WL = "1";
    };
}
