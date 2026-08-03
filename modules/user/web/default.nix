{pkgs, ...}: {
  home.packages = with pkgs; [
    brave
  ];
}
#{
#  pkgs,
#  lib,
#  config,
#  ...
#}: let
#  cfg = config.userSettings.web;
#in {
#  options.userSettings.web = {
#    enable = lib.mkEnableOption "Install web browser packages";
#    browser = lib.mkOption {
#      type = lib.types.enum ["brave" "firefox"];
#      default = "brave";
#    };
#  };
#
#  config = lib.mkIf cfg.enable {
#    home.packages =
#      if cfg.browser == "brave"
#      then [pkgs.brave]
#      else [pkgs.firefox];
#  };
#}
