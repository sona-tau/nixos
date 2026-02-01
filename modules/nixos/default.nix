{
	my-options = import ./module/nixos/my-options.nix;
	audio = import ./module/nixos/audio.nix;
	base = import ./module/nixos/base.nix;
	cache = import ./module/nixos/cache.nix;
	env = import ./module/nixos/env.nix;
	gpg = import ./module/nixos/gpg.nix;
	i3 = import ./module/nixos/i3.nix;
	iosevka = import ./module/nixos/iosevka.nix;
	keyboard = import ./module/nixos/keyboard.nix;
	locale = import ./module/nixos/locale.nix;
	network = import ./module/nixos/network.nix;
	nix = import ./module/nixos/nix.nix;
	plymouth = import ./module/nixos/plymouth.nix;
	security = import ./module/nixos/security.nix;
	stylix = import ./module/nixos/stylix.nix;
	sway = import ./module/nixos/sway.nix;
	user = import ./module/nixos/user.nix;
}
