{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.userSettings.media;
in {
  options.userSettings.media = {
    enable = lib.mkEnableOption "Install media packages";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      art
      imagemagick
      nsxiv
    ];
    userSettings.mpv.enable = lib.mkDefault true;
  };
}
