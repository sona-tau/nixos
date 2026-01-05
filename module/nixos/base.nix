{ config, ... }: {
	config = {
		nix.settings.experimental-features = ["nix-command" "flakes"];

		programs = {
			nix-ld.enable = true;
			home-manager.enable = true;
		};

		options.nixpkgs.config = {
			allowUnfree = true;
			allowUnfreePredicate = (_: true);
		};

		environment.systemPackages = with pkgs; [
			bc              # calculator
			btop            # task manager
			busybox         # install helpful terminal utilities
			coreutils-full  # all the coreutils
			file            # shows file info
			dust            # check for space in disks
			ed              # the best text editor ever made
			eza             # terminal ls
			fd              # better version of find
			ffmpeg          # video editing software
			gcc             # everything needs this
			clang           # second C compiler
			imagemagick     # convert images
			lsof            # lsof to check outbound connections
			neovim          # the second best text editor ever made
			nnn             # terminal file manager
			python3         # python
			ripgrep         # fast grep
			tealdeer        # man but short
			tmux            # terminal multiplexer
		];
	};
}
