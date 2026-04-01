{ ... }: {
	flake.modules.homeManager.atuin = { config, lib, ... }: let cfg = config.my.atuin; in {
		options.my.atuin.enable = lib.mkEnableOption "atuin";

		config = lib.mkIf cfg.enable {
			programs.atuin = {
				enable = true;
				enableZshIntegration = config.my.shell == "zsh";
				settings = {
					auto_sync = true;
					sync_frequency = "5m";
					sync_address = "https://api.atuin.sh";
					search_mode = "prefix";
				};
			};
		};
	};
}
