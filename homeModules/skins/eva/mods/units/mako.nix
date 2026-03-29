{ config, lib, hostname, ... }:
{
	services.mako = {
		# backgroundColor = "#080808F8";
		# borderColor = "#eeeeeeFF";
		borderRadius = 5;
		borderSize = 1;
		font = lib.mkForce "Iosevka Elite";
		ignoreTimeout = true;
		extraConfig = "on-notify=exec mpv ~/Media/sound.opus";
	};
}
