{pkgs, ...}: let
  forgejoBackupCleanup = import ../../../pkgs/forgejo-backup-cleanup.nix {inherit pkgs;};
in {
  systemd.services.forgejo-backup-cleanup = {
    description = "Nettoyage des sauvegardes Forgejo";

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${forgejoBackupCleanup}/bin/forgejo-backup-cleanup";
    };
  };

  systemd.timers.forgejo-backup-cleanup = {
    description = "Nettoyage quotidien des sauvegardes Forgejo";

    wantedBy = ["timers.target"];

    timerConfig = {
      # Après la sauvegarde de la VM → Dell
      OnCalendar = "*-*-* 03:15:00";
      Persistent = true;
    };
  };
}
