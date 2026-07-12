{ ... }: {
  flake.modules.nixos.kubo = { ... }: {
    services.kubo = {
      enable = true;

      settings.Addresses.API = "/ip4/127.0.0.1/tcp/5001";
      settings.Addresses.Gateway = "/ip4/127.0.0.1/tcp/8080";

      settings.API.HTTPHeaders = {
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

      settings.Gateway.PublicGateways."ipfs.hp" = {
        Paths = [
          "/ipfs"
          "/ipns"
          "/api"
        ];
        UseSubdomains = false;
      };

      # nixpkgs bug: kubo module reads Mounts.fuseAllowOther (wrong case) at eval time;
      # declaring it prevents the attribute-missing error.
      settings.Mounts.fuseAllowOther = false;
    };

  };
}
