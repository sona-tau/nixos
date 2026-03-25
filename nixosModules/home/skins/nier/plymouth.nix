{
    config,
    lib,
    pkgs,
    ...
}: let cfg = config.eva; in {
    config.home.packages = with pkgs; [
        plymouth
        plymouth-matrix-theme
        # plymouth-blahaj-theme
    ];
    /*
    programs = {
        plymouth.enable = true;
    }
    */
}
