{ lib, ... }:
{
    imports = [
        ./atuin.nix
        #./email.nix
        ./foot.nix
        ./mako.nix
        ./nushell.nix
        ./tmux.nix
        ./sway.nix
        ./niri.nix
        ./waybar.nix
        ./waypaper.nix
        ./tofi.nix
        ./starship.nix
        ./qutebrowser.nix
        ./pdf.nix
        ./zsh.nix
    ];
}
