{ config, pkgs, lib, ... }:
let cfg = config.starship; in
{
    programs.starship.settings = {
        add_newline = false;
        format = lib.concatStrings [
            "[ ╭── ](white)[$directory](purple)[\${custom.time}](yellow)\n"
            "[ ╰ ](white)$character"
        ];
	custom = {
		time = {
			command = "hbc";
			shell = ["bash" "-c"];
		};
	};

# Get editor completions based on the config schema
        "$schema" = "https://starship.rs/config-schema.json";

        character = { # The name of the module we are configuring is 'character'
            success_symbol = "λ[.](green)";
            error_symbol = "λ[.](red)";
        };

# Disable the package module, hiding it from the prompt completely
        package.disabled = false;
    };
}
