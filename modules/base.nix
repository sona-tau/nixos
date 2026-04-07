{ config, ... }: {
	flake.modules.homeManager.base = { pkgs, ... }: {
		imports = with config.flake.modules.homeManager; [
			shell
			zsh
			tmux
			atuin
			direnv
			sh-prompt
			starship
			tealdeer
		];

		home.packages = with pkgs; [
			bat             # le pager
			bc              # calculator
			borgbackup      # backup software
			perkeep         # backup software
			rclone          # copying stuff
			brightnessctl   # brightness manager
			btop            # b top
			htop            # h top
			bunnyfetch      # cute system info display
			busybox         # install helpful terminal utilities
			calcure         # calendar
			coreutils-full  # all the coreutils
			delta           # diff pager for git
			dust            # check for space in disks
			ed              # the best text editor ever made
			eza             # terminal ls
			fd              # better version of find
			ffmpeg          # video editing software
			file            # check the type of a file
			gcc             # everything needs this
			git             # git
			gitlint
			pre-commit
			git-releaser
			git-revise
			gitleaks
			git-extras
			git-annex
			gitui           # Terminal git interface
			git-lfs         # git large file storage
			hostsblock      # block ads at the /etc/hosts
			lsof            # lsof to check outbound connections
			luajitPackages.lua-lsp  # lua-lsp for NeoVim
			mpv             # video playing software
			neovim          # the second best text editor ever made
			nnn             # terminal file manager
			pass            # password manager
			python3         # python
			unzip           # unzip files
			uutils-coreutils-noprefix   # uutils
		];
	};
}
