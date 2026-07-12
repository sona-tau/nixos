{ ... }: {
	flake.modules.homeManager = {
		distributed-host = { ... }: {
			users = {
				users."nixremote" = {
					isSystemUser = true;
					group = "nixremote";
					useDefaultShell = true;
					openssh.authorizedKeys.keys = [
						"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDVYH7L4b+9xrjAmlwTAnMOz7F0kdyOKBw6KBrzGO/yk root@fw13"
					];
				};
				groups.nixremote = { };
			};

			nix = {
				nrBuildUsers = 64;
				settings = {
					trusted-users = [ "nixremote" ];
					max-jobs = "auto";
					cores = 0;
					min-free = 10 * 1024 * 1024;
					max-free = 200 * 1024 * 1024;
				};
			};

			systemd.services.nix-daemon.serviceConfig = {
				MemoryAccounting = true;
				MemoryMax = "90%";
				OOMScoreAdjust = 500;
			};
		};

		distributed-client = { config, lib, pkgs, ... }: {
			nix.buildMachines = [
				{
					hostName = "builder";
					system = "x86_64-linux";
					protocol = "ssh-ng";
					maxJobs = 6;
					speedFactor = 2;
					supportedFeeatures = [
						"nixos-test"
						"benchmark"
						"big-parallel"
						"kvm"
					];
					mandatoryFeatures = [];
				}
			];

			nix.distributedBuilds = true;
			nix.settings.builders-use-substitutes = true;
		};
	};
}
