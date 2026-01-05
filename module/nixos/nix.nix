{ config, ... }: {
	config = {
		services.systemPackages = [ pkgs.home-manager ];

		nixpkgs.config = {
			allowUnfree = true;
			allowUnsupportedSystem = true;
		};

		nix = {
			package = pkgs.nixVersions.stable;

			extraOptions = ''
				experimental-features = nix-command flakes
				warn-dirty = false
			'';

			settings.experimental-features = [
				"nix-command"
				"flakes"
			];
		};
	};
}
