{ config, pkgs, ... }: {
    imports = [
        ../../homeManagerModules
    ];
    home.username = "diego";
    home.homeDirectory = "/home/diego";
    home.stateVersion = "23.11"; # WARNING: DO NOT EVER CHANGE THIS VALUE EVER !
    rice.nier.enable = true;
    programs.home-manager.enable = true;
}
