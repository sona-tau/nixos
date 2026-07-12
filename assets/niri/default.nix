{ config, lib, ... }:
let
  cfg = config.eva;
in
{
  home.file.".config/niri/config.kdl".source = lib.mkIf cfg.enable ./config.kdl;
}
