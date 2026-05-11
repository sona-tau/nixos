{ ... }: {
	users.groups.media = {};

	users.users = {
		pinchflat.extraGroups = [ "media" ];
		navidrome.extraGroups = [ "media" ];
		sona.extraGroups = [ "media" ];
	};

	systemd.tmpfiles.rules = [
		"d /storage/storage/YouTube 0770 pinchflat media - -"
	];

	services.pinchflat = {
		enable = true;
		port = 8945;
		mediaDir = "/storage/storage/YouTube";
		selfhosted = true;
	};
}
