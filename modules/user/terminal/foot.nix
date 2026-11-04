{
  config,
  lib,
  ...
}: let
  cfg = config.userSettings.terminal.foot;
in {
  options = {
    userSettings.terminal.foot = {
      enable = lib.mkEnableOption "Enable Foot terminal";
    };
  };

  #options.userSettings.foot.enable =
  #  lib.mkEnableOption "Enable Foot terminal";

  config = lib.mkIf cfg.enable {
    programs.foot = {
      enable = true;

      settings = {
        main = {
          term = "xterm-256color";
          font = "JetBrainsMono Nerd Font:size=11";
          dpi-aware = "yes";
        };

        colors-dark = {
          alpha = 0.95;
          background = "282a36";
          foreground = "f8f8f2";

          regular0 = "21222c";
          regular1 = "ff5555";
          regular2 = "50fa7b";
          regular3 = "f1fa8c";
          regular4 = "bd93f9";
          regular5 = "ff79c6";
          regular6 = "8be9fd";
          regular7 = "f8f8f2";

          bright0 = "6272a4";
          bright1 = "ff6e6e";
          bright2 = "69ff94";
          bright3 = "ffffa5";
          bright4 = "d6acff";
          bright5 = "ff92df";
          bright6 = "a4ffff";
          bright7 = "ffffff";
        };
      };
    };
  };
}
