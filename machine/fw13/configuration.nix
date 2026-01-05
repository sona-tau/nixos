{ outputs, ... }: rec {
	networking.hostname = "fw13";
	time.timeZone = "America/Puerto_Rico";
	system.stateVersion = "23.11"; # DO NOT CHANGE

	imports = [
		./description.nix # This used to be hardware-configuration.nix
		outputs.roles.base
		outputs.roles.backup
		outputs.roles.cli
		outputs.roles.desktop
		outputs.roles.email
		outputs.roles.aesthetic-kanagawa
		outputs.roles.fun
		outputs.roles.lean
		outputs.roles.gaming
	];

	my.plymouth.theme = "blahaj";
}
