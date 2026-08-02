{...}: {
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
}
