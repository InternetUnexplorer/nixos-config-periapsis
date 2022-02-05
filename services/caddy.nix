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

    handle_errors {
      respond "{http.error.status_code} {http.error.status_text}"
    }
  '';
}
