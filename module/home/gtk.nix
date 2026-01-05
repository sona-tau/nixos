{ config, lib, pkgs, ... }:
let
	catppuccin_name = "catppuccin-mocha-mauve-standard";
	catppuccin = pkgs.catppuccin-gtk.override {
		variant = "mocha";
		accents = [ "mauve" ];
	};
in {
	config.gtk = {
		enable = true;

		theme = {
			name = lib.mkForce catppuccin_name;
			package = lib.mkForce catppuccin;
		};
	};
}
