{
    config,
    pkgs,
    lib,
    ...
}: let cfg = config.eva; in {
    home.packages = with pkgs; lib.mkIf cfg.enable [
        obsidian
        gpt4all
        ncmpcpp
        spotify
        ffmpeg
        mpv
        nnn
        nemo
        newsboat
        ed
        tmux
        neovim
        rawtherapee
        gimp
        imv
    ];
}
