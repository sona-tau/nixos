_: {
  flake.modules.homeManager.tealdeer = _: {
    programs.tealdeer = {
      enable = true;
      settings.updates.auto_update = true;
    };
  };
}
