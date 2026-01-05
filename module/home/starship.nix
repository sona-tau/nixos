{ config, lib, ... }: {
	config.programs.starship = {
		enable = true;
		enableZshIntegration = true;

		settings = {
			add_newline = true;
			# Get editor completions based on the config schema
			"$schema" = "https://starship.rs/config-schema.json";
			# Disable the package module, hiding it from the prompt completely
			package.disabled = false;
			right_format = lib.concatStrings [ "[$all](gray)" ];

			format = lib.concatStrings [
				"[ ╭── ](white)[$hostname](blue)@[$directory](purple)[\${custom.time}](yellow)\n"
				"[ ╰ ](white)$character"
			];

			custom."time" = {
				command = "hbc";
				shell = ["bash" "-c"];
			};

			# The name of the module we are configuring is 'character'
			character = {
				success_symbol = "λ[.](green)";
				error_symbol = "λ[.](red)";
			};
		};
	};
}
