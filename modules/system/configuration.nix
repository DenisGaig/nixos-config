{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
# Mise en place des grammaires pour treesitter dans neovim
let
  myParsers = pkgs.symlinkJoin {
    name = "nvim-treesitter-parsers";
    paths = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      astro
      bash
      c
      css
      fish
      gitcommit
      html
      javascript
      json
      json5
      lua
      markdown
      markdown_inline
      nix
      python
      query
      rasi
      regex
      scss
      toml
      tsx
      typescript
      vim
      vimdoc
      yaml
    ];
  };
in {
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Hyrpland settings
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Enable flakes
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    download-buffer-size = 268435456;
    trusted-users = ["root" "denis"];
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
    extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
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
  environment.systemPackages = with pkgs;
    [
      clang-tools
      gcc
      lm_sensors
      neovim
      playerctl
      pwvucontrol
      syncthing
      tree-sitter
      wget
    ]
    ++ [myParsers];

  # inputs.hyprpaper.packages.${pkgs.system}.hyprpaper
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

  # Permet l'exécution de binaires ELF génériques (non compilés pour NixOS)
  # ex: binaires téléchargés par neovim (LSP, windsurf/neocodeium...)
  # sans cela, ces binaires échouent car /lib/ld-linux-x86-64.so.2 est absent
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib # libstdc++ librairie C++ standard
      zlib # libz — compression, utilisée partout
    ];
  };

  # Setup de fish comme shell par defaut sur tout le système
  programs.fish.enable = true;
  users.users.denis.shell = pkgs.fish;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

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
