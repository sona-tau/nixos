{
    lib,
    pkgs,
    ...
}: {
        stylix = {
            enable = true;
            autoEnable = true;
            base16Scheme = {
                base00 = "#1C1917";
                base01 = "#544635";
                base02 = "#6a5134";
                base03 = "#5b3c43";
                base04 = "#6d4f48";
                base05 = "#b4bdc3";
                base06 = "#896638";
                base07 = "#bba79e";
                base08 = "#82746e";
                base09 = "#6b5d52";
                base0A = "#766351";
                base0B = "#6F5859";
                base0C = "#735D5A";
                base0D = "#73645B";
                base0E = "#866D53";
                base0F = "#9F8E86";
                slug = "zenbones";
                scheme = "Theme by zenbones-theme";
                author = "zenbones-theme";
            }; # "${pkgs.base16-schemes}/share/themes/material-darker.yaml";

            image = ./fushitsushawp1.jpg;

            fonts = {
                monospace = {
                    package = pkgs.nerd-fonts.mplus;
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
}
