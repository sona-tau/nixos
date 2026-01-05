{ pkgs, ... }: {
	imports = [
		outputs.nixosModules.base
		outputs.nixosModules.network
		outputs.nixosModules.locale
		outputs.nixosModules.user
		outputs.nixosModules.nix
		outputs.nixosModules.base
		outputs.nixosModules.gpg
		outputs.nixosModules.security
		outputs.nixosModules.cache
	];
}
