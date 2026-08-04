{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.userSettings.mise;
in {
  options.userSettings.mise = {
    enable = lib.mkEnableOption "Install mise";
  };

  config = lib.mkIf cfg.enable {
    programs.mise = {
      enable = true;
      enableFishIntegration = true;
      globalConfig.settings = {
        all_compile = false;
      };
    };
  };
}
