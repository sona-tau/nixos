{ ... }: {
  flake.modules.homeManager.zen = { config, pkgs, ... }: {
    home.packages = with pkgs; [
      fortune
      cbonsai
    ];

    home.file."${config.xdg.dataHome}" = {
      source = ../assets/fortune;
      recursive = true;
    };

    programs.zsh.initContent = "fortune ~/.local/share/fortune/zen";
  };
}
