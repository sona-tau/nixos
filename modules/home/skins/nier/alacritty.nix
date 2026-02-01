{ config, lib, pkgs, ... }:
let cfg = config.rice.nier; in
{
    config = lib.mkIf cfg.enable {
        programs.alacritty = {
            enable = true;
            settings = {
                font.size = 13;
                window = {
                    padding = {
                        x = 10;
                        y = 10;
                    };
                    opacity = lib.mkForce 1.0;
                };
            };
        };
    };
}
