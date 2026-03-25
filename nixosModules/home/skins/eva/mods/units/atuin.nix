{ config, pkgs, lib, ... }:
let cfg = config.atuin; in
{
	programs.atuin = {
		enableNushellIntegration = true;
		enableZshIntegration = true;
		settings = {
			auto_sync = true;
			sync_frequency = "5m";
			sync_address = "https://api.atuin.sh";
			search_mode = "prefix";
		};
	};
}
