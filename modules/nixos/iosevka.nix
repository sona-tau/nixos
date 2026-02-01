{ config, lib, pkgs, ... }:
let
  cfg = config.fonts.iosevka;
  settingsFormat = pkgs.formats.yaml { };
  settingsFile = settingsFormat.generate "private-build-plans.yaml" cfg.settings;
in
{
  options.fonts.iosevka = {
    enable = mkEnableOption (lib.mdDoc "the Starship shell prompt");

    settings = mkOption {
      inherit (settingsFormat) type;
      default = { };
      description = lib.mdDoc ''
        Configuration included in `starship.toml`.

        See https://starship.rs/config/#prompt for documentation.
      '';
    };
  };

  /*
  config = mkIf cfg.enable {
    programs.bash.${initOption} = ''
      if [[ $TERM != "dumb" ]]; then
        export STARSHIP_CONFIG=${settingsFile}
        eval "$(${pkgs.starship}/bin/starship init bash)"
      fi
    '';

    programs.fish.${initOption} = ''
      if test "$TERM" != "dumb"
        set -x STARSHIP_CONFIG ${settingsFile}
        eval (${pkgs.starship}/bin/starship init fish)
      end
    '';

    programs.zsh.${initOption} = ''
      if [[ $TERM != "dumb" ]]; then
        export STARSHIP_CONFIG=${settingsFile}
        eval "$(${pkgs.starship}/bin/starship init zsh)"
      fi
    '';
  };
  */
}
