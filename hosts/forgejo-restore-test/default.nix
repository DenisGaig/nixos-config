{pkgs, ...}: {
  networking.hostName = "forgejo-restore-test";

  networking.networkmanager.enable = true;

  # Utilisateur permettant d'administrer la VM
  users.users.denis = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    hashedPassword = "$y$j9T$U1IItB65E5yJ2WLHrvVN00$ZeiJ/86C74s7dWHF07iA4nGl4Z57cwkVHZkbDgYRlT2";
  };

  security.sudo.wheelNeedsPassword = false;

  nix.settings.trusted-users = [
    "root"
    "denis"
  ];

  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  services.openssh.enable = true;

  # Forgejo + PostgreSQL
  services.forgejo = {
    enable = true;

    database.type = "postgres";

    settings.server = {
      DOMAIN = "127.0.0.1";
      ROOT_URL = "http://127.0.0.1:3000/";
      HTTP_PORT = 3000;
    };

    disableRegistration = true;
  };

  # Ressources spécifiques à la VM créée par build-vm
  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 2048;
      cores = 2;
      forwardPorts = [
        {
          from = "host";
          host.port = 2222;
          guest.port = 22;
        }
        {
          from = "host";
          host.port = 3001;
          guest.port = 3000;
        }
      ];
    };
  };

  system.stateVersion = "26.05";
}
