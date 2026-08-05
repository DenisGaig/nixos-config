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
      Unit = {
        Description = "Rappel de mise à jour du flake";
      };

      Service = {
        Type = "oneshot";
        ExecStart = "${flakeReminder}/bin/flake-update-reminder";
      };
    };

    systemd.user.timers.flake-update-reminder = {
      Unit = {
        Description = "Lance le rappel de mise à jour après la connexion";
      };

      Timer = {
        OnStartupSec = "5s";
        Unit = "flake-update-reminder.service";
      };

      Install = {
        WantedBy = ["timers.target"];
      };
    };

    # SYNTAXE POUR LE SERVICE SANS HOME-MANAGER

    # systemd.user.services.flake-update-reminder = {
    #   description = "Rappel mise à jour de flake.nix";

    #   serviceConfig = {
    #     Type = "oneshot";
    #     ExecStart = "${flakeReminder}/bin/flake-update-reminder";
    #   };
    # };

    # systemd.user.timers.flake-update-reminder = {
    #   description = "Lance le rappel de mise à jour quelques secondes après la connexion";

    #   wantedBy = ["timers.target"];

    #   timerConfig = {
    #     OnStartupSec = "5s";
    #   };
    # };
  };
}
