{pkgs, ...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./tailscale-cert.nix
    ./forgejo-backup.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "forgejo"; # Define your hostname.
  networking.firewall.allowedTCPPorts = [3000];

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Enable the Tailscale daemon.
  services.tailscale.enable = true;

  networking.firewall.trustedInterfaces = ["tailscale0"];
  networking.firewall.checkReversePath = "loose";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.denis = {
    isNormalUser = true;
    extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
  };

  nix.settings.trusted-users = [
    "root"
    "denis"
  ];

  # Transmet la définition xterm kitty à la VM
  environment.enableAllTerminfo = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    git
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  security.sudo.wheelNeedsPassword = false;

  # Configuration de Nginx
  services.nginx = {
    enable = true;

    virtualHosts."forgejo.tail3e17a7.ts.net" = {
      forceSSL = true;

      sslCertificate = "/etc/tailscale-certs/forgejo.tail3e17a7.ts.net.crt";

      sslCertificateKey = "/etc/tailscale-certs/forgejo.tail3e17a7.ts.net.key";

      locations."/" = {
        proxyPass = "http://127.0.0.1:3000";
      };
    };
  };

  # Configuration de Forgejo avec PostgreSQL
  services.forgejo = {
    enable = true;
    database.type = "postgres";

    settings.server = {
      #DOMAIN = "192.168.1.122";
      #ROOT_URL = "http://192.168.1.122:3000/";
      DOMAIN = "forgejo.tail3e17a7.ts.net";
      ROOT_URL = "https://forgejo.tail3e17a7.ts.net/";
      HTTP_PORT = 3000;
    };
    settings.service.DISABLE_REGISTRATION = true; # Empêche la création de nouveau compte par la page d'inscription
  };

  system.stateVersion = "26.05"; # Did you read the comment?
}
