{ ... }: {
	flake.modules.homeManager.starship = { config, lib, ... }: let cfg = config.my.starship; in {
		options.my.starship.enable = lib.mkEnableOption "starship";

		config = lib.mkIf cfg.enable {
			programs.starship = {
				enable = true;
				enableZshIntegration = config.my.shell == "zsh";
				settings = {
					add_newline = true;
					"$schema" = "https://starship.rs/config-schema.json"; # Get editor completions based on the config schema
					package.disabled = false; # Disable the package module, hiding it from the prompt completely

					format = lib.concatStrings [
						"(white)$directory\n"
						"(white)$character"
					];

					character = { # The name of the module we are configuring is 'character'
						success_symbol = "[λ](green)";
						error_symbol = "[λ](red)";
					};
				};
			};
		};
	};
}
