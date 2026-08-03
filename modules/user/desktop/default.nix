{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.userSettings.desktop;
in {
  options.userSettings.desktop = {
    enable = lib.mkEnableOption "Install desktop packages";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      grimblast
      hyprpaper
      hyprpicker
      rofi
      thunar
      waybar
      wlogout
      wlsunset
    ];

    gtk = {
      enable = true;
      theme = {
        name = "Dracula";
        package = pkgs.dracula-theme;
      };
      iconTheme = {
        name = "Dracula";
        package = pkgs.dracula-icon-theme;
      };
      cursorTheme = {
        name = "Capitaine Cursors";
        package = pkgs.capitaine-cursors;
      };
    };
  };
}
