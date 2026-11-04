{...}: {
  home.username = "denis";
  home.homeDirectory = "/home/denis";
  home.sessionVariables = {
    EDITOR = "nvim";
    NNN_FIFO = "/tmp/nnn.fifo";
    NNN_PLUG = "o:fzopen;c:fzcd;j:autojump;p:preview-tui;i:imgview;n:nuke;y:.cbcp";
  };

  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      "image/*" = "nsxiv.desktop";
    };
  };

  # Ne JAMAIS changer cette valeur après le premier build
  home.stateVersion = "26.05";
}
