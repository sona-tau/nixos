{ pkgs, lib, ... }: {
  system.stateVersion = "23.11"; # DO NOT CHANGE

  boot = {
    loader.grub.theme = lib.mkForce pkgs.catppuccin-grub;

    plymouth = {
      enable = true;
      theme = "blahaj";
      themePackages = [ pkgs.plymouth-blahaj-theme ];
    };
  };

  networking = {
    hostName = "est";
    extraHosts = "127.0.0.1 localhost.localdomain localhost";
  };

  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;

    fcitx5.addons = with pkgs; [
      fcitx5-anthy
      fcitx5-gtk
      qt6Packages.fcitx5-configtool
    ];
  };

  environment.variables.GLFW_IM_MODULE = "ibus";

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  services = {
    flatpak.enable = true;
    getty.autologinUser = "sona";
    power-profiles-daemon.enable = true;
    upower.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

  hardware = {
    graphics.enable = true;
    graphics.enable32Bit = true;
  };

  programs.steam.enable = true;

  users = {
    groups."plugdev" = { };

    users."sona".extraGroups = [
      "plugdev"
      "adbusers"
      "docker"
    ];
  };

  fonts = {
    packages =
      with pkgs;
      [
        dejavu_fonts
        hermit
      ]
      ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
    enableDefaultPackages = true;
  };

  nix.settings.trusted-users = [ "nixremote" ];
}
