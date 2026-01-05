{ config, ... }:
let
	cfg = config.foot;
in {
	options.foot = with lib; {
		colorscheme = mkOption {
			example = "oxocarbon";
			default = null;

			description = ''
				The colorscheme for foot. If not set, will default to an empty attr set.
			'';

			type = types.nullOr (types.enum [ "zenburn" "oxocarbon" ]);
		);
	};

	config.programs.foot = {
		enable = true;
		server.enable = true;

		settings = {
			main.pad = "5x5";
			mouse.hide-when-typing = "yes";
			colors.alpha = 0.95;

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

			colors = lib.mkIf (cfg.colorscheme != null) (if cfg.colorscheme == "zenburn" then {
				alpha = 0.97;
				foreground = "dcdccc";
				background = "14161b";

				# Normal/regular colors (color palette 0-7)
				regular0 = "222222"; # black
				regular1 = "cc9393"; # red
				regular2 = "7f9f7f"; # green
				regular3 = "d0bf8f"; # yellow
				regular4 = "6ca0a3"; # blue
				regular5 = "dc8cc3"; # magenta
				regular6 = "93e0e3"; # cyan
				regular7 = "dcdccc"; # white

				# Bright colors (color palette 8-15)
				bright0 = "666666";  # bright black
				bright1 = "dca3a3";  # bright red
				bright2 = "bfebbf";  # bright green
				bright3 = "f0dfaf";  # bright yellow
				bright4 = "8cd0d3";  # bright blue
				bright5 = "fcace3";  # bright magenta
				bright6 = "b3ffff";  # bright cyan
				bright7 = "ffffff";  # bright white
			} else if cfg.colorscheme == "oxocarbon" then {
				alpha = 0.97;
				background = "161616";
				foreground = "ffffff";

				selection-foreground = "161616";
				selection-background = "ee5396";

				# Normal/regular colors (color palette 0-7)
				regular0 = "262626"; # black
				regular1 = "ff7eb6"; # red
				regular2 = "42be65"; # green
				regular3 = "ffe97b"; # yellow
				regular4 = "33b1ff"; # blue
				regular5 = "ee5396"; # magenta
				regular6 = "3ddbd9"; # cyan
				regular7 = "dde1e6"; # white

				# Bright colors (color palette 8-15)
				bright0 = "393939";  # bright black
				bright1 = "ff7eb6";  # bright red
				bright2 = "42be65";  # bright green
				bright3 = "ffe97b";  # bright yellow
				bright4 = "33b1ff";  # bright blue
				bright5 = "ee5396";  # bright magenta
				bright6 = "3ddbd9";  # bright cyan
				bright7 = "ffffff";  # bright white
			} else {});
		};
	};
}
