{ config, lib, pkgs, ... }: let cfg = config.my.roles.base; in {
	options = {
		my.roles.base.enable = lib.mkEnableOption "base";
	};

	config = lib.mkIf cfg.enable {
		my.zsh.enable = true;
	};
}
