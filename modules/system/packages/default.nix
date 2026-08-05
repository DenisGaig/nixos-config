{pkgs, ...}: let
  flakeReminder = import ../../../pkgs/flake-reminder.nix {inherit pkgs;};
  autoGarbage = import ../../../pkgs/auto-garbage.nix {inherit pkgs;};
in {
  environment.systemPackages = [
    autoGarbage
    flakeReminder
  ];
}
