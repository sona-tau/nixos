{ config, pkgs, ... }: let cfg = config.my.hello; in {
	options.my.hello.enable = lib.mkEnableOption "hello test (HomeManager module)";

	config = {
		home.file."hello-home-module.txt".text = lib.mkIf cfg.enable ''
			Hello from home-manager - module
		'';
	};
}
