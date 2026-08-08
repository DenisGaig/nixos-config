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
      rofimoji
      thunar
      waybar
      wlogout
      wlsunset
    ];

    gtk = {
      enable = true;
      theme = {
        name = "Adwaita";
        package = pkgs.gnome-themes-extra;
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

    # Gestion des services de notification situés dans ./services/
    userSettings.flakeReminder.enable = lib.mkDefault true;
    userSettings.nixGarbageNotification.enable = lib.mkDefault true;
  };
}
