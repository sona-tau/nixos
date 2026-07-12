{ ... }: {
  flake.modules.homeManager.lean = { pkgs, ... }: {
    home.packages = with pkgs; [
      elan # theorem prover
      vscodium # VEE ESS CODE
    ];
  };
}
