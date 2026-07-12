{ ... }: {
  flake.modules.nixos.metube =
    { config, pkgs, ... }:
    let
      metube = pkgs.callPackage ../packages/metube.nix { };
    in
    {
      users.groups.media = { };
      users.users.sona.extraGroups = [ "media" ];

      systemd.tmpfiles.rules = [
        "d /var/lib/metube 0750 sona media - -"
        "d /var/lib/metube/staging 0770 sona media - -"
      ];

      systemd.services.metube = {
        description = "MeTube yt-dlp web queue";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        environment = {
          DOWNLOAD_DIR = "/var/lib/metube/staging";
          AUDIO_DOWNLOAD_DIR = "/var/lib/metube/staging";
          STATE_DIR = "/var/lib/metube";
          PORT = "8086";
        };

        serviceConfig = {
          User = "sona";
          Group = "media";
          ExecStart = "${metube}/bin/metube";
          WorkingDirectory = "/var/lib/metube";
          Restart = "on-failure";
          UMask = "0002";
        };
      };

      # Every 5 minutes, import any downloaded files into the beets music library.
      # beets moves matched files out of staging into /storage/storage/Music.
      # Unmatched files stay in staging for manual review.
      systemd.timers.metube-beets-import = {
        description = "Periodic beets import of MeTube downloads";
        wantedBy = [ "multi-user.target" ];

        timerConfig = {
          OnBootSec = "5min";
          OnUnitActiveSec = "5min";
        };
      };

      systemd.services.metube-beets-import = {
        description = "Import MeTube downloads into beets music library";

        unitConfig.ConditionDirectoryNotEmpty = "/var/lib/metube/staging";

        serviceConfig = {
          User = "sona";
          Group = "media";
          Type = "oneshot";
          ExecStart = "${pkgs.beets}/bin/beet import -q /var/lib/metube/staging";
        };
      };

      services.caddy.virtualHosts."http://metube.hp".extraConfig = ''
        			reverse_proxy localhost:8086
        		'';
    };
}
