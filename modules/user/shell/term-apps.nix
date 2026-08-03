{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.userSettings.shell.apps;
in {
  options = {
    userSettings.shell.apps = {
      enable = lib.mkEnableOption "Enable a collection of additional useful CLI apps";
    };
  };

  config = lib.mkIf cfg.enable {
    # Collection of useful CLI apps
    home.packages = with pkgs; [
      calc
      curl
      curl.dev
      rsync
      wget
      wl-clipboard
    ];

    programs.fzf = {
      enable = true;
      enableFishIntegration = true;
      historyWidget.command = "";
      defaultCommand = "fd --type f --hidden --exclude .git";

      defaultOptions = [
        "--preview-window=right:50%:wrap"
      ];
    };

    programs.yazi.enable = true;
  };
}
