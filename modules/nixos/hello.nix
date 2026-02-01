{ config, pkgs, lib, ... }: let cfg = config.my.hello; in {
	options.hello.enable = lib.mkEnableOption "hello test (NixOS module)";

	config = {
		environment.etc."hello-nixos-module.txt".text = lib.mkIf cfg.enable ''
			Hello from NixOS - module
		'';
	};
}
