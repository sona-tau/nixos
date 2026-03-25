{ lib, ... }:
{
	imports = [
		./notifications.nix
		./pdf.nix
		./terminal.nix
		./term-shell.nix
		./units
		./wayland.nix
		./utilities.nix
		./browse.nix
		./fonts.nix
		./applications.nix
		./messaging.nix
		./nvim.nix
	];
}
