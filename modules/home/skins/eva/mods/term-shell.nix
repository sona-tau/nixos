{ config, lib, pkgs, ... }:
let cfg = config.term-shell; in
{
	options.term-shell = with lib; {
		nushell = {
			enable = mkEnableOption "nushell";
		};

		zsh = {
			enable = mkEnableOption "zsh";
		};
	};

	config = with lib; {
		home.packages = with pkgs; [
			(mkIf cfg.nushell.enable pkgs.uutils-coreutils)
		];

		programs = {
			nushell = lib.mkIf cfg.nushell.enable {
				enable = true;
			};
			atuin = lib.mkIf cfg.zsh.enable {
                            enableZshIntegration = true;
				enable = true;
			};
                        carapace = lib.mkIf cfg.zsh.enable {
                            enable = true;
                            enableZshIntegration = true;
                        };
			starship = lib.mkIf cfg.zsh.enable {
				enableZshIntegration = true;
				enable = true;
			};
			direnv = lib.mkIf cfg.zsh.enable {
				enableZshIntegration = true;
				nix-direnv.enable = true;
				enable = true;
			};

			zsh = lib.mkIf cfg.zsh.enable {
				enable = true;
			};
		};
	};
}
