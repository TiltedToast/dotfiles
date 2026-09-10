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
  options.intel.enable = lib.mkEnableOption "Intel graphics, video acceleration and GPU monitoring";

  config = lib.mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      extraPackages = [ pkgs.intel-media-driver ];
    };

    security.wrappers.btop = {
      source = "${pkgs.btop}/bin/btop";
      owner = "root";
      group = "wheel";
      permissions = "u+rx,g+rx,o-rwx";
      capabilities = "cap_perfmon+ep";
    };
  };
}
