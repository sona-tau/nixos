{ config, lib, hostname, ... }:
{
	programs.tealdeer.settings.updates = {
		auto_update = true;
	};
}
