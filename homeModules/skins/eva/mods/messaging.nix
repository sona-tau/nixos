{ config, lib, pkgs, ... }:
let cfg = config.messaging; in
{
	options.messaging = with lib; {
		enable = mkEnableOption "messaging";

		whatsApp.enable = mkEnableOption "whatsApp";
		signal.enable = mkEnableOption "signal";
		matrix.enable = mkEnableOption "matrix";
		irssi.enable = mkEnableOption "irssi";
		email.enable = mkEnableOption "email";
	};

	config = with lib; lib.mkIf cfg.enable {
		home.packages = with pkgs; [
			(mkIf cfg.whatsApp.enable whatsapp-for-linux)
			(mkIf cfg.signal.enable signald)
			(mkIf cfg.signal.enable signaldctl)
			(mkIf cfg.signal.enable signal-cli)
			(mkIf cfg.signal.enable signal-desktop)
			# (mkIf cfg.matrix.enable matrix-commander)
			(mkIf cfg.irssi.enable irssi)
			(mkIf cfg.email.enable thunderbird)
			(mkIf cfg.email.enable hydroxide)
			(mkIf cfg.email.enable aerc)
		];

		#accounts.email.accounts."sona@stau.space".aerc = mkIf cfg.email.enable {
		#	enable = true;
		#};
	};
}
