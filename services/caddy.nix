{ config, pkgs, lib, modulesPath, ... }:

# The caddy service serves the web content for periapsis.cc over HTTPS. \o/
#
# It expects /srv/periapsis.cc to exist and be accessible to the caddy service.

{
  services.caddy = {
    enable = true;
    email = "internetunexplorer@gmail.com";
  };

  services.caddy.virtualHosts."periapsis.cc".extraConfig = ''
    root * /srv/periapsis.cc
    file_server

    header / Strict-Transport-Security "max-age=31536000;"

    handle_errors {
      respond "{http.error.status_code} {http.error.status_text}"
    }
  '';

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
