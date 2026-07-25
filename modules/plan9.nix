_: {

  flake.modules.homeManager.plan9 = { pkgs, ... }: {
    programs.zsh.envExtra = ''
      			export PATH="$PATH:${pkgs.plan9port}/plan9/bin"
      		'';
  };
  flake.modules.nixos.plan9 = { pkgs, ... }: {
    services = {
      xserver = {
        enable = true;

        videoDrivers = [ "modesetting" ];

        displayManager = {
          startx = {
            enable = true;
            generateScript = true;
            extraCommands =
              let
                myXresources = pkgs.writeText "Xresources" ''
                  								Xft.dpi: 201
                  								
                  							'';
              in
              ''
                							${pkgs.xrdb}/bin/xrdb -merge ${myXresources}
                							${pkgs.feh}/bin/feh --bg-scale /home/sona/nixos/assets/bg.jpg &
                							9 fontsrv &
                							9 plumber &
                							emacs --daemon &
                							protonmail-bridge &

                							export font="/mnt/font/Mno16/24a/font"
                							exec 9 rio -term alacritty -virtuals 4
                						'';
          };

          importedVariables = [
            "GDK_SCALE"
            "GDK_DPI_SCALE"
            "QT_AUTO_SCREEN_SCALE_FACTOR"
          ];
        };

      };
      # disable touch pad and mouse acceleration
      libinput = {
        enable = true;
        mouse.accelProfile = "flat";
        touchpad = {
          naturalScrolling = true;
          accelProfile = "flat";
          middleEmulation = true;
        };
      };
    };

    # bigger tty fonts
    console.font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";

    environment = {
      systemPackages = with pkgs; [
        rc
        drawterm
        xrdb
        ad
        plan9port
      ];

      variables = {
        ## Used by GTK 3
        # `GDK_SCALE` is limited to integer values
        GDK_SCALE = "2";
        # Inverse of GDK_SCALE
        GDK_DPI_SCALE = "0.5";

        # Used by Qt 5
        QT_AUTO_SCREEN_SCALE_FACTOR = "1";

        _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
      };
    };
  };
}
