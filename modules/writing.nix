{ ... }: {
  flake.modules.homeManager.writing = { pkgs, ... }: {
    home.packages = with pkgs; [
      typst # Markdown + LaTex = typst compiler
      pandoc # universal document converter (md → pdf, html, tex, etc.)
      zk # zettelkasten CLI replaces Obsidian dataview queries
      fzf # needed by zk
      libreoffice # thing
    ];
  };
}
