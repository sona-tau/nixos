{ ... }: {
	flake.modules.homeManager.tmux = { config, pkgs, lib, ... }: let cfg = config.my.tmux; in {
		options = {
			my.tmux.enable = lib.mkEnableOption "tmux";
		};

		config = lib.mkIf cfg.enable {
			programs.fzf.tmux.enableShellIntegration = true;

			programs.tmux = {
				enable = true;
				aggressiveResize = true;
				customPaneNavigationAndResize = true;
				clock24 = true;
				escapeTime = 0;
				prefix = "C-p";
				sensibleOnTop = true;
				shortcut = "a";
				terminal = "tmux-256color";
				historyLimit = 10000;
				keyMode = "vi";
				newSession = true;

				extraConfig =''
					tmux_conf_24b_colour=true
					set -g xterm-keys on
					set -s focus-events on

					bind -n C-h copy-mode
					bind -T copy-mode-vi u send-keys -X scroll-up
					bind -T copy-mode-vi d send-keys -X scroll-up

					bind r split-window -h
					bind d split-window -v

					bind -n M-Left  select-pane -L
					bind -n M-Right select-pane -R
					bind -n M-Up	select-pane -U
					bind -n M-Down  select-pane -D

					set -as terminal-overrides ",foot*:Tc"
					'';

				plugins = with pkgs.tmuxPlugins; [
					sensible
					resurrect
					continuum
					harpoon
					better-mouse-mode
				];
			};
		};
	};
}
