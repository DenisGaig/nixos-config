{pkgs, ...}: {
  # Lix comme implémentation de Nix
  nix.package = pkgs.lixPackageSets.stable.lix;

  # Enable flakes
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    trusted-users = ["root" "denis"]; # Permet à denis d'administrer Nix sans sudo
  };

  # Optimisation automatique du store Nix : Nix recherche les fichiers
  # identiques présents plusieurs fois dans /nix/store et les remplace par
  # des hard links. Cela peut réduire l'espace disque utilisé sans modifier
  # le contenu de tes générations.
  nix.optimise.automatic = true;

  # Permet l'exécution de binaires ELF génériques (non compilés pour NixOS)
  # ex: binaires téléchargés par neovim (LSP, windsurf/neocodeium...)
  # sans cela, ces binaires échouent car /lib/ld-linux-x86-64.so.2 est absent
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib # libstdc++ librairie C++ standard
      zlib # libz — compression, utilisée partout
    ];
  };
}
