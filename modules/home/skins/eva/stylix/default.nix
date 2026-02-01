{
    config,
    pkgs,
    inputs,
    lib,
    ...
}: let cfg = config.eva; in {
    #imports = [ inputs.stylix.nixosModules.stylix ];
    stylix = lib.mkIf cfg.enable {
        enable = true;
        autoEnable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/oxocarbon-dark.yaml";

        image = ./nervLogoOxo.png;

        fonts = {
            monospace = {
                package = pkgs.nerdfonts.override { fonts = [ "iosevka-comfy.comfy" ];};
                name = "Iosevka Comfy";
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
                terminal = 15;
                desktop = 10;
                popups = 10;
            };
        };

        cursor = {
            name = "breeze-hacked-cursor-theme";
            package = pkgs.breeze-hacked-cursor-theme;
        };


        targets = {
            grub.enable = true;
            grub.useImage = true;
            plymouth.enable = true;
        };
    };
}
