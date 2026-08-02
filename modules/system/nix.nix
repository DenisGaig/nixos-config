{pkgs, ...}: {
  # Enable flakes
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    download-buffer-size = 268435456;
    trusted-users = ["root" "denis"];
  };

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
