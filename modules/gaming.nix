_: {
  flake.modules.homeManager.gaming = { pkgs, ... }: {
    programs.lutris.enable = true;
    home.packages = with pkgs; [
      gamescope
      opentabletdriver
    ];
  };
}
