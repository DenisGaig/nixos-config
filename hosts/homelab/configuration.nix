{
  pkgs,
  self,
  ...
}: {
  config = {
    systemSettings = {
      hyprland.enable = true;

      neovim.enable = true;

      ssh.enable = true;
      syncthing.enable = true;

      virtualization = {
        virtualMachines.enable = true;
      };
    };

    microvm.vms.ci-microvm = {
      flake = self;
      autostart = true;
    };

    users.users.denis = {
      isNormalUser = true;
      extraGroups = ["wheel"];
      packages = with pkgs; [
        tree
      ];
      shell = pkgs.fish;
    };
  };
}
