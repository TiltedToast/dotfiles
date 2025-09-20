{ pkgs, ... }:
let
  no-rgb = pkgs.writeShellApplication {
    name = "no-rgb";
    runtimeInputs = with pkgs; [
      openrgb
      gnugrep
      coreutils
    ];
    text = ''
      NUM_DEVICES=$(openrgb --noautoconnect --list-devices | grep -cE '^[0-9]+: ')

      for i in $(seq 0 $((NUM_DEVICES - 1))); do
        openrgb --noautoconnect --device "$i" --mode static --color 000000
      done
    '';
  };
in
{
  services.udev.packages = [ pkgs.openrgb ];
  boot.kernelModules = [ "i2c-dev" ];
  hardware.i2c.enable = true;

  systemd.services.no-rgb = {
    description = "no-rgb";
    serviceConfig = {
      ExecStart = "${no-rgb}/bin/no-rgb";
      Type = "oneshot";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
