# Installation des paquets perso sur le système pour les services et timers
{pkgs, ...}: let
  flakeReminder = import ../../../pkgs/flake-reminder.nix {inherit pkgs;};
  nixGarbage = import ../../../pkgs/nix-garbage-maintenance.nix {inherit pkgs;};
  nixGarbageNotification = import ../../../pkgs/nix-garbage-notification.nix {inherit pkgs;};
  forgejoBackupCleanup = import ../../../pkgs/forgejo-backup-cleanup.nix {inherit pkgs;};
  forgejoBackupLaptop = import ../../../pkgs/forgejo-backup-laptop.nix {inherit pkgs;};
in {
  environment.systemPackages = [
    flakeReminder
    forgejoBackupCleanup
    forgejoBackupLaptop
    nixGarbage
    nixGarbageNotification
  ];
}
