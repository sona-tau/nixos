_: {
  flake.modules.homeManager.browsers = { pkgs, zen-browser, ... }: {
    config.home.packages = [
      pkgs.librewolf
      pkgs.qutebrowser
      # pkgs.firefoxpwa
      pkgs.ungoogled-chromium
      zen-browser
    ];
  };
}
