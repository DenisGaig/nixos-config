{pkgs, ...}: let
  nixGarbageMaintenance = import ../../../pkgs/nix-garbage-maintenance.nix {inherit pkgs;};
in {
  systemd.services.nix-garbage-maintenance = {
    description = "Maintenance automatique du store NixOS";

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${nixGarbageMaintenance}/bin/nix-garbage-maintenance";
    };
  };

  systemd.timers.nix-garbage-maintenance = {
    description = "Timer maintenance automatique du store NixOS";

    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
      RandomizedDelaySec = "30min";
    };

    wantedBy = [
      "timers.target"
    ];
  };
}
