{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./modules/fish.nix
    ./modules/fzf.nix
    ./modules/dunst.nix
    ./modules/git.nix
  ];

  home.username = "denis";
  home.homeDirectory = "/home/denis";
  # Ne JAMAIS changer cette valeur après le premier build
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    astro-language-server
    alejandra
    bash-language-server
    black
    calc
    dprint
    eza
    fd
    grimblast
    hyprpaper
    hyprpicker
    imagemagick
    isort
    kitty
    lazygit
    markdown-oxide
    lua-language-server
    prettier
    rofi
    thunar
    stylua
    vscode-langservers-extracted
    wl-clipboard
    yaml-language-server
  ];

  # PROGRAMS

  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.bat.enable = true;
  programs.btop.enable = true;
  programs.ripgrep.enable = true;

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.yazi.enable = true;

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  # MODULES
  gtk = {
    enable = true;
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    iconTheme = {
      name = "Dracula";
      package = pkgs.dracula-icon-theme;
    };
    cursorTheme = {
      name = "Capitaine Cursors";
      package = pkgs.capitaine-cursors;
    };
  };
}
