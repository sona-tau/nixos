{ config, ... }: {
	imports = [
		outputs.homeManagerModules.applications
		outputs.homeManagerModules.ime
		outputs.homeManagerModules.fonts
		outputs.homeManagerModules.quickshell
		outputs.homeManagerModules.zen-browser
		outputs.homeManagerModules.firefox
		outputs.nixosModules.audio
		outputs.nixosModules.keyboard
	];
}
