{
  pkgs,
  lib,
  ...
}: let
  configTemplate = pkgs.writeText "forgejo-runner-ci-template.yaml" ''
    runner:
      capacity: 1

    server:
      connections:
        ci:
          url: "https://forgejo.tail3e17a7.ts.net"
          uuid: "bc21661a-53e4-4c24-af4f-3520e5527a97"
          token_url: "file:$CREDENTIALS_DIRECTORY/token"
          labels:
            - "docker:docker://node:22-bookworm"
  '';
in {
  # Configuration de Agenix pour le token de Forgejo Runner
  age.identityPaths = [
    "/var/lib/agenix/age-key.txt"
  ];

  age.secrets.forgejo-runner-token = {
    file = ../../secrets/forgejo-runner-token.age;
    owner = "root";
    group = "root";
    mode = "0400";
  };

  # Configuration du réseau
  networking.hostName = "ci-microvm";

  services.tailscale.enable = true;

  microvm.binScripts.tap-up = lib.mkAfter ''
    ${lib.getExe' pkgs.iproute2 "ip"} link set dev 'ci-microvm' master 'br0'
  '';

  systemd.network.networks."10-eth0" = {
    matchConfig.MACAddress = "02:00:00:00:00:01";
    #matchConfig.Name = "ens3"; # et pas eth0
    networkConfig.DHCP = "yes";
  };

  # Configuartion de SSH
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true; # pratique pour tester avec test/test
      PermitRootLogin = "no";
    };
  };

  # User et groupe pour Forgejo Runner
  users.groups.forgejo-runner = {};

  users.users.forgejo-runner = {
    isSystemUser = true;
    group = "forgejo-runner";
    home = "/home/forgejo-runner";
    createHome = true;
  };

  # User pour l'administration
  users.users.test = {
    isNormalUser = true;
    initialPassword = "test";
    extraGroups = ["wheel"];
  };

  fileSystems."/var/lib/agenix".neededForBoot = true;

  # Configuration de la microvm
  microvm = {
    hypervisor = "cloud-hypervisor";

    #mem = 512;
    #hotplugMem = 2048;
    #hotpluggedMem = 0;

    mem = 2048;

    hotplugMem = 0;
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
        mountPoint = "/var/lib/containers";
        #mountPoint = "/home/forgejo-runner/.local/share/containers";
        size = 8192;
        fsType = "ext4";
      }
      {
        # Pour ne plus avoir à faire sudo tailscale up dans la microvm = rendre persistant la configuration
        image = "tailscale.img";
        mountPoint = "/var/lib/tailscale";
        size = 128;
        fsType = "ext4";
      }
      {
        image = "agenix.img";
        mountPoint = "/var/lib/agenix";
        size = 64;
        fsType = "ext4";
      }
    ];
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
  };

  # Création du service car celui du module nixos (services.gitea-actions-runner) n'est plus a jour
  systemd.services.forgejo-runner-ci = {
    description = "Forgejo Actions Runner (ci)";
    after = ["network-online.target" "podman.service" "tailscaled.service"];
    wants = ["network-online.target"];
    wantedBy = ["multi-user.target"];

    environment.DOCKER_HOST = "unix:///run/podman/podman.sock";

    serviceConfig = {
      User = "forgejo-runner";
      Group = "forgejo-runner";
      SupplementaryGroups = ["podman"];
      LoadCredential = "token:/run/agenix/forgejo-runner-token";
      ExecStart = "${lib.getExe pkgs.forgejo-runner} daemon --config ${configTemplate}";
      Restart = "on-failure";
      RestartSec = 2;
    };
  };

  environment.systemPackages = with pkgs; [
    age
    btop
    vim
  ];

  system.stateVersion = "26.05";
}
