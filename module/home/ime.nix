{ config, pkgs, ... }: {
	config = {
		environment.variables.GLFW_IM_MODULE = "ibus";

		i18n.inputMethod = {
			type = "fcitx5";
			enable = true;
			ibus.engines = [ pkgs.ibus-engines.anthy ];

			fcitx5.addons = with pkgs; [
				fcitx5-anthy
				fcitx5-gtk
				qt6Packages.fcitx5-configtool
			];
		};
	};
}
