{ ... }: {
	flake.modules.homeManager.minecraft = { config, pkgs, lib, ... }: let cfg = config.my.minecraft; in {
		options = {
			my.minecraft = {
				enable = lib.mkEnableOption "minecraft";
			};
		};

		config = lib.mkIf cfg.enable {
			home.packages = with pkgs; [
				prismlauncher
			];
		};
	};
}
