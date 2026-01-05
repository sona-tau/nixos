{ config, pkgs, ... }: {
	config.home.packages = [ pkgs.prismlauncher ];
}
