{ ... }:

{
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;

    defaultCommand = "fd --type f --hidden --exclude .git";

    defaultOptions = [
      "--preview-window=right:50%:wrap"
    ];
  };
}
