{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define the zram Swap (50% for 8G on 16G)
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  # Setup de Neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  # Setup de fish comme shell par defaut sur tout le système
  programs.fish.enable = true;

  # List services that you want to enable:
  services.syncthing = {
    enable = true;
    user = "denis";
    dataDir = "/home/denis";
    configDir = "/home/denis/.config/syncthing";
  };
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?
}
