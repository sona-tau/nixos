{
    config,
    lib,
    pkgs,
    ...
}: let cfg = config.rice.nier; in {
    config = lib.mkIf cfg.enable {
        home = {
            file.".config/niri/config.kdl".source = lib.mkIf cfg.enable ./config.kdl;
            packages = with pkgs; [
                niri
                swww
                mako
            ];
        };
    };
}
