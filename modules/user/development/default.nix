{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.userSettings.development;
in {
  options.userSettings.development = {
    enable = lib.mkEnableOption "Install development packages";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      clang-tools
      gcc
      gnumake
      pkg-config
    ];

    programs.lazygit = {
      enable = true;
    };

    userSettings.git.enable = lib.mkDefault true;
    userSettings.mise.enable = lib.mkDefault true;
    userSettings.lsp.enable = lib.mkDefault true;
    userSettings.formatters.enable = lib.mkDefault true;

    home.sessionVariables = {
      #PKG_CONFIG_PATH = "/etc/profiles/per-user/denis/lib/pkgconfig";
      PKG_CONFIG_PATH = "${config.home.profileDirectory}/lib/pkgconfig";
    };
  };
}
