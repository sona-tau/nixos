{ ... }: {
  flake.modules.nixos.grocy = { config, lib, ... }: {
    services.grocy = {
      enable = true;
      hostName = "grocy.hp";
      nginx.enableSSL = false;

      phpfpm.settings = {
        "pm" = "dynamic";
        "pm.max_children" = "32";
        "pm.start_servers" = "2";
        "pm.min_spare_servers" = "2";
        "pm.max_spare_servers" = "4";
        "pm.max_requests" = "500";
        "php_admin_value[error_log]" = "stderr";
        "php_admin_flag[log_errors]" = true;
        "catch_workers_output" = true;
        "listen.owner" = "caddy";
        "listen.group" = "caddy";
        "listen.mode" = "0660";
      };
    };

    # grocy enables nginx by default; use Caddy instead.
    # The nginx group must still exist because grocy's system user defaults to group = "nginx".
    services.nginx.enable = lib.mkForce false;
    users.groups.nginx = { };
    users.users.nginx = {
      isSystemUser = lib.mkDefault true;
      group = "nginx";
    };

    services.caddy.virtualHosts."http://grocy.hp".extraConfig = ''
      			root * ${config.services.grocy.package}/public
      			php_fastcgi unix/${config.services.phpfpm.pools.grocy.socket}
      			file_server
      		'';
  };
}
