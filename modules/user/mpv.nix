{...}: {
  programs.mpv = {
    enable = true;
    config = {
      profile = "gpu-hq";
      vo = "gpu-next";
      # hwdec = "auto-safe";
      hwdec = "vaapi";

      save-position-on-quit = "yes";
      keep-open = "yes";

      alang = "fr,en";
      slang = "fr,en";

      deband = "yes";
      volume-max = "150";
    };
  };
}
