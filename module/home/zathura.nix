{ config, ... }: {
	config.programs.zathura = {
		enable = true;
		selection-clipboard = "clipboard";
		recolor = true;
		recolor-keephue = false; # keep original color
	};
}
