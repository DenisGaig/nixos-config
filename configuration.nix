
{ config, lib, pkgs, inputs, ... }:

  # Mise en place des grammaires pour treesitter dans neovim
let
  myParsers = pkgs.symlinkJoin {
    name = "nvim-treesitter-parsers";
    paths = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
     astro bash c css fish gitcommit html javascript json json5
     lua markdown markdown_inline python query rasi regex
     scss toml tsx typescript vim vimdoc yaml
    ];
 };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "denislab"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus32";
    keyMap = "fr-latin9";
  };
  # Present avant dans console
  # useXkbConfig = true; # use xkb.options in tty.

  # Hyrpland settings
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };

  # Enable flakes
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    download-buffer-size = 268435456;
    trusted-users = ["root" "denis"];
    extra-substituters = ["https://hyprland.cachix.org"];
    extra-trusted-public-keys = ["hyprland.cacix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  # Lancement auto de Hyprland au démarrage avec TUIgreet
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd ${config.programs.hyprland.package}/bin/start-hyprland";
	user = "greeter";
      };
    };
  };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;




  # Configure keymap in X11
  services.xserver.xkb.layout = "fr";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.denis = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  # Define the zram Swap (50% for 8G on 16G)
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  # programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    astro-language-server
    atuin
    bash-language-server
    bat
    black
    brave
    btop
    calc
    capitaine-cursors
    clang-tools
    dprint
    eza
    fzf
    git
    gcc
    isort
    kitty
    lm_sensors
    markdown-oxide
    neovim
    lua-language-server
    playerctl
    pwvucontrol
    prettier
    ripgrep
    rofi
    starship
    stylua
    thunar
    tree-sitter
    vscode-langservers-extracted
    waybar
    wget
    wlogout
    wlsunset
    yaml-language-server
    yazi
    zoxide
    inputs.hyprpaper.packages.${pkgs.system}.hyprpaper
  ] ++ [ myParsers ];

  environment.variables.NVIM_TREESITTER_PARSERS = "${myParsers}";

  # Installation des fonts
  fonts.packages = with pkgs; [
    nerd-fonts.hasklug
    victor-mono
  ];

  # Setup de Neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  # Setup de fish comme shell par defaut sur tout le système
  programs.fish = {
    enable = true;
    shellAbbrs = { nrs = "sudo nixos-rebuild switch --flake /etc/nixos#denislab"; };
  };
  users.users.denis.shell = pkgs.fish;


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}
