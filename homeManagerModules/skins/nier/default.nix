{ ... }: {
    imports = [
		./apps.nix
        ./sway.nix
        ./browser.nix
        ./foot.nix
        ./alacritty.nix
        ./niri
        ./plymouth.nix
    ];
}
