{ config, pkgs, ... }:

{
  home.username = "denis";
  home.homeDirectory = "/home/denis";
  # Ne JAMAIS changer cette valeur après le premier build
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    astro-language-server
    bash-language-server
    black
    calc
    dprint
    eza
    fd
    isort
    markdown-oxide
    lua-language-server
    prettier
    stylua
    vscode-langservers-extracted
    yaml-language-server

  ];

    programs.atuin.enable = true;
    programs.bat.enable = true;
    programs.btop.enable = true;
    programs.fzf = {
        enable = true;
        #defaultCommand = "fd --type f --hidden --exclude .git";
    };
    programs.git.enable = true;
    programs.ripgrep.enable = true;
    programs.starship.enable = true;
    programs.yazi.enable = true;
    programs.zoxide.enable = true;
}
