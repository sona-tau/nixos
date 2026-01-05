{ ... }: {
	imports = [
		outputs.homeManagerModules.sway
		outputs.homeManagerModules.foot
		outputs.homeManagerModules.alacritty
		outputs.homeManagerModules.niri
		outputs.homeManagerModules.quickshell
		outputs.homeManagerModules.gtk
		# TODO: Have this in configuration itself: ./plymouth.nix
	];
}
