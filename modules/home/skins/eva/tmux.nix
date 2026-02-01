{
    config,
    pkgs,
    lib,
    ...
}: let cfg = config.eva; in {
    programs.fzf.tmux = lib.mkIf cfg.enable {
        enableShellIntegration = true;
    };
    programs.tmux = lib.mkIf cfg.enable {
        clock24 = true;
        customPaneNavigationAndResize = true;
        disableConfirmationPrompt = true;
        escapeTime = 10;
        extraConfig =''
tmux_conf_24b_colour=true
set -g xterm-keys on
set -s focus-events on

#set -g prefix2 C-a
#bind C-a send-prefix -2

unbind n
unbind p

unbind C-a
set -g prefix C-p

bind -n C-h copy-mode
bind -T copy-mode-vi n send-keys -X scroll-up
bind -T copy-mode-vi t send-keys -X scroll-up
bind -T copy-mode-vi u send-keys -X scroll-up
bind -T copy-mode-vi d send-keys -X scroll-up

bind r split-window -h
bind d split-window -v

bind -n M-Left  select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up    select-pane -U
bind -n M-Down  select-pane -D
bind -n M-h     select-pane -L
bind -n M-s     select-pane -R
bind -n M-n     select-pane -U
bind -n M-t     select-pane -D

bind s copy-mode\; send-key ?

set -g default-terminal "$\{TERM}"
set -as terminal-overrides ",foot*:Tc"

set -g @treemux-tree 'e'

set -g @treemux-tree-nvim-init-file '~/.config/tmux/plugins/treemux/configs/treemux_init.lua'
set -g @plugin 'kiyoon/treemux'
            '';
        historyLimit = 10000;
        keyMode = "vi";
        mouse = true;
        newSession = true;
        plugins = with pkgs; [
            tmuxPlugins.sensible
                tmuxPlugins.resurrect
                tmuxPlugins.continuum
        ];
        prefix = "C-p";
        sensibleOnTop = true;
#shell = "${pkgs.nushell}/bin/nu";
        shortcut = "a";
    };
}

