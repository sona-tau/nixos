{ homeModules, ... }: {
  programs.home-manager.enable = true;

  imports = with homeModules; [
    alacritty
    base
    browsers
    emacs
    fun
    gaming
    gtk
    icons
    mako
    mako
    minecraft
    neovim
    noctalia
    plan9
    stylix
    terminal
    w3m
    wallpapers
    wayland
    webdev
    writing
    zathura
    zen
  ];

  my.stylix = {
    theme = "oxocarbon-dark";
    # wallpaper = ../../assets/media/full/wall2.png;
  };

  home = {
    username = "sona";
    homeDirectory = "/home/sona";
    stateVersion = "23.11"; # WARNING: DO NOT EVER CHANGE THIS VALUE EVER !
  };
}
