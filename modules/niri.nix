{ ... }: {
	flake.modules.homeManager.niri = { pkgs, ... }: {
		# services.swww.enable = true;

		programs.anyrun.enable = true;

		home = {
			file.".config/niri/config.kdl".source = ../assets/niri/config.kdl;
			packages = with pkgs; [ niri ];
		};
	};
}
