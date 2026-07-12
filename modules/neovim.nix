{ ... }: {
  flake.modules.homeManager.neovim = { lib, pkgs, ... }: {
    home.packages = [ pkgs.neovim ];

    # programs.neovim generates its own init.lua and writes it through any
    # symlink at ~/.config/nvim, overwriting the real config. Plain package
    # install avoids this; lazy.nvim handles all plugin management anyway.
    home.activation.nvimConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [[ -d "$HOME/.config/nvim" && ! -L "$HOME/.config/nvim" ]]; then
      				rm -rf "$HOME/.config/nvim"
      			fi
      			ln -sfn /home/sona/nixos/assets/nvim "$HOME/.config/nvim"'';
  };
}
