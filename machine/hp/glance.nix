{ ... }: {
	services.glance = {
		enable = true;

		settings = {
			server = {
				host = "127.0.0.1";
				port = 8085;
			};

			pages = [{
				name = "Home";
				columns = [
					{
						size = "small";
						widgets = [
							{
								type = "clock";
								hour-format = "24h";
								timezones = [
									{ timezone = "America/Puerto_Rico"; label = "Local"; }
									{ timezone = "UTC"; label = "UTC"; }
								];
							}
							{
								type = "monitor";
								title = "Services";
								sites = [
									{ title = "Grafana";       url = "http://grafana.hp";       check-url = "http://127.0.0.1:3001"; }
									{ title = "Jellyfin";      url = "http://jellyfin.hp";      check-url = "http://127.0.0.1:8096"; }
									{ title = "Navidrome";     url = "http://navidrome.hp";     check-url = "http://127.0.0.1:4533"; }
									{ title = "Immich";        url = "http://immich.hp";        check-url = "http://127.0.0.1:2283"; }
									{ title = "Forgejo";       url = "http://git.hp";           check-url = "http://127.0.0.1:3000"; }
									{ title = "Traccar";       url = "http://traccar.hp";       check-url = "http://127.0.0.1:8082"; }
									{ title = "Home Assistant"; url = "http://homeassistant.hp"; check-url = "http://127.0.0.1:8123"; }
									{ title = "Radicale";      url = "http://radicale.hp";      check-url = "http://127.0.0.1:5232"; }
									{ title = "Syncthing";     url = "http://syncthing.hp";     check-url = "http://127.0.0.1:8384"; }
								];
							}
						];
					}
					{
						size = "full";
						widgets = [
							{
								type = "hacker-news";
								limit = 15;
								collapse-after = 5;
							}
							{
								type = "rss";
								title = "Lobsters";
								limit = 15;
								collapse-after = 5;
								feeds = [{ url = "https://lobste.rs/rss"; }];
							}
						];
					}
					{
						size = "small";
						widgets = [
							{
								type = "bookmarks";
								title = "Services";
								groups = [{
									title = "hp";
									links = [
										{ title = "Grafana";        url = "http://grafana.hp"; }
										{ title = "Jellyfin";       url = "http://jellyfin.hp"; }
										{ title = "Navidrome";      url = "http://navidrome.hp"; }
										{ title = "Immich";         url = "http://immich.hp"; }
										{ title = "Forgejo";        url = "http://git.hp"; }
										{ title = "Traccar";        url = "http://traccar.hp"; }
										{ title = "Home Assistant"; url = "http://homeassistant.hp"; }
										{ title = "Radicale";       url = "http://radicale.hp"; }
										{ title = "Syncthing";      url = "http://syncthing.hp"; }
									];
								}];
							}
						];
					}
				];
			}];
		};
	};
}
