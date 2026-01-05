{ config, lib, environment, ... }: {
	config.programs.direnv = {
		enable = true;
		enableZshIntegration = lib.mkIf (config.shell == "zsh") true;
		nix-direnv.enable = true;
	};
}
