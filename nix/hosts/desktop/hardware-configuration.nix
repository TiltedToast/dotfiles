{
  config,
  lib,
  pkgs,
  currentUsername,
  ...
}:

{
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [
    "kvm-amd"
    "hid-logitech-dj"
    "zenpower"
  ];

  boot.blacklistedKernelModules = [ "k10temp" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.zenpower ];

  boot.kernelParams = [
    "resume_offset=33307031"
    "drm.edid_firmware=DP-3:edid/odyssey-g7-8bpc.bin"
    "amd_pstate=active"
  ];
  boot.resumeDevice = "/dev/disk/by-partlabel/disk-primary-root";

  powerManagement.enable = true;

  hardware.nvidia.powerManagement.enable = true;

  hardware.firmware = [
    (pkgs.runCommandNoCC "firmware-custom-edid" { } ''
      mkdir -p $out/lib/firmware/edid/
      cp "${../../firmware/odyssey-g7-8bpc-edid.bin}" $out/lib/firmware/edid/odyssey-g7-8bpc.bin
    '')
  ];

  boot.loader = {
    efi.canTouchEfiVariables = true;

    grub = {
      enable = true;
      devices = [ "nodev" ];
      efiSupport = true;
      font = "${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMono/JetBrainsMonoNerdFont-Regular.ttf";
      fontSize = 24;
    };
  };

  users.groups.media = { };

  users.users.sonarr.extraGroups = [ "media" ];
  users.users.qbittorrent.extraGroups = [ "media" ];
  users.users.${currentUsername}.extraGroups = [ "media" ];

  fileSystems."/mnt/shows" = {
    device = "/dev/disk/by-uuid/206C11B36C1184A6";
    fsType = "ntfs3";
    options = [
      "defaults"
      "uid=1000"
      "gid=media"
      "umask=0002"
      "rw"
      "windows_names"
    ];
  };

  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-uuid/1260ED5460ED3F5B";
    fsType = "ntfs3";
    options = [
      "defaults"
      "uid=1000"
      "gid=media"
      "umask=0002"
      "rw"
      "discard"
    ];
  };

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
