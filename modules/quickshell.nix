{ ... }: {
	flake.modules.homeManager.quickshell = { config, lib, pkgs, inputs, ... }: let cfg = config.my.quickshell; in {
		options.my.quickshell.enable = lib.mkEnableOption "quickshell";

		config = lib.mkIf cfg.enable {
			home.packages = [ inputs.quickshell.packages."x86_64-linux".default ];
		};
	};
}
