{ ... }: {
	flake.modules.homeManager.icons = { pkgs, ... }: {
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
}
