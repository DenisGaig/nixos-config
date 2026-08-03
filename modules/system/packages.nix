{pkgs, ...}:
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
  environment.systemPackages = with pkgs;
    [
      clang-tools
      gcc
      lm_sensors
      playerctl
      pwvucontrol
      tree-sitter
      wget
    ]
    ++ [myParsers];

  environment.variables.NVIM_TREESITTER_PARSERS = "${myParsers}";
}
