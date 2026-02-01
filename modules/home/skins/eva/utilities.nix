{
    config,
    pkgs,
    lib,
    ...
}: let cfg = config.eva; in {
    home.packages = with pkgs; lib.mkIf cfg.enable [
        bc              # calculator
        borgbackup      # backup software
        brightnessctl   # brightness manager
        btop            # task manager
        calcurse        # calendar
        du-dust         # check for space in disks
        fd              # better version of find
        feh             # image viewer
        fortune         # terminal thing
        gcc             # everything needs this
        glow            # markdown preview
        grim slurp      # screenshots
        gum             # terminal forms
        hugo            # website builder
        hut             # source hut thing
        hyperfine       # binary benchmark
        imagemagick     # convert images
        luajitPackages.lua-lsp  # lua-lsp for NeoVim
        mpv             # terminal videos
        neovide         # gui-nvim
        nnn             # file manager
        pandoc          # file converter
        pavucontrol     # audio controller
        python3         # python
        ripgrep         # fast grep
        tealdeer        # man but short
        tealdeer        # tldr
        tree            # see files in a dir
        unzip           # unzip files
        uutils-coreutils-noprefix   # uutils
        vhs             # cool terminal gif maker
        wishlist        # ssh into different endpoints
        xh              # http request utility
        yt-dlp          # terminal YouTube
    ];

    programs.tealdeer = lib.mkIf cfg.enable {
        auto_update = true;
    };
}
