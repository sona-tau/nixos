{
    config,
    pkgs,
    lib,
    ...
}: let cfg = config.eva; in {
    home.packages = with pkgs; lib.mkIf cfg.enable [
        ipafont
        ipaexfont
        takao
        nerdfonts
        fira-code-nerdfont
    ];
}
