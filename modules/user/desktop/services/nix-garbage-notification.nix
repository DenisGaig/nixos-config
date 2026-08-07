{
  pkgs,
  lib,
  config,
  ...
}: let
  nixGarbageNotification = import ../../../../pkgs/nix-garbage-notification.nix {inherit pkgs;};
  cfg = config.userSettings.nixGarbageNotification;
in {
  options.userSettings.nixGarbageNotification = {
    enable = lib.mkEnableOption "Notification de maintenance du store NixOS";
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.nix-garbage-notification = {
      Unit = {
        Description = "Notification de maintenance du store NixOS";
      };

      Service = {
        Type = "oneshot";
        ExecStart = "${nixGarbageNotification}/bin/nix-garbage-notification";
      };
    };

    systemd.user.timers.nix-garbage-notification = {
      Unit = {
        Description = "Lance la notification de maintenance du store NixOS";
      };

      Timer = {
        OnStartupSec = "5s";
        Persistent = false;
        Unit = "nix-garbage-notification.service";
      };

      Install = {
        WantedBy = ["timers.target"];
      };
    };
  };
}
