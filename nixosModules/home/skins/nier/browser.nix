{ config, lib, pkgs, inputs, ... }:
let cfg = config.rice.nier; in
{
    config = lib.mkIf cfg.enable {
        programs = {
            librewolf.enable = true;
            qutebrowser.enable = true;
        };

        home.packages = [
            pkgs.floorp-bin
        ];
    };
}
