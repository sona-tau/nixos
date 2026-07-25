_: {
  flake.modules.homeManager.w3m = { pkgs, ... }: {
    home = {
      packages = [
        pkgs.w3m
        pkgs.imv
      ];

      file = {
        # URL handler: YouTube → mpv, everything else → xdg-open (system default browser)
        ".local/bin/w3m-urlhandler" = {
          executable = true;
          text = ''
            #!/bin/sh
            url="$1"
            case "$url" in
            *youtube.com*|*youtu.be*)
                ${pkgs.mpv}/bin/mpv "$url" &
                ;;
            *)
                ${pkgs.xdg-utils}/bin/xdg-open "$url" &
                ;;
            esac
          '';
        };

        # vim-like keybindings
        ".local/share/w3m/keymap".text = ''
          keymap j     NEXT_LINE
          keymap k     PREV_LINE
          keymap J     NEXT_HALF_PAGE
          keymap K     PREV_HALF_PAGE
          keymap C-d   NEXT_HALF_PAGE
          keymap C-u   PREV_HALF_PAGE
          keymap C-f   NEXT_PAGE
          keymap C-b   PREV_PAGE
          keymap g     BEGIN
          keymap G     END
          keymap H     BACK
          keymap o     GOTO
          keymap O     EXTERN_LINK
        '';

        # use the URL handler script as the external browser
        ".local/share/w3m/config".text = ''
          extbrowser ~/.local/bin/w3m-urlhandler %s
        '';

        # open images with imv, video with mpv
        ".mailcap".text = ''
          image/*; ${pkgs.imv}/bin/imv %s
          video/*; ${pkgs.mpv}/bin/mpv %s
        '';
      };
    };
  };
}
