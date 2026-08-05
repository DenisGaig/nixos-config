{
  pkgs,
  lib,
  config,
  ...
}: let
  flakeReminder = import ../../../pkgs/flake-reminder.nix {inherit pkgs;};
  cfg = config.userSettings.flakeReminder;
in {
  options.userSettings.flakeReminder = {
    enable = lib.mkEnableOption "Install flake-reminder package";
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.flake-update-reminder = {
      description = "Rappel mise à jour de flake.nix";

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${flakeReminder}/bin/flake-update-reminder";
      };

      wantedBy = [
      ];
    };

    systemd.user.timers.flake-update-reminder = {
      description = "Lance le rappel de mise à jour quelques secondes après la connexion";

      wantedBy = ["timers.target"];

      timerConfig = {
        OnStartupSec = "5s";
      };
    };
  };
}
