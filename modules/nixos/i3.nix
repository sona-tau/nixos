{ pkgs, ... }:
{
    environment.pathsToLink = [ "/libexec" ];

    services.xserver = {
        enable = true;

        desktopManager.xterm.enable = false;

        displayManager.startx.enable = true;

        windowManager.i3 = {
            enable = true;
            extraPackages = with pkgs; [
                dmenu
                i3status
                i3lock
                i3blocks
            ];
        };
    };
}
