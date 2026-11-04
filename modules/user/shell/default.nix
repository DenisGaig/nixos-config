{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.userSettings.shell;
in {
  options = {
    userSettings.shell = {
      enable = lib.mkEnableOption "Enable fish with some necessary CLI utilities";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.fish = {
      enable = true;

      shellAliases = {
        ll = "eza -lha --icons=auto --sort=name --group-directories-first";
        ls = "eza --icons=auto";
        lt = "eza --tree --level=2 --long --icons --git";
        ya = "yazi";
        nv = "nvim";
        mkdir = "mkdir -pv";
        ".." = "cd ..";
        "..." = "cd ../..";
        cp = "cp -iv";
        mv = "mv -iv";
        ln = "ln -iv";
        rm = "rm -I --preserve-root";

        g = "git";
        gl = "git log";
        gs = "git status";
        ga = "git add";
        gc = "git commit -m";
        gpu = "git push";
        gpl = "git pull";
        gd = "git diff";
        gco = "git checkout";
        gb = "git branch";
        gf = "git fetch";
        gm = "git merge";
        gw = "git switch";

        # alias pour le fuzzy finder tv
        tvd = "cd (tv dirs)";
        tvf = "nv (tv files)";
        tvt = "nv (tv text)";
      };

      shellAbbrs = {
        nrs = "sudo nixos-rebuild switch --flake /etc/nixos#denislab";
        nrb = "sudo nixos-rebuild build --flake /etc/nixos#denislab --no-link";
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

        set -gx LIBVIRT_DEFAULT_URI qemu:///system

        set -gx NNN_SEL "$HOME/.config/nnn/.selection"
        set -gx NNN_FCOLORS "D4DEB778E79F9F67D2E5E5D2"
      '';

      functions = {
        fenv = {
          description = "Parcourir les variables d'environnement";
          body = ''
            env | sort | fzf
          '';
        };

        ftext = {
          description = "Recherche de texte en direct (rg + fzf)";
          body = ''
            set -l rg "rg --line-number --no-heading --color=always --smart-case"

            fzf --ansi --disabled --query "$argv" --delimiter : \
              --bind "start:reload:$rg {q} || true" \
              --bind "change:reload:$rg {q} || true" \
              --preview 'bat --color=always --highlight-line {2} {1}' \
              --preview-window 'right:60%:+{2}/2' \
              --bind 'enter:become($EDITOR {1} +{2})'
          '';
        };
      };
    };

    programs.bash = {
      enable = true;
      enableCompletion = true;
      shellAliases = config.programs.fish.shellAliases;
    };

    home.packages = with pkgs; [
      bat
      btop
      eza
      fd
      ripgrep
    ];

    programs.fzf = {
      enable = true;
      enableFishIntegration = true;
      historyWidget.command = "";
      defaultCommand = "fd --type f --hidden --exclude .git";

      defaultOptions = [
        "--layout=reverse"
        "--border"
        "--height=70%"
        "--preview-window=right:50%:wrap"
      ];

      fileWidget = {
        command = "fd --type f --hidden --exclude .git";
        options = [
          "--preview"
          "if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"
        ];
      };

      changeDirWidget = {
        options = [
          "--preview"
          "eza --tree --color=always {} | head -200"
        ];
      };
    };

    programs.atuin = {
      enable = true;
      enableFishIntegration = true;
    };

    programs.starship = {
      enable = true;
      enableFishIntegration = true;
    };

    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

    programs.nnn = {
      enable = true;

      package = pkgs.nnn.override {
        withNerdIcons = true;
      };

      options = {
        e = true; # Ouvrir les fichiers texte avec EDITOR
      };

      enableFishIntegration = true;
      quitcd = true;

      bookmarks = {
        n = "~/storage/notes";
        t = "~/Downloads";
        p = "~/projets";
        c = "~/.config";
      };

      # Les plugins sont définit dans le fichier /home/denis/nixos-config/modules/user/home.nix
      # car ils ne fonctionnait pas bien dans nnn.nvim
    };
  };
}
