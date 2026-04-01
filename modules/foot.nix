{ ... }: {
	flake.modules.homeManager.foot = { config, pkgs, lib, ... }: let cfg = config.my.foot; in {
		options = {
			my.foot.enable = lib.mkEnableOption "foot";
		};

		config = lib.mkIf cfg.enable {
			programs.foot = {
				enable = true;
				server.enable = true;

				settings = {
					main = {
						pad = "10x10";
						theme = "moonfly";
					};

					bell = {
						urgent = "no";
						notify = "no";
					};

					scrollback = {
						lines = 100000;
						multiplier = 3.0;
					};

					cursor = {
						style = "underline";
						underline-thickness = 1;
					};

					mouse.hide-when-typing = "yes";

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
		};
	};
}
