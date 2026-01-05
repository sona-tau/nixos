{ config, pkgs, ... }: {
	config.home.packages = with pkgs; [
		fortune         # fortune teller
		bunnyfetch      # cute system info display
		fastfetch       # terminal fetch utility
		cbonsai         # grow a bonsai
		cmatrix         # go into the matrix
		neo-cowsay      # like a cow, but in Go
	];
}
