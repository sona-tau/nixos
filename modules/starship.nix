_: {
  flake.modules.homeManager.starship = { config, lib, ... }: {
    programs.starship = {
      enable = true;
      enableZshIntegration = config.my.shell == "zsh";
      settings = {
        add_newline = true;
        "$schema" = "https://starship.rs/config-schema.json"; # Get editor completions based on the config schema
        format = "$character";
        right_format = "$directory$all";
        username.format = "[$user]($style)";

        hostname = {
          format = "[$ssh_symbol](white)[$hostname]($style)";
          ssh_symbol = "@";
        };

        character = {
          # The name of the module we are configuring is 'character'
          format = "$symbol.";
          success_symbol = "[λ](green)";
          error_symbol = "[λ](red)";
        };
      };
    };
  };
}
