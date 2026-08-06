{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.userSettings.lsp;
in {
  options.userSettings.lsp = {
    enable = lib.mkEnableOption "Install lsp packages";
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      astro-language-server
      bash-language-server
      lua-language-server
      markdown-oxide
      nixd
      vscode-langservers-extracted
      yaml-language-server
    ];
  };
}
