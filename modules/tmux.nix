{ ... }: {
  flake.modules.homeManager.tmux = { pkgs, ... }: {
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
      terminal = "tmux-direct";
      historyLimit = 10000;
      keyMode = "vi";
      newSession = true;

      extraConfig = ''
        				tmux_conf_24b_colour=true
        				set -g xterm-keys on
        				set -s focus-events on

        				# Windows and panes numbered from 1 (more intuitive)
        				set -g base-index 1
        				set -g pane-base-index 1
        				set-window-option -g pane-base-index 1
        				set-option -g renumber-windows on

        				bind -n C-h copy-mode
        				bind -T copy-mode-vi u send-keys -X scroll-up
        				bind -T copy-mode-vi d send-keys -X scroll-down

        				bind r split-window -h
        				bind d split-window -v

        				bind -n M-Left  select-pane -L
        				bind -n M-Right select-pane -R
        				bind -n M-Up    select-pane -U
        				bind -n M-Down  select-pane -D

        				set -as terminal-overrides ",foot*:Tc"
        			'';

      plugins = with pkgs.tmuxPlugins; [
        sensible
        harpoon
        better-mouse-mode
        {
          plugin = resurrect;
          extraConfig = ''
            						set -g @resurrect-dir '~/.local/share/tmux/resurrect'
            						set -g @resurrect-capture-pane-contents 'on'
            						set -g @resurrect-strategy-nvim 'session'
            						set -g @resurrect-processes 'taskwarrior-tui khal aerc w3m'
            					'';
        }
        {
          plugin = continuum;
          extraConfig = ''
            						set -g @continuum-restore 'on'
            						set -g @continuum-save-interval '15'
            					'';
        }
      ];
    };
  };
}
