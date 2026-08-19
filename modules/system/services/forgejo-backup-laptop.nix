{pkgs, ...}: let
  forgejoBackupLaptop = import ../../../pkgs/forgejo-backup-laptop.nix {inherit pkgs;};
in {
  systemd.services.forgejo-backup-laptop = {
    description = "Copie des sauvegardes Forgejo vers le laptop";

    serviceConfig = {
      Type = "oneshot";
      User = "forgejo-backup";

      ExecStart = "${forgejoBackupLaptop}/bin/forgejo-backup-laptop";
    };
  };

  systemd.timers.forgejo-backup-laptop = {
    description = "Copie quotidienne des sauvegardes Forgejo vers le laptop";

    wantedBy = ["timers.target"];

    timerConfig = {
      OnCalendar = "*-*-* 03:30:00";
      Persistent = true;
    };
  };
}
