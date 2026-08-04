{pkgs, ...}: {
  config = {
    systemSettings = {
      hyprland.enable = true;

      neovim.enable = true;

      ssh.enable = true;
      syncthing.enable = true;
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
