{ inputs, outputs, nixpkgs, ... }: let
	myLib = (import ./default.nix) { inherit inputs outputs nixpkgs; };
in rec {
/*
									 My Lib
*/

/*
	  # ======================= Package Helpers ======================== #

	pkgsFor = sys: inputs.nixpkgs.legacyPackages.${sys};

	  # ========================== Buildables ========================== #

*/
	# String -> Path -> List Attr
	# This will create a nixosConfiguration for a system ${system} with
	# config specified at ${config} and with additional modules specified by
	# extraModules.
	mkSystem = system: config: extraModules:
		inputs.nixpkgs.lib.nixosSystem {
			specialArgs = {
				inherit inputs outputs myLib;

				/*
				pkgs = import inputs.nixpkgs {
					system = system;

					config = {
							allowUnfree = true;
							allowUnfreePredicate = (_: true);
							allowUnsupportedSystem = true;
					};
				};
				*/
			};

			modules = [
				config
				# outputs.module.nixos.default
			] ++ extraModules;
		};

	# String -> Path -> List Attr
	# This will create a homeManagerConfiguration for a system ${system} with
	# config specified at ${config} and with additional modules specified by
	# extraModules.
	mkHome = system: config: extraModules: let
		pkgs = inputs.nixpkgs.legacyPackages.${system};
		in inputs.home-manager.lib.homeManagerConfiguration {
			inherit pkgs;

			extraSpecialArgs = {
				inherit inputs myLib outputs;

				pkgs = import inputs.nixpkgs {
					system = system;

					config = {
							allowUnfree = true;
							allowUnfreePredicate = (_: true);
							allowUnsupportedSystem = true;

							permittedInsecurePackages = [ "quickjs-2025-09-13-2" ];
					};
				};
			};

			modules = [
				config
				# outputs.module.home.default
			] ++ extraModules;

			# Optionally use extraSpecialArgs
			# to pass through arguments to home.nix
		};

/*
	# =========================== Helpers ============================ #

	filesIn = dir: (map (fname: dir + "/${fname}") (builtins.attrNames (builtins.readDir dir)));

	dirsIn = dir: inputs.nixpkgs.lib.filterAttrs (name: value: value == "directory") (builtins.readDir dir);

	fileNameOf = path: (builtins.head (builtins.split "\\." (baseNameOf path)));

	# ========================== Extenders =========================== #

	# Evaluates nixos/home-manager module and extends it's options / config
	extendModule = { path, ... }@args: { pkgs, ... }@margs: let
		eval = if (builtins.isString path) || (builtins.isPath path)
			then import path margs
			else path margs;

		evalNoImports = builtins.removeAttrs eval ["imports" "options"];

		extra = if (builtins.hasAttr "extraOptions" args) || (builtins.hasAttr "extraConfig" args)
			then [
				({...}: {
					options = args.extraOptions or {};
					config = args.extraConfig or {};
				})
			] else [];
	in {
		imports = (eval.imports or []) ++ extra;

		options = if builtins.hasAttr "optionsExtension" args
			then (args.optionsExtension (eval.options or {}))
			else (eval.options or {});

		config = if builtins.hasAttr "configExtension" args
			then (args.configExtension (eval.config or evalNoImports))
			else (eval.config or evalNoImports);
	};

	# Applies extendModules to all modules
	# modules can be defined in the same way
	# as regular imports, or taken from "filesIn"
	extendModules = extension: modules: map (f: let
			name = fileNameOf f;
		in (extendModule ((extension name) // {path = f;}))) modules;

	# ============================ Shell ============================= #
	forAllSystems = pkgs: inputs.nixpkgs.lib.genAttrs [
			"x86_64-linux"
			"aarch64-linux"
			"x86_64-darwin"
			"aarch64-darwin"
		] (system: pkgs inputs.nixpkgs.legacyPackages.${system});
*/
}
