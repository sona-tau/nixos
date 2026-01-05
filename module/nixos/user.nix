{ config, ... }: {
	config = {
		services.getty.autologinUser = "sona";

		home = {
			username = "sona";
			homeDirectory = "/home/sona";
			stateVersion = "23.11"; # WARNING: DO NOT EVER CHANGE THIS VALUE EVER

		};

		users = {
			defaultUserShell = pkgs.zsh;
			# groups."plugdev" = {}; # I don't remember what this was for

			users."sona" = {
				isNormalUser = true;
				description = "sona";
				shell = pkgs.zsh;

				extraGroups = [
					"networkmanager"
					"wheel"
					"plugdev"
					"adbusers"
					"docker"
				];

				# Always have these two packages:
				packages = with pkgs; [
					neovim
					zsh
				];
			};
		};
	};
}
