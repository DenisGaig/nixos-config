{...}: {
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    historyWidget.command = "";
    defaultCommand = "fd --type f --hidden --exclude .git";

    defaultOptions = [
      "--preview-window=right:50%:wrap"
    ];
  };
}
