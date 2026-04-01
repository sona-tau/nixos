{ ... }: {
	flake.modules.homeManager.icons = { config, lib, pkgs, ... }: let cfg = config.my.icons; in {
		options.my.icons.enable = lib.mkEnableOption "all of the icon packages that work together";

		config = lib.mkIf cfg.enable {
			home.packages = with pkgs; [
				material-design-icons
				weather-icons
				gnomeExtensions.gtk4-desktop-icons-ng-ding
				nixos-icons
				icon-library
				iconpack-obsidian
				tango-icon-theme
				dracula-icon-theme
				colloid-icon-theme
				arc-icon-theme
				lucide
				marwaita-icons
				kdePackages.oxygen-icons
			];
		};
	};
}
