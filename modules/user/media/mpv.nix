{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.userSettings.mpv;
in {
  options.userSettings.mpv = {
    enable = lib.mkEnableOption "Install mpv package";
  };

  config = lib.mkIf cfg.enable {
    programs.mpv = {
      enable = true;
      config = {
        profile = "gpu-hq";
        vo = "gpu-next";
        # hwdec = "auto-safe";
        hwdec = "vaapi";

        save-position-on-quit = "yes";
        keep-open = "yes";

        alang = "fr,en";
        slang = "fr,en";

        deband = "yes";
        volume-max = "150";
      };
    };
  };
}
