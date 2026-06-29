{ ... }: {
	flake.modules.homeManager.kagi = { pkgs, ... }: {
		home.packages = [
			pkgs.nushell

			# kagi <query> — search Kagi and display results in the terminal
			# kagi <query> -n 20 — fetch more results (default 10, max 100)
			# Credentials: pass show kagi/api-key
			(pkgs.writeTextFile {
				name = "kagi";
				executable = true;
				destination = "/bin/kagi";
				text = ''
					#!${pkgs.nushell}/bin/nu

					def main [
						...terms: string   # words to search for
						--limit (-n): int = 10  # number of results (max 100)
					] {
						let query = ($terms | str join " ")
						if ($query | is-empty) {
							error make {msg: "Usage: kagi <search terms> [-n <limit>]"}
						}

						let key = (^${pkgs.pass}/bin/pass show kagi/api-key | str trim)

						let results = (
							http get
								--headers {Authorization: $"Bot ($key)"}
								$"https://kagi.com/api/v0/search?q=($query | url encode)&limit=($limit)"
							| get data
							| where t == 0
						)

						for r in $results {
							let snippet = ($r | get -i snippet | default "")
							print $"(ansi yellow)($r.rank).(ansi reset) (ansi bold)($r.title)(ansi reset)"
							print $"   (ansi cyan)($r.url)(ansi reset)"
							if ($snippet | is-not-empty) {
								print $"   ($snippet)"
							}
							print ""
						}
					}
				'';
			})
		];
	};
}
