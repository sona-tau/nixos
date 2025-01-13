{ config, lib, hostname, ... }:
{
	accounts.email = {
		accounts.protonmail = {
			address = "diego.estrada1@proton.me";
#			gpg = {
#				key = "";
#				signByDefault = true;
#			};
			imap = {
				host = "imap://diego.estrada1@localhost";
				port = 1143;
				tls.enable = true;
			};
			smtp = {
				host = "smtp://diego.estrada1@localhost";
				port = 1025;
				tls.enable = true;
			};
#			mbsync = {
#				enable = true;
#				create = "maildir";
#			};
#			msmtp.enable = true;
#			notmuch.enable = true;
			primary = true;
			neomutt.enable = true;
#			realName = "";
			signature = {
				text = ''
				- Diego
				https://diego-est.srht.site/
				'';
				showSignature = "append";
			};
#			passwordCommand = "pass email/";
#			smtp = {
#				host = "";
#			};
#			userName = "diego.estrada1@proton.me";
		};
	};
}
