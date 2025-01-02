{
    config,
    ...
}: {
    imports = [
        ./stylix
    ];

    config = {
        nix.settings.experimental-features = ["nix-command" "flakes"];
        programs = {
            nix-ld.enable = true;
        };
    };
}
