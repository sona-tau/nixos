{
    config,
    pkgs,
    lib,
    ...
}: let cfg = config.eva; in {
    home.packages = lib.mkIf cfg.enable [
        pkgs.floorp
    ];
}
