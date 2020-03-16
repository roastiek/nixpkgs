{ lib, config, ... }:

with lib;

let
  cfg = config.boot.loader.efi;
in
{
  options.boot.loader.efi = {

    canTouchEfiVariables = mkOption {
      default = false;
      type = types.bool;
      description = "Whether the installation process is allowed to modify EFI boot variables.";
    };

    efiSysMountPoint = mkOption {
      default = "/boot";
      type = types.str;
      description = "Where the EFI System Partition is mounted.";
    };

    extendedBootLoaderMountPoint = mkOption {
      default = cfg.efiSysMountPoint;
      type = types.str;
      description = "Where the EFI System Partition is mounted.";
    };
  };
}
