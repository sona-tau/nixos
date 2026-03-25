{ config, lib, pkgs, inputs, ... }: let cfg = config.my.noctalia; in {
	imports = [
		inputs.noctalia.homeModules.default
	];

	options.my.noctalia.enable = lib.mkEnableOption "noctalia";

	config = lib.mkIf cfg.enable {
		programs.noctalia-shell = {
			enable = true;
			settings = {
				bar = {
					density = "compact";
					position = "right";
					showCapsule = false;
					widgets = {
						left = [
						{
							id = "ControlCenter";
							useDistroLogo = true;
						}
						{
							id = "Network";
						}
						{
							id = "Bluetooth";
						}
						];
						center = [
						{
							hideUnoccupied = false;
							id = "Workspace";
							labelMode = "none";
						}
						];
						right = [
						{
							alwaysShowPercentage = false;
							id = "Battery";
							warningThreshold = 30;
						}
						{
							formatHorizontal = "HH:mm";
							formatVertical = "HH mm";
							id = "Clock";
							useMonospacedFont = true;
							usePrimaryColor = true;
						}
						];
					};
				};
				colorSchemes.predefinedScheme = "Monochrome";
				general = {
					avatarImage = "/home/drfoobar/Media/Pictures/pfp.jpg";
					radiusRatio = 0.2;
				};
				location = {
					monthBeforeDay = true;
					name = "Marseille, France";
				};
			};
		};
	};
}
