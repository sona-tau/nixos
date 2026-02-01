{
    config,
    lib,
    ...
}: let cfg = config.eva; in {
    programs.foot = lib.mkIf cfg.enable {
        enable = true;
        server.enable = true;
        settings = {
            main = {
                font = lib.mkForce "Iosevka Elite:size=10";
                pad = "5x5";
            };

            bell = {
                urgent = "no";
                notify = "no";
            };

            scrollback = {
                lines = 10000;
                multiplier = 3.0;
            };
            url = {
                launch = "xdg-open \${url}";
                protocols = "http, https, ftp, ftps, file, gemini, gopher";
            };

            cursor = {
                style = "underline";
                underline-thickness = 1;
            };

            mouse.hide-when-typing = "yes";

            colors.alpha = 0.95;

            key-bindings = {
                spawn-terminal = "none";
                scrollback-up-page = "Shift+Page_Up";
                scrollback-up-half-page = "Control+Shift+Page_Up";
                scrollback-up-line = "Control+Shift+n";
                scrollback-down-page = "Shift+Page_Down";
                scrollback-down-half-page = "Control+Shift+Page_Down";
                scrollback-down-line = "Control+Shift+t";
                clipboard-copy = "Control+Shift+c XF86Copy";
                clipboard-paste = "Control+Shift+v XF86Paste";
                search-start = "Control+Shift+r";
                font-increase = "Control+plus Control+equal Control+KP_Add";
                font-decrease = "Control+minus Control+KP_Subtract";
                font-reset = "Control+0 Control+KP_0";
            };
        };
    };
}
