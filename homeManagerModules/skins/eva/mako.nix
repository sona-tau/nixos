{
    config,
    pkgs,
    lib,
    ...
}: let cfg = config.eva; in {
    services.mako = lib.mkIf cfg.enable {
        enable = true;
        borderRadius = 5;
        borderSize = 1;
        font = lib.mkForce "Iosevka Elite";
        ignoreTimeout = true;
        extraConfig = "on-notify=exec mpv /home/diego/Media/sound.opus";
    };

    home.packages = lib.mkIf cfg.enable [ pkgs.libnotify ];
}
