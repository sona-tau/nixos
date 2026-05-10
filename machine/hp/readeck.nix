{ ... }: {
	services.readeck = {
		enable = true;

		settings.server = {
			host = "127.0.0.1";
			port = 8090;
		};
	};
}
