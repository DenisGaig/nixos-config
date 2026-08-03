{
  lib,
  config,
  ...
}: let
  cfg = config.systemSettings.syncthing;
in {
  options.systemSettings.syncthing = {
    enable = lib.mkEnableOption "Install syncthing service";
  };

  config = lib.mkIf cfg.enable {
    # List services that you want to enable:
    services.syncthing = {
      enable = true;
      user = "denis";
      dataDir = "/home/denis";
      configDir = "/home/denis/.config/syncthing";
    };
  };
}
