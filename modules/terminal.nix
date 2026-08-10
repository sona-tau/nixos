_: {
  flake.modules.homeManager.terminal = { pkgs, ... }: {
    home.packages = with pkgs; [
      cloc # count lines of code
      framework-tool-tui # TUI for Framework laptop hardware monitoring
      wikiman # unified offline search: man pages, Arch Wiki, Gentoo Wiki
      ddgr # DuckDuckGo in terminal
      glow # markdown preview
      gum # terminal forms
      has # check for presence of terminal utilities
      hyperfine # binary benchmark
      imagemagick # convert images
      jq # json query language
      koji # conventional git commits
      manix # NixOS/home-manager option search
      nchat # WhatsApp/Telegram TUI
      ncmpcpp # music player
      newsboat # RSS news reader
      pandoc # file converter
      ripgrep # fast grep
      taskwarrior-tui # taskwarrior tui
      taskwarrior3 # terminal todo
      tree # see files in a dir
      vhs # cool terminal gif maker
      wishlist # ssh into different endpoints
      xh # http request utility
      yt-dlp # terminal YouTube
      ytfzf # YouTube TUI (browse/play via fzf + mpv)
      lnav # Log file viewer
      croc # Send and receive files in a simple way
      kubo
      radicle-node
      radicle-tui
      nixfmt
      statix
      vulnix
      niv
      nixd
      ssh-to-age
    ];
  };
}
