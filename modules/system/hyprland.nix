{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.systemSettings.hyprland;
in {
  options.systemSettings.hyprland = {
    enable = lib.mkEnableOption "Install hyprland";
  };

  config = lib.mkIf cfg.enable {
    # Hyrpland settings
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    # Lancement auto de Hyprland au démarrage avec TUIgreet
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd ${config.programs.hyprland.package}/bin/start-hyprland";
          user = "greeter";
        };
      };
    };

    # Enable the X11 windowing system.
    # services.xserver.enable = true;

    # Configure keymap in X11 avec remplace de la touche caps par la touche escape
    services.xserver.xkb = {
      layout = "fr";
      options = "caps:escape";
    };

    # services.xserver.xkb.options = "eurosign:e,caps:escape";
  };
}
