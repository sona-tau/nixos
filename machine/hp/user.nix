{ homeModules, pkgs, ... }: {
	programs.home-manager.enable = true;

	imports = with homeModules; [
		base
		terminal
	];

	home = {
		username = "sona";
		homeDirectory = "/home/sona";
		stateVersion = "24.11"; # WARNING: DO NOT EVER CHANGE THIS VALUE EVER !

		packages = [ pkgs.chromaprint ];
	};

	programs.beets = {
		enable = true;

		settings = {
			library = "/storage/storage/.beets/library.db";
			directory = "/storage/storage/Music";

			move = true;
			copy = false;

			import = {
				move = true;
				write = true;
				singletons = true;
			};

			match.strong_rec_thresh = 0.49;

			plugins = [ "fetchart" "embedart" "lyrics" "lastgenre" "mbsync" "chroma" "fromfilename" ];

			fetchart.auto = true;
			embedart.auto = true;
			lyrics.auto = false;
			lastgenre.auto = true;
			chroma.auto = true;
		};
	};
}
