{ config, ... }: {
	config.programs.tealdeer = {
		enable = true;
		settings.updates.auto_update = true;
	};
}
