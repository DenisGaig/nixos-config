{pkgs, ...}: {
  home.packages = with pkgs; [
    gnumake
    pkg-config
    lazygit
  ];

  home.sessionVariables = {
    PKG_CONFIG_PATH = "/etc/profiles/per-user/denis/lib/pkgconfig";
  };
}
