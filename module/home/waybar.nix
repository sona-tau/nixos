{ config, pkgs, lib, ... }:
let
	cfg = config.wayland.waybar;
in {
	config = {
		home.file = {
			".config/waybar/config".source = lib.mkIf cfg.enable ./configs/waybar/config;
			"config/waybar/style.css".source = lib.mkIf cfg.enable ./configs/waybar/style.css;
		};
	};
}
