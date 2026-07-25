_: {
  flake.modules.nixos.kubo = _: {
    services.kubo = {
      enable = true;

      settings = {
        Addresses = {
          API = "/ip4/127.0.0.1/tcp/5001";
          Gateway = "/ip4/127.0.0.1/tcp/8080";
        };

        API.HTTPHeaders = {
          "Access-Control-Allow-Origin" = [
            "http://ipfs.hp"
            "http://127.0.0.1:5001"
            "https://webui.ipfs.io"
          ];
          "Access-Control-Allow-Methods" = [
            "PUT"
            "POST"
          ];
        };

        Gateway.PublicGateways."ipfs.hp" = {
          Paths = [
            "/ipfs"
            "/ipns"
            "/api"
          ];
          UseSubdomains = false;
        };

        # nixpkgs bug: kubo module reads Mounts.fuseAllowOther (wrong case) at eval time;
        # declaring it prevents the attribute-missing error.
        Mounts.fuseAllowOther = false;
      };
    };

  };
}
