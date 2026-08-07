{pkgs, ...}: let
  nixGarbage = import ../../../pkgs/nix-garbage-maintenance.nix {inherit pkgs;};
in {
  systemd.services.nix-garbage-maintenance = {
    Unit = {
      Description = "Maintenance automatique du store NixOS";
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${nixGarbage}/bin/nix-garbage-maintenance";
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
