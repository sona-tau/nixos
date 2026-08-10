_: {
  flake.modules.homeManager.emacs =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      home.packages = with pkgs; [
        symbola # used for fonts emacs can't render
        emacs-pgtk
        mu # for email stuff
        isync # for email stuff
        protonmail-bridge
        texliveSmall
        cmake # vterm compilation
        gnumake # vterm compilation
      ];

      xdg.configFile."doom".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/assets/emacs/doom";

      home.file.".mbsyncrc".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/assets/emacs/mbsyncrc";

      systemd.user.services.mbsync = {
        Unit = {
          Description = "Sync mail via mbsync";
          After = [ "network.target" ];
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${pkgs.isync}/bin/mbsync -a";
          Environment = [
            "PATH=${
              lib.makeBinPath [
                pkgs.pass
                pkgs.gnupg
              ]
            }"
          ];
        };
      };

      systemd.user.timers.mbsync = {
        Unit.Description = "Periodic mbsync mail fetch";
        Timer = {
          OnCalendar = "*:0/5";
          Persistent = true;
        };
        Install.WantedBy = [ "timers.target" ];
      };
    };
}
