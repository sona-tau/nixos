{ ... }: {
	flake.modules.homeManager.email = { pkgs, ... }: {
		home.packages = with pkgs; [
			aerc            # terminal email
			protonmail-export
			protonmail-bridge
			protonmail-bridge-gui
			protonmail-desktop
			thunderbird
		];
	};
}
