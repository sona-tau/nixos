{
    config,
    pkgs,
    lib,
    ...
}: {
    home.packages = with pkgs; [
        bc              # calculator
        borgbackup      # backup software
        brightnessctl   # brightness manager
        btop            # task manager
        bunnyfetch      # cute system info display
        calcurse        # calendar
        coreutils-full  # all the coreutils
        du-dust         # check for space in disks
        delta           # diff pager for git
        ed              # the best text editor ever made
        eza             # terminal ls
        fd              # better version of find
        feh             # image viewing software
        ffmpeg          # video editing software
        fortune         # terminal thing
        gcc             # everything needs this
        gimp            # image editing software
        glow            # markdown preview
        gpt4all         # LLM interface
        grim slurp      # screenshots
        gum             # terminal forms
        hugo            # website builder
        hyperfine       # binary benchmark
        imagemagick     # convert images
        imv             # image viewing software
        inkscape        # vector editing software
        jq              # json query language
        luajitPackages.lua-lsp  # lua-lsp for NeoVim
        mpv             # video playing software
        ncmpcpp         # music player
        nemo            # file picker
        # neovide         # gui-nvim
        neovim          # the second best text editor ever made
        newsboat        # RSS news reader
        nnn             # terminal file manager
        obsidian        # for my Wiki
        ollama          # LLM manager
        pandoc          # file converter
        pavucontrol     # audio controller
        python3         # python
        rawtherapee     # image editing software
        ripgrep         # fast grep
        spotify         # music streaming service
        tealdeer        # man but short
        tmux            # terminal multiplexer
        tree            # see files in a dir
        unzip           # unzip files
        uutils-coreutils-noprefix   # uutils
        vhs             # cool terminal gif maker
        vesktop         # discord emulator
        wishlist        # ssh into different endpoints
        xh              # http request utility
        yt-dlp          # terminal YouTube
        zathura         # pdf viewer
    ];
}
