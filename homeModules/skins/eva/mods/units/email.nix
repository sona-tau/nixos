{ config, lib, hostname, ... }:
{
	accounts.email = {
		accounts.protonmail = {
			address = "sona@stau.space";
#			gpg = {
#				key = "";
#				signByDefault = true;
#			};
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
				- sona
				https://stau.space/
				'';
				showSignature = "append";
			};
#			passwordCommand = "pass email/";
#			smtp = {
#				host = "";
#			};
#			userName = "sona@stau.space";
		};
	};
}
