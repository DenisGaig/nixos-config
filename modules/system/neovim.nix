{
  pkgs,
  lib,
  config,
  ...
}: let
  # Mise en place des grammaires pour treesitter dans neovim
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
  cfg = config.systemSettings.neovim;
in {
  options.systemSettings.neovim = {
    enable = lib.mkEnableOption "Install neovim";
  };

  config = lib.mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };

    environment.systemPackages = [
      myParsers
      pkgs.tree-sitter
    ];

    environment.variables.NVIM_TREESITTER_PARSERS = "${myParsers}";
  };
}
