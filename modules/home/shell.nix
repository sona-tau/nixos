{ config, lib, ... }: let cfg = config.my.shell; in {
	options.my.shell = lib.mkOption {
		default = "zsh";
		type = lib.types.str;
	};
}
