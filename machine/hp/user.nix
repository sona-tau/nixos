{ homeModules, pkgs, ... }: {
  programs.home-manager.enable = true;

  imports = with homeModules; [
    base
    terminal
  ];

  home = {
    username = "sona";
    homeDirectory = "/home/sona";
    stateVersion = "24.11"; # WARNING: DO NOT EVER CHANGE THIS VALUE EVER !

    packages = [ pkgs.chromaprint ];
  };

  programs.zsh.shellAliases.ipfs = "ipfs --api /ip4/127.0.0.1/tcp/5001";

  programs.beets = {
    enable = true;

    settings = {
      include = [ "~/.config/beets/secrets.yaml" ];
      library = "/storage/storage/.beets/library.db";
      directory = "/storage/storage/Music";

      move = true;
      copy = false;

      import = {
        move = true;
        write = true;
        singletons = true;
      };

      match.strong_rec_thresh = 0.49;

      plugins = [
        "fetchart"
        "embedart"
        "lyrics"
        "lastgenre"
        "mbsync"
        "chroma"
        "fromfilename"
        "spotify"
        "deezer"
        "importfeeds"
      ];

      fetchart.auto = true;
      embedart.auto = true;
      lyrics.auto = false;
      lastgenre = {
        auto = true;
        separator = ",";
      };
      chroma.auto = true;

      spotify = {
        data_source_mismatch_penalty = 0.7;
        # client_id and client_secret live in ~/.config/beets/spotify-secrets.yaml
        # which is included below via extraConfig
      };
      importfeeds = {
        formats = "m3u_session";
        dir = "~/playlists";
        m3u_name = "imported_playlist";
        absolute_path = "yes";
      };

      deezer.data_source_mismatch_penalty = 0.7;
    };
  };
}
