{...}: {
  # List services that you want to enable:
  services.syncthing = {
    enable = true;
    user = "denis";
    dataDir = "/home/denis";
    configDir = "/home/denis/.config/syncthing";
  };
}
