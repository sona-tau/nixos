{ config, lib, hostname, ... }:
{
	programs.zathura.options = lib.mkForce {
            selection-clipboard = "clipboard";
            notification-error-bg = "rgba(40,40,40,1)";	# bg
            notification-error-fg = "rgba(251,73,52,1)";	# bright:red
            notification-warning-bg = "rgba(40,40,40,1)";	# bg
            notification-warning-fg = "rgba(250,189,47,1)";	# bright:yellow
            notification-bg = "rgba(40,40,40,1)";	# bg
            notification-fg = "rgba(184,187,38,1)";	# bright:green

            completion-bg = lib.mkForce "rgba(80,73,69,1)";	# bg2
            completion-fg = lib.mkForce "rgba(235,219,178,1)";	# fg
            completion-group-bg = lib.mkForce "rgba(60,56,54,1)";	# bg1
            completion-group-fg = lib.mkForce "rgba(146,131,116,1)";	# gray
            completion-highlight-bg = lib.mkForce "rgba(131,165,152,1)";	# bright:blue
            completion-highlight-fg = lib.mkForce "rgba(80,73,69,1)";	# bg2

            # Define the color in index mode
            index-bg = "rgba(80,73,69,1)";	# bg2
            index-fg = "rgba(235,219,178,1)";	# fg
            index-active-bg = "rgba(131,165,152,1)";	# bright:blue
            index-active-fg = "rgba(80,73,69,1)";	# bg2

            inputbar-bg = lib.mkForce "rgba(40,40,40,1)";	# bg
            inputbar-fg = lib.mkForce "rgba(235,219,178,1)";	# fg

            statusbar-bg = "rgba(80,73,69,1)";	# bg2
            statusbar-fg = "rgba(235,219,178,1)";	# fg

            highlight-color = lib.mkForce "rgba(250,189,47,0.5)";	# bright:yellow
            highlight-active-color = lib.mkForce "rgba(254,128,25,0.5)";	# bright:orange

            default-bg = lib.mkForce "rgba(40,40,40,1)";	# bg
            default-fg = lib.mkForce "rgba(235,219,178,1)";	# fg
            render-loading = true;
            render-loading-bg = "rgba(40,40,40,1)";	# bg
            render-loading-fg = "rgba(235,219,178,1)";	# fg

            # Recolor book content's color
            recolor-lightcolor = "rgba(40,40,40,1)";	# bg
            recolor-darkcolor = "rgba(235,219,178,1)";	# fg
            recolor = true;
            recolor-keephue = true;	# keep original color
        };
}

