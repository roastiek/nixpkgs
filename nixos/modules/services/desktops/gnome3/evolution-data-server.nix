# Evolution Data Server daemon.

{ config, lib, pkgs, ... }:

with lib;

let
  #gnome3 = config.environment.gnome3.packageSet;
  plugins = if ( config.services.gnome3.evolution-data-server.plugins == null )
    then pkgs.gnome3.evolution_data_server
    else ( pkgs.symlinkJoin {
      name = "evolution_data_server_with_plugins";
      paths = [ pkgs.gnome3.evolution_data_server ] ++ config.services.gnome3.evolution-data-server.plugins;
    });
in
{

  ###### interface

  options = {

    services.gnome3.evolution-data-server = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable Evolution Data Server, a collection of services for 
          storing addressbooks and calendars.
        '';
      };

      plugins = mkOption {
        type = types.nullOr ( types.listOf types.package );
        default = null;
        description = ''
        '';
      };
    };

  };


  ###### implementation

  config = mkIf config.services.gnome3.evolution-data-server.enable {

    environment.systemPackages = [ pkgs.gnome3.evolution_data_server ];

    services.dbus.packages = [ pkgs.gnome3.evolution_data_server ];

    systemd.packages = [ pkgs.gnome3.evolution_data_server ];

    systemd.user.services = {
      evolution-addressbook-factory.environment.EDS_ADDRESS_BOOK_MODULES = "${plugins}/lib/evolution-data-server/addressbook-backends";

      evolution-calendar-factory.environment.EDS_CALENDAR_MODULES = "${plugins}/lib/evolution-data-server/calendar-backends";

      evolution-source-registry.environment.EDS_REGISTRY_MODULES = "${plugins}/lib/evolution-data-server/registry-modules";
    };
  };

}
