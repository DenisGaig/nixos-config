{
  config,
  pkgs,
  ...
}: {
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
    isort
    markdown-oxide
    lua-language-server
    prettier
    rofi
    thunar
    stylua
    vscode-langservers-extracted
    yaml-language-server
  ];

  programs.fish = {
    enable = true;

    shellAliases = {
      ll = "eza -lha --icons=auto --sort=name --group-directories-first";
      ls = "eza --icons=auto";
      ya = "yazi";
      nv = "nvim";

      g = "git";
      gl = "git log";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gpu = "git push";
      gpl = "git pull";
      gd = "git diff";
      gco = "git checkout";
      gb = "git branch";
      gf = "git fetch";
      gm = "git merge";
    };

    shellAbbrs = {
      nrs = "sudo nixos-rebuild switch --flake /etc/nixos#denislab";
    };

    interactiveShellInit = ''
          set -U fish_greeting

          fish_config theme choose "Dracula Official"

          set -gx PNPM_HOME "$HOME/.local/share/pnpm"

          if not string match -q -- $PNPM_HOME $PATH
            set -gx PATH "$PNPM_HOME" $PATH
          end

          fish_add_path "$HOME/.npm-global/bin"

          set show_file_or_dir_preview \
        "if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

      set -gx FZF_CTRL_T_OPTS \
        "--preview 'bash -c \"$show_file_or_dir_preview\"'"

      set -gx FZF_ALT_C_OPTS \
        "--preview 'eza --tree --color=always {} | head -200'"
    '';
  };

  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.bat.enable = true;

  programs.btop.enable = true;

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;

    defaultCommand = "fd --type f --hidden --exclude .git";

    defaultOptions = [
      "--preview-window=right:50%:wrap"
    ];
  };

  programs.git.enable = true;

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
