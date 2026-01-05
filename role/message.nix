{ config, pkgs, lib, ... }: {
	imports = [
		outputs.homeManagerModules.email
	];

	config.home.packages = with pkgs; [
		signal
		signald
		matrix
		irssi
		element-desktop
	];
}
