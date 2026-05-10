{ ... }: {
	home-manager.users.sona = { pkgs, ... }: {
		home.packages = [ pkgs.chromaprint ];

		programs.beets = {
			enable = true;

			settings = {
				library = "/storage/storage/.beets/library.db";
				directory = "/storage/storage";

				move = true;
				copy = false;

				import = {
					move = true;
					write = true;
				};

				plugins = [ "fetchart" "embedart" "lyrics" "lastgenre" "mbsync" "chroma" ];

				fetchart.auto = true;
				embedart.auto = true;
				lyrics.auto = false;
				lastgenre.auto = true;

				chroma.auto = true;
			};
		};
	};
}
