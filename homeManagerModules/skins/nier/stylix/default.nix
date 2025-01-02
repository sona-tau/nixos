{
    config,
    pkgs,
    inputs,
    lib,
    ...
}: let cfg = config.rice.nier; in {
    config = {
        stylix = lib.mkIf cfg.enable {
            enable = true;
            autoEnable = true;
            base16Scheme = "${pkgs.base16-schemes}/share/themes/material-darker.yaml";

            image = ./forest.jpg;

            fonts = {
                monospace = {
                    package = pkgs.nerdfonts;
                    name = "IBM Plex Mono";
                };
                sansSerif = {
                    package = pkgs.dejavu_fonts;
                    name = "DejaVu Sans";
                };
                serif = {
                    package = pkgs.dejavu_fonts;
                    name = "DejaVu Serif";
                };

                sizes = {
                    applications = 12;
                    terminal = 13;
                    desktop = 10;
                    popups = 10;
                };
            };

            cursor = {
                name = "banana-cursor";
                package = pkgs.banana-cursor;
            };

            /*
            targets = {
                grub.enable = true;
                grub.useImage = true;
                plymouth.enable = true;
            };
            */
        };
    };
}
