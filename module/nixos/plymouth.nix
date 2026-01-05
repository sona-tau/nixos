{ config, ... }: {
	config.boot = {
		plymouth = {
			enable = true;
			theme = "blahaj";
			themePackages = [ pkgs.plymouth-blahaj-theme ];
		};

		loader = {
			efi = {
				canTouchEfiVariables = true;
				efiSysMountPoint = "/boot";
			};

			grub = lib.mkForce {
				enable = true;
				device = "nodev";
				configurationLimit = 4;
				efiSupport = true;
				theme = pkgs.catppuccin-grub;
			};
		};
	};
}
