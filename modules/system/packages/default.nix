{pkgs, ...}: let
  flakeReminder = import ../../../pkgs/flake-reminder.nix {inherit pkgs;};
in {
  environment.systemPackages = [
    flakeReminder
  ];
}
