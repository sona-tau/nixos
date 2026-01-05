{ config, ... }: {
	config.security = {
		polkit.enable = true;
		rtkit.enable = true;
		sudo.enable = false; # this makes doas work

		doas = {
			enable = true;
			extraRules = [{
				users = ["sona"];
				keepEnv = true;
				persist = true;
			}];
		};
	};
}
