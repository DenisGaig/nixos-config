{pkgs, ...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
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

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    git
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  security.sudo.wheelNeedsPassword = false;

  # Configuration de Forgejo avec PostgreSQL
  services.forgejo = {
    enable = true;
    database.type = "postgres";

    settings.server = {
      DOMAIN = "192.168.1.122";
      ROOT_URL = "http://192.168.1.122:3000/";
    };

    disableRegistration = true; # Empêche la création de nouveau compte par la page d'inscription
  };

  system.stateVersion = "26.05"; # Did you read the comment?
}
