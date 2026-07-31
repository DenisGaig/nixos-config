{...}: {
  programs.mise = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      all_compile = false;
    };
  };
}
