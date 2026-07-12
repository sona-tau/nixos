{ ... }: {
  flake.modules.homeManager.gtk = { lib, pkgs, ... }: {
    home.packages = [ pkgs.dconf ];

    gtk =
      let
        catppuccin_name = "catppuccin-mocha-mauve-standard";
        catppuccin = pkgs.catppuccin-gtk.override {
          variant = "mocha";
          accents = [ "mauve" ];
        };
      in
      {
        enable = true;
        theme = {
          name = lib.mkForce catppuccin_name;
          package = lib.mkForce catppuccin;
        };
      };
  };
}
