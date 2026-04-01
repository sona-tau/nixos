{ /* pkgs, */ ... }: {
	flake.modules.nixos.base = {
		nix.settings.experimental-features = [
			"nix-command"
			"flakes"
		];

		programs = {
			nix-ld.enable = true;
			steam.enable = true;
			appimage = {
				enable = true;
				binfmt = true;
				/*
				package = pkgs.appimage-run.override {
					extraPackages = pkgs: [
						pkgs.icu
						pkgs.libxcrypt-legacy
						pkgs.python312
						pkgs.python312Packages.torch
					];
				};
				*/
			};
		};
	};
}
