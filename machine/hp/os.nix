{
  config,
  pkgs,
  lib,
  ...
}:
let
  catppuccin-gitea = pkgs.callPackage ../../packages/catppuccin-gitea.nix { };
in
{
  system.stateVersion = "25.05"; # DO NOT CHANGE

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    kernelPackages = pkgs.linuxPackagesFor pkgs.linuxKernel.kernels.linux_6_18;
    supportedFilesystems.zfs = true;
    kernelModules = [
      "cdrom"
      "sr_mod"
      "sg"
      "zfs"
    ];
    zfs.forceImportRoot = false;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  networking = {
    hostName = "hp";
    hostId = "924e4a77";

    firewall.trustedInterfaces = [ "tailscale0" ];
  };

  users.users."sona" = {
    packages =
      with pkgs;
      [
        aerc
        aria2
        borgbackup
        curl
        gcc
        git
        neovim
        pass
        yt-dlp
        just
        wget
        nnn
        zellij
        gum
        python3
        onedrive
        gawk
        coreutils-full
        findutils
        jq
        par2cmdline
        gnutar
        xz
        mpv
        libdvdcss
        libdvdread
        libdvdnav
        libbluray
        libbdplus
        libaacs
        libcdr
        libcdio
        libcdaudio
        libcdio-paranoia
        vlc
        sway
        kiwix
        kiwix-tools
        libkiwix
        zim
        zim-tools
        jellyfin
        jellyfin-web
        jellyfin-ffmpeg
        immich
        immich-cli
        smartmontools
        tmux
        spotdl
      ]
      ++ (with pkgs.python313Packages; [
        zlib-ng
        isal
      ]);
  };

  environment.systemPackages = with pkgs; [
    ed
    zfs
  ];

  services = {
    # lidarr.enable = true;    # TODO: not finished
    # sonarr.enable = true;    # TODO: not finished
    # radarr.enable = true;    # TODO: not finished
    # jellyseerr.enable = true; # TODO: not finished
    syncthing = {
      enable = true;
      user = "sona";
      dataDir = "/home/sona/sync";
      configDir = "/home/sona/.config/syncthing";
      openDefaultPorts = true;
    };
    traccar = {
      enable = true;

      settings = {
        # Used in notification links
        "web.url" = "http://traccar.hp";
        # Disable open registration — accounts created by admin only
        "server.registration" = "false";
        # Disable unnecessary map tile proxying
        "web.origin" = "*";
      };
    };
    logrotate.checkConfig = false; # Required by hardened profile

    smartd = {
      enable = true;
      autodetect = true;
      defaults.monitored = "-a -o on -s (S/../.././02|L/../../7/04) -m sona@stau.space -M exec /etc/smartd-ntfy.sh -M test";

      notifications = {
        mail.enable = false;
        wall.enable = false;
        test = true;
      };
    };

    zfs = {
      autoScrub.enable = true;

      autoSnapshot = {
        enable = true;
        flags = "-k -p --utc";
      };
    };

    # qbittorrent — TODO: rarely used, prefer aria2c; re-enable when needed

    radicale = {
      enable = true;

      settings = {
        server.hosts = [
          "0.0.0.0:5232"
          "[::]:5232"
        ];
        storage.filesystem_folder = "/var/lib/radicale/collections";

        auth = {
          type = "htpasswd";
          htpasswd_filename = "/etc/radicale/users";
          htpasswd_encryption = "bcrypt";
        };
      };

      rights = {
        root = {
          user = ".+";
          collection = "";
          permissions = "RWrw";
        };

        principal = {
          user = ".+";
          collection = "{user}";
          permissions = "RWrw";
        };

        calendars = {
          user = ".+";
          collection = "{user}/[^/]+";
          permissions = "RWrw";
        };
      };
    };

    openssh.settings.AcceptEnv = [ "GIT_PROTOCOL" ];

    dnsmasq = {
      enable = true;

      settings = {
        interface = "tailscale0";
        address = "/.hp/100.96.176.98";
        no-resolv = true;
        no-hosts = true;
        server = [
          "100.100.100.100"
          "1.1.1.1"
          "8.8.8.8"
        ];
      };
    };

    caddy = {
      enable = true;

      virtualHosts = {
        "http://git.hp".extraConfig = "reverse_proxy localhost:3000";
        "http://grafana.hp".extraConfig = "reverse_proxy localhost:3001";
        "http://glance.hp".extraConfig = "reverse_proxy localhost:8085";
        "http://readeck.hp".extraConfig = "reverse_proxy localhost:8090";
        "http://ipfs.hp".extraConfig = ''
          					handle /ipfs/* {
          						reverse_proxy localhost:8080 {
          							header_up Host ipfs.hp
          						}
          					}
          					handle /ipns/* {
          						reverse_proxy localhost:8080 {
          							header_up Host ipfs.hp
          						}
          					}
          					reverse_proxy localhost:5001
          				'';
        "http://pinchflat.hp".extraConfig = "reverse_proxy localhost:8945";
        "http://immich.hp".extraConfig = "reverse_proxy localhost:2283";
        "http://jellyfin.hp".extraConfig = "reverse_proxy localhost:8096";
        "http://navidrome.hp".extraConfig = "reverse_proxy localhost:4533";
        "http://traccar.hp".extraConfig = "reverse_proxy localhost:8082";
        "http://radicale.hp".extraConfig = "reverse_proxy localhost:5232";
        "http://syncthing.hp".extraConfig = ''
          					reverse_proxy localhost:8384 {
          						header_up Host localhost
          					}
          				'';
      };
    };

    jellyfin.enable = true;

    navidrome = {
      enable = true;

      settings = {
        MusicFolder = "/storage/storage/Music";
        Port = 4533;
        Address = "127.0.0.1";
      };
    };

    immich = {
      enable = true;
      port = 2283;
      host = "127.0.0.1";
      mediaLocation = "/storage/immich"; # was /var/lib/immich
      machine-learning.enable = true;
    };

    forgejo = {
      enable = true;
      database.type = "postgres";
      lfs.enable = true;

      settings = {
        service.DISABLE_REGISTRATION = false;

        ui = {
          DEFAULT_THEME = "custom";
          THEMES = "catppuccin-latte-rosewater,catppuccin-latte-flamingo,catppuccin-latte-pink,catppuccin-latte-mauve,catppuccin-latte-red,catppuccin-latte-maroon,catppuccin-latte-peach,catppuccin-latte-yellow,catppuccin-latte-green,catppuccin-latte-teal,catppuccin-latte-sky,catppuccin-latte-sapphire,catppuccin-latte-blue,catppuccin-latte-lavender,catppuccin-frappe-rosewater,catppuccin-frappe-flamingo,catppuccin-frappe-pink,catppuccin-frappe-mauve,catppuccin-frappe-red,catppuccin-frappe-maroon,catppuccin-frappe-peach,catppuccin-frappe-yellow,catppuccin-frappe-green,catppuccin-frappe-teal,catppuccin-frappe-sky,catppuccin-frappe-sapphire,catppuccin-frappe-blue,catppuccin-frappe-lavender,catppuccin-macchiato-rosewater,catppuccin-macchiato-flamingo,catppuccin-macchiato-pink,catppuccin-macchiato-mauve,catppuccin-macchiato-red,catppuccin-macchiato-maroon,catppuccin-macchiato-peach,catppuccin-macchiato-yellow,catppuccin-macchiato-green,catppuccin-macchiato-teal,catppuccin-macchiato-sky,catppuccin-macchiato-sapphire,catppuccin-macchiato-blue,catppuccin-macchiato-lavender,catppuccin-mocha-rosewater,catppuccin-mocha-flamingo,catppuccin-mocha-pink,catppuccin-mocha-mauve,catppuccin-mocha-red,catppuccin-mocha-maroon,catppuccin-mocha-peach,catppuccin-mocha-yellow,catppuccin-mocha-green,catppuccin-mocha-teal,catppuccin-mocha-sky,catppuccin-mocha-sapphire,catppuccin-mocha-blue,catppuccin-mocha-lavender";
        };

        server = {
          ROOT_URL = "http://git.hp";
          SSH_PORT = lib.head config.services.openssh.ports;
        };

        actions = {
          ENABLED = true;
          DEFAULT_ACTIONS_URL = "github";
        };
      };
    };
  };

  systemd.services.forgejo-themes = {
    description = "Copy catppuccin-gitea themes into Forgejo public assets";
    wantedBy = [ "forgejo.service" ];
    before = [ "forgejo.service" ];

    serviceConfig.Type = "oneshot";

    script = ''
      			install -d ${config.services.forgejo.stateDir}/public/assets/css
      			cp ${catppuccin-gitea}/*.css ${config.services.forgejo.stateDir}/public/assets/css/
      		'';
  };

  nix = {
    optimise.automatic = true;
    settings.auto-optimise-store = true;

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  /*
    	services.gitea-actions-runner = {
    		package = pkgs.forgejo-runner;

    		instances.hp = {
    			enable    = true;
    			name      = "hp";
    			url       = "http://localhost:3000";
    			tokenFile = config.sops.templates."gitea-runner-token.env".path;
    			labels    = [ "native:host" ];

    			hostPackages = with pkgs; [
    				bash coreutils curl gawk gitMinimal gnused nodejs wget
    				nix
    			];
    		};
    	};
  */

  sops = {
    secrets = {
      "navidrome/lastfm-api-key".sopsFile = ../../secrets/hp.yaml;
      "navidrome/lastfm-secret".sopsFile = ../../secrets/hp.yaml;
      "forgejo/runner-token".sopsFile = ../../secrets/hp.yaml;
    };

    templates."navidrome-lastfm.env" = {
      content = ''
        ND_LASTFM_APIKEY=${config.sops.placeholder."navidrome/lastfm-api-key"}
        ND_LASTFM_SECRET=${config.sops.placeholder."navidrome/lastfm-secret"}
      '';
      owner = "navidrome";
      mode = "0400";
    };

    # root-owned is fine — systemd reads EnvironmentFile as root before DynamicUser switch
    templates."gitea-runner-token.env" = {
      content = "TOKEN=${config.sops.placeholder."forgejo/runner-token"}";
      mode = "0400";
    };
  };

  systemd.services.navidrome.serviceConfig.EnvironmentFile =
    config.sops.templates."navidrome-lastfm.env".path;
}
