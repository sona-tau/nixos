{ config, lib, pkgs, ... }:
let cfg = config.neovim; in
{
	options.neovim = {
		enable = lib.mkEnableOption "neovim";
	};

	config = lib.mkIf cfg.enable {
		home.packages = with pkgs; [
                luajitPackages.lua-lsp
		];
	};
}
