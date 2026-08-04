{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.userSettings.formatters;
in {
  options.userSettings.formatters = {
    enable = lib.mkEnableOption "Install formatters";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      alejandra
      black
      dprint
      isort
      prettier
      stylua
    ];
  };
}
