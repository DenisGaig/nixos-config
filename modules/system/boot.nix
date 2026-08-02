{...}: {
  # Configuration du chargeur de démarrage

  # Use the systemd-boot EFI boot loader.
  # Limite le nombre de profiles Nixos (! utiliser le garbage collector pour supprimer le contenu)
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 10;
  };

  # Autorise systemd-boot à gérer les variables EFI
  boot.loader.efi.canTouchEfiVariables = true;
}
