{ ... }: {
	flake.modules.nixos.common = { pkgs, ... }: {
		users = {
			defaultUserShell = pkgs.zsh;

			users."sona" = {
				isNormalUser = true;
				description = "sona";
				shell = pkgs.zsh;
				extraGroups = [ "networkmanager" "wheel" ];
				packages = with pkgs; [ home-manager neovim zsh ];
			};
		};

		time.timeZone = "America/Puerto_Rico";
		i18n.defaultLocale = "en_US.UTF-8";

		networking = {
			networkmanager.enable = true;
			firewall.enable = true;
		};

		services = {
			openssh = {
				enable = true;

				settings = {
					PasswordAuthentication = false;
					KbdInteractiveAuthentication = false;
					PermitRootLogin = "no";
				};
			};

			tailscale.enable = true;
		};

		nixpkgs.config = {
			allowUnfree = true;
			allowUnsupportedSystem = true;
			permittedInsecurePackages = [ "quickjs-2025-09-13-2" ];
		};

		environment = {
			sessionVariables = rec {
				XDG_CACHE_HOME  = "$HOME/.cache";
				XDG_CONFIG_HOME = "$HOME/.config";
				XDG_DATA_HOME   = "$HOME/.local/share";
				XDG_STATE_HOME  = "$HOME/.local/state";
				XDG_BIN_HOME    = "$HOME/.local/bin";
				PATH = [ "${XDG_BIN_HOME}" ];
			};

			systemPackages = with pkgs; [
				home-manager
				rsync
				wget
				doas
				curl
				git
			];
		};

		programs = {
			zsh.enable = true;

			gnupg.agent = {
				enable = true;
				enableSSHSupport = true;
			};
		};

		security = {
			sudo.enable = false;
			polkit.enable = true;
			rtkit.enable = true;

			doas = {
				enable = true;

				extraRules = [{
					users = [ "sona" ];
					keepEnv = true;
					persist = true;
				}];
			};
		};

		nix = {
			package = pkgs.nixVersions.stable;
			settings.experimental-features = [ "nix-command" "flakes" ];
			extraOptions = ''warn-dirty = false'';
		};
	};
}
