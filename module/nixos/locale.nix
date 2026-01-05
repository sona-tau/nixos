{ config, ... }: {
	config.i18n = {
		defaultLocale = "en_US.UTF-8";

		extraLocaleSettings = {
			LC_ADDRESS = "es_PR.UTF-8";
			LC_IDENTIFICATION = "es_PR.UTF-8";
			LC_MEASUREMENT = "es_PR.UTF-8";
			LC_MONETARY = "es_PR.UTF-8";
			LC_NAME = "es_PR.UTF-8";
			LC_NUMERIC = "es_PR.UTF-8";
			LC_PAPER = "es_PR.UTF-8";
			LC_TELEPHONE = "es_PR.UTF-8";
			LC_TIME = "es_PR.UTF-8";
		};
	};
}
