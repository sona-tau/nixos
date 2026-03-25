{ config, lib, pkgs, ... }:
let cfg = config.utilities; in
{
    options.utilities = {
        enable = lib.mkEnableOption "utilities";
    };

    config = lib.mkIf cfg.enable {
        programs = {
            ripgrep.enable = true;
            tealdeer.enable = true;
            bottom.enable = true;
            tmux.enable = true;
        };

        home.packages = with pkgs; [
            bc              # calculator
            pandoc          # file converter
            brightnessctl   # brightness manager
            grim slurp      # screenshots
            xh              # http request utility
            gcc             # everything needs this
            btop            # task manager
            borgbackup      # backup software
            calcurse        # calendar
            du-dust         # check for space in disks
            fd              # better version of find
            feh             # image viewer
            fortune         # terminal thing
            glow            # markdown preview
            gum             # terminal forms
            hugo            # website builder
            hut             # source hut thing
            hyperfine       # binary benchmark
            imagemagick     # convert images
            neovide         # gui-nvim
            nnn             # file manager
            pavucontrol     # audio controller
            python3         # python
            unzip           # unzip files
            tealdeer        # tldr
            tree            # see files in a dir
            vhs             # cool terminal gif maker
            uutils-coreutils-noprefix   # uutils
            wishlist        # To ssh into different endpoints
        ];
    };
}
