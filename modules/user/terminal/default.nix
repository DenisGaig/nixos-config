{pkgs, ...}: {
  home.packages = with pkgs; [
    calc
    curl
    curl.dev
    eza
    fd
    kitty
    wl-clipboard
  ];

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
}
