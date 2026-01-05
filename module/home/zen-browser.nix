{ config, ... }: { 
	config.services.systemPackages = [
		(inputs.zen-browser.packages."${system}".default.overrideAttrs (
			final: prev: {
				nativeMessagingHosts.packages = [ pkgs.firefoxpwa ];

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
			}))
		];
	};
}
