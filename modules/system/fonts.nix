{pkgs, ...}: {
  # Installation des fonts
  fonts.packages = with pkgs; [
    nerd-fonts.hasklug
    victor-mono
  ];
}
