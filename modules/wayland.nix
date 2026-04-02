{ config, ... }: {
	flake.modules.homeManager.wayland = {
		imports = with config.flake.modules.homeManager; [
			eww
			foot
			gammastep
			niri
			quickshell
			sway
		];

		my.roles.wayland.pkgSet.enable = true;
	};
}
