{
    config,
    lib,
    ...
}: let cfg = config.eva; in {
    home.file = lib.mkIf cfg.enable {
        ".config/waybar/config".source = ./config;
        ".config/waybar/style.css".source = ./style.css;
    };
}
