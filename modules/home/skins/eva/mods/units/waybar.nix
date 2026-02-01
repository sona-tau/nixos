{ config, pkgs, lib, ... }:
let cfg = config.wayland.waybar; in
{
	home.file.".config/waybar/config" = lib.mkIf cfg.enable {
		source = ./dots/waybar/config;
	};
	home.file.".config/waybar/style.css" = lib.mkIf cfg.enable {
		source = ./dots/waybar/style.css;
	};
}
