{
    config,
    lib,
    ...
}: let cfg = config.eva; in {
    programs.zathura = lib.mkIf cfg.enable {
        enable = true;
        selection-clipboard = "clipboard";
        recolor = true;
        recolor-keephue = false; # keep original color
    };
}
