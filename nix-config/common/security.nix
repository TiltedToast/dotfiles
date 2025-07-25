{ ... }:

{
  security.sudo = {
    enable = true;
    extraRules = [
      {
        users = [ "tim" ];
        commands = [ "ALL" ];
      }
      {
        users = [ "tim" ];
        commands = [
          {
            command = "/run/current-system/sw/bin/ip";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
  };
}
