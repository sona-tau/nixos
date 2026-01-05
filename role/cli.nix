{ config, pkgs, ... }: {
	imports = [
		outputs.homeManagerModules.applications
		outputs.homeManagerModules.android
	];

	config = {
		my.applications.enableCliApps = true;
	};
}
