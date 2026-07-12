{ ... }: {
  flake.modules.homeManager.atuin = { config, lib, ... }: {
    config.programs.atuin = {
      enable = true;
      enableZshIntegration = config.my.shell == "zsh";
      settings = {
        auto_sync = true;
        sync_frequency = "5m";
        sync_address = "https://api.atuin.sh";
        search_mode = "prefix";
      };
    };
  };
}
