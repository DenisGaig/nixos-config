{
  pkgs,
  lib,
  ...
}: {
  networking.hostName = "ci-microvm";

  services.tailscale.enable = true;

  # User et groupe pour Forgejo
  users.groups.forgejo-runner = {};

  # users.users.forgejo-runner = {
  #   isSystemUser = true;
  #   group = "forgejo-runner";
  #   home = "/home/forgejo-runner";
  #   createHome = true;
  # };

  users.users.forgejo-runner = {
    isSystemUser = true;
    group = "forgejo-runner";
    home = "/home/forgejo-runner";
    createHome = true;

    subUidRanges = [
      {
        startUid = 100000;
        count = 65536;
      }
    ];

    subGidRanges = [
      {
        startGid = 100000;
        count = 65536;
      }
    ];
  };

  # User pour l'administration
  users.users.test = {
    isNormalUser = true;
    initialPassword = "test";
    extraGroups = ["wheel"];
  };

  microvm = {
    hypervisor = "cloud-hypervisor";

    mem = 512;

    hotplugMem = 2048;
    hotpluggedMem = 0;

    interfaces = [
      {
        type = "tap";
        id = "ci-microvm";
        mac = "02:00:00:00:00:01";
      }
    ];

    volumes = [
      {
        image = "containers.img";
        mountPoint = "/home/forgejo-runner/.local/share/containers";
        size = 8192;
        fsType = "ext4";
      }
    ];
  };

  microvm.binScripts.tap-up = lib.mkAfter ''
    ${lib.getExe' pkgs.iproute2 "ip"} link set dev 'ci-microvm' master 'br0'
  '';

  systemd.network.networks."10-eth0" = {
    matchConfig.MACAddress = "02:00:00:00:00:01";
    #matchConfig.Name = "ens3"; # et pas eth0
    networkConfig.DHCP = "yes";
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true; # pratique pour tester avec test/test
      PermitRootLogin = "no";
    };
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
  };

  environment.systemPackages = with pkgs; [
    btop
    forgejo-runner
  ];

  system.stateVersion = "26.05";
}
