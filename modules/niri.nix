{ ... }: {
	flake.modules.homeManager.niri = { pkgs, ... }: {
		home = {
			file.".config/niri/config.kdl".source = ../assets/niri/config.kdl;
			packages = [ pkgs.libgbm ];
		};
	};
	flake.modules.nixos.niri = { ... }: {
		programs.niri.enable = true;
	};
}
