{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.userSettings.kitty;
in {
  options.userSettings.kitty = {
    enable = lib.mkEnableOption "Enable Kitty terminal";
  };

  config = lib.mkIf cfg.enable {
    programs.kitty = {
      enable = true;

      settings = {
        term = "xterm-kitty";

        confirm_os_window_close = 0;
        window_padding_width = "0 4 4 4";

        allow_remote_control = "yes";
        listen_on = "unix:/tmp/kitty-{kitty_pid}";

        editor = "kitty";

        tab_bar_min_tabs = 1;
        tab_bar_align = "left";
        tab_bar_edge = "top";
        tab_bar_style = "powerline";
        tab_powerline_style = "round";
        tab_bar_margin_height = "0.0 2.0";

        font_family = "Hasklug Nerd Font";
        italic_font = "Victor Mono Italic";
        font_size = 12;

        background_opacity = "0.95";

        hide_window_decorations = "titlebar_only";

        enabled_layouts = "tall:bias=50;full_size=1;mirrored=false";

        cursor_trail = 3;
        cursor_trail_decay = "0.1 0.4";

        url_color = "#8be9fd";

        active_tab_foreground = "#282a36";
        active_tab_background = "#ff79c6";
        inactive_tab_foreground = "#f8f8f2";
        inactive_tab_background = "#6272a4";
        tab_bar_background = "#1e1e2f";

        wayland_titlebar_color = "system";
      };

      keybindings = {
        # Sessions
        "ctrl+a>d" = "goto_session ~/.config/kitty/sessions/dotfiles.kitty-session";
        "ctrl+a>x" = "goto_session ~/.config/kitty/sessions/nixosconfig.kitty-session";
        "ctrl+a>c" = "goto_session ~/.config/kitty/sessions/c.kitty-session";
        "ctrl+a>n" = "goto_session ~/.config/kitty/sessions/notes.kitty-session";
        "ctrl+a>l" = "goto_session ~/.config/kitty/sessions/cours.kitty-session";

        # Général
        "ctrl+equal" = "change_font_size all +2.0";
        "ctrl+minus" = "change_font_size all -2.0";

        "ctrl+c" = "copy_or_interrupt";
        "ctrl+alt+c" = "copy_to_clipboard";
        "ctrl+shift+v" = "paste_from_clipboard";
        "ctrl+v" = "paste_from_clipboard";

        "ctrl+enter" = "launch --cwd=current";

        "ctrl+right" = "next_window";
        "ctrl+left" = "previous_window";

        "ctrl+e" = "kitten choose-files .";
      };

      extraConfig = ''
        # Sessions
        map ctrl+a>s launch --type=overlay bash -c "~/.config/kitty/scripts/ks.sh"

        # Tabs
        tab_title_template "{tab.active_wd.rsplit('/', 1)[-1]}"
        tab_bar_filter session:~ or session:^$

        # Scrollback
        map ctrl+shift+h show_scrollback
        scrollback_pager nvim -u NONE -R -M -c 'lua require("denis.kitty_scrollback")(INPUT_LINE_NUMBER, CURSOR_LINE, CURSOR_COLUMN)' -

        # Theme
        include theme.conf
      '';
    };
  };
}
