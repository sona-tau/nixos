{ pkgs, lib, ... }: {
	imports = [ ./hardware.nix ];

	system.stateVersion = "24.11"; # DO NOT CHANGE

	boot.loader.grub.theme = lib.mkForce pkgs.catppuccin-grub;

	networking.hostName = "est";

	services = {
		getty.autologinUser = "sona";

		pipewire = {
			enable = true;
			alsa.enable = true;
			alsa.support32Bit = true;
			pulse.enable = true;
			jack.enable = true;
		};
	};

	hardware = {
		graphics.enable = true;
		graphics.enable32Bit = true;
	};

	programs.steam.enable = true;

	fonts = {
		packages = with pkgs; [
			dejavu_fonts
			hermit
		] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
		enableDefaultPackages = true;
	};
}
