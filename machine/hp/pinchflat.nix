{ ... }: {
	users.groups.media = {};

	users.users = {
		pinchflat.extraGroups = [ "media" ];
		navidrome.extraGroups = [ "media" ];
	};

	systemd.tmpfiles.rules = [
		"d /storage/storage/YouTube 0750 pinchflat media - -"
		"L /storage/storage/Music/YouTube - - - - /storage/storage/YouTube"
	];

	services.pinchflat = {
		enable = true;
		port = 8945;
		mediaDir = "/storage/storage/YouTube";
		selfhosted = true;
	};
}
