{ config, ... }: {
  flake.modules.nixos.wayland = _: {
    services = {
      desktopManager.cosmic.enable = true;
      desktopManager.gnome.enable = true;
      gnome.gnome-software.enable = true;
      gnome.core-apps.enable = true;
    };
  };

  flake.modules.homeManager.wayland = { pkgs, ... }: {
    imports = with config.flake.modules.homeManager; [
      eww
      foot
      gammastep
      niri
      quickshell
      sway
      wallpapers
    ];

    home.packages = with pkgs; [
      cage # kiosk wayland
      discord # Messaging app
      irssi # also a messaging app
      feh # image viewing software
      gimp # image editing software
      grim # screenshots
      slurp # screenshots
      imv # image viewing software
      inkscape # vector editing software
      nemo # file picker
      neovide # gui-nvim
      libnotify # notification daemon
      pavucontrol # audio controller
      rawtherapee # image editing software
      spotify # music streaming service
      syncthing # synchronize files
      pdfpc # really cool PDF presenter
      wl-clipboard # for copy-pasting stuff
    ];
  };
}
