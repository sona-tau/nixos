{
    config,
    ...
}: {
    imports = [
        # ./stylix
        # ./i3.nix
    ];

    config = {
        nix.settings.experimental-features = ["nix-command" "flakes"];
        programs = {
            nix-ld.enable = true;
			steam.enable = true;
        };
    };
}
