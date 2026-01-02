{
    config,
    lib,
    pkgs,
    ...
}: let
	catppuccin_name = "catppuccin-mocha-mauve-standard";
	catppuccin = pkgs.catppuccin-gtk.override {
		variant = "mocha";
		accents = [ "mauve" ];
	};
	cfg = config.rice.nier;
in {
    config = lib.mkIf cfg.enable {
		gtk = {
			enable = true;
			theme = {
				name = lib.mkForce catppuccin_name;
				package = lib.mkForce catppuccin;
			};
		};

        home = {
            file.".config/niri/config.kdl".source = lib.mkIf cfg.enable ./config.kdl;
            packages = with pkgs; [
                niri
                swww
                mako
				material-design-icons
				weather-icons
				gnomeExtensions.gtk4-desktop-icons-ng-ding
				nixos-icons
            ];
        };
    };
}
