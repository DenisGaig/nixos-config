{pkgs, ...}: {
  home.packages = with pkgs; [
    art
    imagemagick
    nsxiv
  ];
}
