{
  config,
  pkgs,
  ...
}: {
  home.username = "denis";
  home.homeDirectory = "/home/denis";
  # Ne JAMAIS changer cette valeur après le premier build
  home.stateVersion = "26.05";
}
