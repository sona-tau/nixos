{ config, lib, pkgs, inputs, ... }: let cfg = config.my.roles.browsers; in {
	options = {
		my.roles.browsers.enable = lib.mkEnableOption "default browsers (zen, librewolf, qutebrowsers)";
	};

	config = lib.mkIf cfg.enable {
		home.packages = [
			pkgs.librewolf
			pkgs.qutebrowser
			pkgs.firefoxpwa
			(inputs.zen-browser.packages."x86_64-linux".default.overrideAttrs (final: prev: {
				policies = { # find more options here: https://mozilla.github.io/policy-templates/
					AutofillAddressEnabled = true;
					AutofillCreditCardEnabled = false;
					DisableAppUpdate = true;
					DisableFeedbackCommands = true;
					DisableFirefoxStudies = true;
					DisablePocket = true;
					DisableTelemetry = true;
					DontCheckDefaultBrowser = true;
					NoDefaultBookmarks = true;
					OfferToSaveLogins = false;
					EnableTrackingProtection = {
						Value = true;
						Locked = true;
						Cryptomining = true;
						Fingerprinting = true;
					};
				};
				nativeMessagingHosts.packages = [ pkgs.firefoxpwa ];
			 }))
		];
	};
}
