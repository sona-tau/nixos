{
    config,
    lib,
    ...
}: let cfg = config.eva; in {
    programs.qutebrowser = lib.mkIf cfg.enable {
        enable = true;
        extraConfig = ''
            c.url.default_page = "https://sadparadiseinhell.github.io/tea-green/"
            c.url.start_pages = ['https://baresearch.org']
            '';

        keyBindings = {
            normal = {
                "<Ctrl-v>" = "spawn mpv {url}";
                "t" = "scroll-page 0 0.1";
                "n" = "scroll-page 0 -0.1";
            };
        };

        loadAutoconfig = true;

        searchEngines = {
            DEFAULT = "https://baresearch.org/search?q={}";
            w = "https://en.wikipedia.org/wiki/Special:Search?search={}";
            i = "https://baresearch.org/search?q={}&categories=images";
        };
    };
}
