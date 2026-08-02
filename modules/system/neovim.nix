{...}: {
  # Setup de Neovim = option Nixos
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
}
