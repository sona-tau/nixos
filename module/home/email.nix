{ config, pkgs, ... }: {
	config = {
		home.packages = with pkgs; [
			aerc            # terminal email
			hydroxide       # proton email syncer
		];

		accounts.email.accounts."personal" = {
			enable = true;
			address = "sona@stau.space";
			name = "Sona Tau Estrada Rivera";
			realName = "Sona Tau Estrada Rivera";
			primary = true;
			passwordCommand = "pass email/";

			aliases = [
				"daestrada@pm.me"
				"diego.estrada1@proton.me"
				"diego.estrada1@pm.me"
				"sona-est@pm.me"
			];

			gpg = {
				key = "4CD8AE4DAAB0A95D";
				signByDefault = true;
			};

			imap = {
				host = "imap://sona@localhost";
				port = 1143;
				tls.enable = true;
			};
			smtp = {
				host = "smtp://sona@localhost";
				port = 1025;
				tls.enable = true;
			};
			primary = true;
			neomutt.enable = true;
			aerc.enable = true;
			signature = {
				text = ''
					- Sona
					https://stau.space/
					'';
				showSignature = "append";
			};
		};
	};
}
