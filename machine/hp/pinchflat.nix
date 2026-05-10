{ ... }: {
	services.pinchflat = {
		enable = true;
		port = 8945;
		mediaDir = "/storage/storage/YouTube";
		selfhosted = true;
	};
}
