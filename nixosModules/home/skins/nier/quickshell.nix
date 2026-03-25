{ config, lib, pkgs, ... }:
let cfg = config.rice.nier; in
{
    config = lib.mkIf cfg.enable {
        home.packages = [
            pkgs.quickshell
        ];
    };
}
