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
        # brain = "ssh toshiba -t 'cd ~/brain && nvim'";
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
  };
}
