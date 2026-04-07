{ ... }: {
	flake.modules.nixos.base = {
		nix.settings.experimental-features = [ "nix-command" "flakes" ];

		programs = {
			nix-ld.enable = true;

			appimage = {
				enable = true;
				binfmt = true;
			};
		};
	};
}
