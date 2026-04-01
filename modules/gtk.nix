{ ... }: {
	flake.modules.homeManager.gtk = { config, lib, pkgs, ... }: let cfg = config.my.gtk; in {
		options.my.gtk.enable = lib.mkEnableOption "gtk";

		config = lib.mkIf cfg.enable {
			home.packages = [ pkgs.dconf ];

			gtk = let
				catppuccin_name = "catppuccin-mocha-mauve-standard";
				catppuccin = pkgs.catppuccin-gtk.override {
					variant = "mocha";
					accents = [ "mauve" ];
				};
			in {
				enable = true;
				theme = {
					name = lib.mkForce catppuccin_name;
					package = lib.mkForce catppuccin;
				};
			};
		};
	};
}
