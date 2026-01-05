{ config, lib, pkgs, ... }: {
	config.services.systemPackages = [ inputs.quickshell.packages."${system}".default ];
	# config.home.packages = [ pkgs.quickshell ];
}
