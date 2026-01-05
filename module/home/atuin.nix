{ config, lib, ... }: {
	config.programs.atuin = {
		enable = true;
		enableZshIntegration = lib.mkIf (config.shell == "zsh") true;

		settings = {
			auto_sync = true;
			sync_frequency = "5m";
			sync_address = "https://api.atuin.sh";
			search_mode = "prefix";
		};
	};
}
