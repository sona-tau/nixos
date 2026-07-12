{ ... }: {
  flake.modules.homeManager.niri = { config, pkgs, ... }: {
    home = {
      file.".config/niri/config.kdl".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/assets/niri/config.kdl";
      packages = [ pkgs.libgbm ];
    };
  };
  flake.modules.nixos.niri = { ... }: { programs.niri.enable = true; };
}
