{ config, pkgs, lib, modulesPath, ... }:

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
