{ config, lib, ... }: {
	config.programs.carapace = {
		enable = true;
		enableZshIntegration = lib.mkIf (config.shell == "zsh") true;
	};
}
