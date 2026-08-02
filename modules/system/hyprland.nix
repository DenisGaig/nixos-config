{
  pkgs,
  config,
  ...
}: {
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

  # Configure keymap in X11
  services.xserver.xkb.layout = "fr";

  # services.xserver.xkb.options = "eurosign:e,caps:escape";
}
