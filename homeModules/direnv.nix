{ config, lib, ... }: let cfg = config.my.direnv; in {
	options.my.direnv.enable = lib.mkEnableOption "direnv";

	config = lib.mkIf cfg.enable {
		programs.direnv = {
			enable = true;
			enableZshIntegration = config.my.shell == "zsh";
			nix-direnv.enable = true;
		};
	};
}
