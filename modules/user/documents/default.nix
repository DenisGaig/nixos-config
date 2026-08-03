{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.userSettings.documents;
in {
  options.userSettings.documents = {
    enable = lib.mkEnableOption "Install document packages";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      zathura
    ];
  };
}
