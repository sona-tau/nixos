{ ... }: {
  flake.modules.homeManager.bluesky =
    { pkgs, ... }:
    let
      bskyAuth = ''
        			BSKY_IDENTIFIER="''${BSKY_IDENTIFIER:-$(pass show bluesky/identifier)}"
        			BSKY_PASSWORD="''${BSKY_PASSWORD:-$(pass show bluesky/app-password)}"
        			access_jwt=$(
        				xh --ignore-stdin POST "https://bsky.social/xrpc/com.atproto.server.createSession" \
        					identifier="$BSKY_IDENTIFIER" \
        					password="$BSKY_PASSWORD" \
        				| jq -r '.accessJwt'
        			)
        		'';
    in
    {
      home.packages = [
        # Fetch any Bluesky custom feed as RSS XML (pipe into newsboat via exec:)
        # Usage: bsky-rss <at://did:.../app.bsky.feed.generator/name> [limit]
        # Credentials: pass show bluesky/identifier + bluesky/app-password
        (pkgs.writeShellApplication {
          name = "bsky-rss";
          runtimeInputs = [
            pkgs.xh
            pkgs.jq
            pkgs.pass
          ];
          text = ''
            					FEED_URI="''${1:?Usage: bsky-rss <feed-at-uri> [limit]}"
            					LIMIT="''${2:-50}"

            					${bskyAuth}

            					xh --ignore-stdin GET "https://bsky.social/xrpc/app.bsky.feed.getFeed" \
            						"Authorization: Bearer $access_jwt" \
            						feed=="$FEED_URI" \
            						limit=="$LIMIT" \
            					| jq -r --arg uri "$FEED_URI" '
            						"<?xml version=\"1.0\" encoding=\"UTF-8\"?>",
            						"<rss version=\"2.0\">",
            						"<channel>",
            						"  <title>Bluesky: \($uri | split("/") | last)</title>",
            						"  <link>https://bsky.app</link>",
            						"  <description>\($uri)</description>",
            						(.feed[] | .post |
            							"  <item>",
            							"    <title><![CDATA[" + (.author.displayName // .author.handle) + ": " + (.record.text // "") + "]]></title>",
            							"    <link>https://bsky.app/profile/" + .author.handle + "/post/" + (.uri | split("/") | last) + "</link>",
            							"    <description><![CDATA[" + (.record.text // "") + "]]></description>",
            							"    <pubDate>" + .indexedAt + "</pubDate>",
            							"    <guid>" + .uri + "</guid>",
            							"  </item>"
            						),
            						"</channel>",
            						"</rss>"
            					'
            				'';
        })

        # List your saved Bluesky feeds with their AT URIs (use these with bsky-rss)
        (pkgs.writeShellApplication {
          name = "bsky-feeds";
          runtimeInputs = [
            pkgs.xh
            pkgs.jq
            pkgs.pass
          ];
          text = ''
            					${bskyAuth}

            					xh --ignore-stdin GET "https://bsky.social/xrpc/app.bsky.feed.getSavedFeeds" \
            						"Authorization: Bearer $access_jwt" \
            						limit==100 \
            					| jq -r '
            						.feeds[]
            						| select(.type == "feed")
            						| "\(.displayName // "unnamed")\t\(.uri)"
            					'
            				'';
        })
      ];
    };
}
