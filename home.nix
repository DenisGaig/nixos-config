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
    grimblast
    hyprpaper
    hyprpicker
    imagemagick
    isort
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

  # SERVICES
  services.dunst = {
    enable = true;
    settings = {
      global = {
        origin = "top-right";
        offset = "12x12";
        width = 320;
        height = 120;
        font = "HasklugNerdFont 11";
        padding = 14;
        horizontal_padding = 14;
        corner_radius = 8;
        frame_width = 2;
        transparency = 10;
        timeout = 5000;

        # Dracula background + text
        background = "#282a36";
        foreground = "#f8f8f2";
        frame_color = "#6272a4";
      };

      urgency_low = {
        background = "#282a36";
        foreground = "#6272a4";
        frame_color = "#6272a4";
        timeout = 3;
      };

      urgency_normal = {
        background = "#282a36";
        foreground = "#f8f8f2";
        frame_color = "#bd93f9";
        timeout = 5;
      };

      urgency_critical = {
        background = "#ff5555";
        foreground = "#f8f8f2";
        frame_color = "#ff5555";
        timeout = 0;
      };
    };
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
