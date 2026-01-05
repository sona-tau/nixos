{ config, pkgs, ... }: {
	config.home.packages = with pkgs; [
		elan            # theorem prover (has to be installed globally for lean)
		vscodium        # VEE ESS CODE
	];
}
