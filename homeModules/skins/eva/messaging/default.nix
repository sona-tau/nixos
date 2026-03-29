{
    config,
    pkgs,
    lib,
    ...
}: let cfg = config.eva; in {
    home.packages = with pkgs; lib.mkIf cfg.enable [
        signal
        signald
        matrix
        irssi
    ];
}
