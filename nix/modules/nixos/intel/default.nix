{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.intel;
in
{
  options.intel.enable = lib.mkEnableOption "Intel graphics and video acceleration";

  config = lib.mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      extraPackages = [ pkgs.intel-media-driver ];
    };
  };
}
