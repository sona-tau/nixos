{ config, lib, pkgs, ... }:
let cfg = config.applications; in
{
	options.applications = with lib; {
		enable = mkEnableOption "applications";

		audio-player = {
			cmus.enable = mkEnableOption "cmus";
			ncmpcpp.enable = mkEnableOption "ncmpcpp";
			spotify.enable = mkEnableOption "spotify";
		};

		video-player = {
			ffmpeg.enable = mkEnableOption "ffmpeg";
			mpv.enable = mkEnableOption "mpv";
		};

		file-manager = {
			nemo.enable = mkEnableOption "nemo";
			pcmanfm.enable = mkEnableOption "pcmanfm";
                        nnn.enable = mkEnableOption "nnn";
		};

		rss-reader = {
			newsboat.enable = mkEnableOption "newsboat";
		};

		cli = {
			ed.enable = mkEnableOption "ed";
			neovim.enable = mkEnableOption "neovim";
			tmux.enable = mkEnableOption "tmux";
			vim.enable = mkEnableOption "vim";
			zellij.enable = mkEnableOption "zellij";
			skate.enable = mkEnableOption "skate";
			pop.enable = mkEnableOption "pop";
		};

		images = {
			rawtherapee.enable = mkEnableOption "rawtherapee";
			gimp.enable = mkEnableOption "gimp";
                        imv.enable = mkEnableOption "imv";
		};

		obsidian.enable = mkEnableOption "obsidian";
		gpt4all.enable = mkEnableOption "gpt4all";
	};

	config = with lib; lib.mkIf cfg.enable {
		home.packages = with pkgs; [
			(mkIf cfg.audio-player.cmus.enable cmus)
			(mkIf cfg.audio-player.cmus.enable cmusfm)
			(mkIf cfg.audio-player.ncmpcpp.enable ncmpcpp)
			(mkIf cfg.audio-player.spotify.enable spotify)
			(mkIf cfg.audio-player.spotify.enable spotifyd)
			(mkIf cfg.video-player.ffmpeg.enable ffmpeg)
			(mkIf cfg.video-player.mpv.enable mpv)
			(mkIf cfg.file-manager.nemo.enable nemo)
			(mkIf cfg.file-manager.pcmanfm.enable pcmanfm)
                        (mkIf cfg.file-manager.nnn.enable nnn)
			(mkIf cfg.rss-reader.newsboat.enable newsboat)
			(mkIf cfg.cli.ed.enable ed)
			(mkIf cfg.cli.neovim.enable neovim)
			(mkIf cfg.cli.neovim.enable tree-sitter)
                        (mkIf cfg.cli.neovim.enable luarocks)
			(mkIf cfg.cli.tmux.enable tmux)
			(mkIf cfg.cli.vim.enable vim)
			(mkIf cfg.cli.zellij.enable zellij)
			(mkIf cfg.cli.skate.enable skate)
			(mkIf cfg.images.rawtherapee.enable rawtherapee)
			(mkIf cfg.images.gimp.enable gimp)
                        (mkIf cfg.images.imv.enable imv)
			(mkIf cfg.obsidian.enable obsidian)
			(mkIf cfg.cli.pop.enable pop)
			(mkIf cfg.gpt4all.enable gpt4all)
		];
		nixpkgs = {
			config = {
				allowUnfree = true;
				allowUnfreePredicate = (_: true);
			};
		};
	};

}
