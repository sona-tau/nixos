{
    lib,
    ...
}: {
    imports = [
    ];

    options.rice = {
        # eva.enable = lib.mkEnableOption "Enable the Evangelion rice.";
        nier.enable = lib.mkEnableOption "Enable the Nier rice.";
    };
}
