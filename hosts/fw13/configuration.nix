{ config,
  pkgs,
  lib,
  inputs,
  outputs,
  system,
  myLib,
  stylix,
  ...
}: {
    imports = [
        ./hardware-configuration.nix
        ../../nixosModules
    ];
    boot = {
        plymouth = {
            enable = true;
            theme = "blahaj";
            themePackages = [ pkgs.plymouth-blahaj-theme ];
        };
        loader = {
            efi = {
                canTouchEfiVariables = true;
                efiSysMountPoint = "/boot";
            };
            grub = lib.mkForce {
                enable = true;
                device = "nodev";
                configurationLimit = 4;
                efiSupport = true;
                theme = let
                    yorha = pkgs.fetchFromGitHub {
                        owner = "OliveThePuffin";
                        repo = "yorha-grub-theme";
                        rev = "4d9cd37baf56c4f5510cc4ff61be278f11077c81";
                        sha256 = "sha256-XVzYDwJM7Q9DvdF4ZOqayjiYpasUeMhAWWcXtnhJ0WQ=";
                    };
                in "${yorha}/yorha-2256x1504";
            };
        };
    };

    networking = {
        extraHosts = ''
            127.0.0.1 localhost.localdomain localhost
        '';
        hostName = "est";
        networkmanager.enable = true;
        firewall.enable = true;
    };

    time.timeZone = "America/Puerto_Rico";

    i18n = {
        defaultLocale = "en_US.UTF-8";

        extraLocaleSettings = {
            LC_ADDRESS = "es_PR.UTF-8";
            LC_IDENTIFICATION = "es_PR.UTF-8";
            LC_MEASUREMENT = "es_PR.UTF-8";
            LC_MONETARY = "es_PR.UTF-8";
            LC_NAME = "es_PR.UTF-8";
            LC_NUMERIC = "es_PR.UTF-8";
            LC_PAPER = "es_PR.UTF-8";
            LC_TELEPHONE = "es_PR.UTF-8";
            LC_TIME = "es_PR.UTF-8";
        };
# IME
        inputMethod = {
            type = "fcitx5";
            enable = true;

            fcitx5.addons = with pkgs; [
                fcitx5-anthy
                fcitx5-gtk
                fcitx5-configtool
            ];

            ibus.engines = [ pkgs.ibus-engines.anthy ];
        };
    };

    services = {
        xserver = {
            xkb = {
                layout = "us";
                variant = "dvorak";
            };
        };

        getty.autologinUser = "diego";
        openssh.enable = true;
        pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
        };
    };

    console.keyMap = "dvorak";

    users = {
        groups."plugdev" = {};
        users.diego = {
            isNormalUser = true;
            description = "diego";
            extraGroups = [
                "networkmanager"
                "wheel"
                "plugdev"
                "adbusers"
                "docker"
            ];
            packages = with pkgs; [
                home-manager
                neovim
                helix
                zsh
            ];
            shell = pkgs.zsh;
        };
    };

    nixpkgs.config = {
        allowUnfree = true;
        allowUnsupportedSystem = true;
    };

    environment = {
        variables.GLFW_IM_MODULE = "ibus";
        sessionVariables = rec {
            XDG_CACHE_HOME  = "$HOME/.cache";
            XDG_CONFIG_HOME = "$HOME/.config";
            XDG_DATA_HOME   = "$HOME/.local/share";
            XDG_STATE_HOME  = "$HOME/.local/state";

            # Not officially in the specification
            XDG_BIN_HOME    = "$HOME/.local/bin";
            PATH = [ 
                "${XDG_BIN_HOME}"
            ];
        };

        systemPackages = let
            system = "x86_64-linux";
        in [
            pkgs.home-manager
            pkgs.rsync
            pkgs.borgbackup
            pkgs.onedrive
            pkgs.wget
            pkgs.doas
            pkgs.ed
            pkgs.curl
            pkgs.pass
            pkgs.git
            pkgs.qemu
            inputs.zen-browser.packages."${system}".default
            inputs.zen-browser.packages."${system}".specific
            inputs.zen-browser.packages."${system}".generic
        ];
    };

# Fonts
    fonts = {
        packages = with pkgs; [
            cozette
            scientifica
            ipafont
            dejavu_fonts
            ipaexfont
            nasin-nanpa
            linja-pi-pu-lukin
            ibm-plex
			ocr-a
			apl386
			bqn386
        ];
        enableDefaultPackages = true;
    };



    programs = {
        adb.enable = true;
        zsh.enable = true;
        gnupg.agent = {
            enable = true;
            enableSSHSupport = true;
        };
    };

    system.stateVersion = "23.11"; # DO NOT CHANGE

    security = {
        sudo.enable = false;
        polkit.enable = true;
        rtkit.enable = true;
        doas = {
            enable = true;
            extraRules = [{
                users = ["diego"];
                keepEnv = true;
                persist = true;
            }];
        };
    };

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # Docker settings
    virtualisation.docker = {
        enable = true;
        /*
        rootless = {
            enable = true;
            setSocketVariable = true;
        };
        */
    };

    users.defaultUserShell = pkgs.zsh;
    nix = {
        package = pkgs.nixVersions.stable;
        extraOptions = ''
            experimental-features = nix-command flakes
            warn-dirty = false
        '';
    };
}
