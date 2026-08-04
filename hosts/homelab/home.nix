{...}: {
  userSettings = {
    desktop = {
      enable = true;
      dunst.enable = true;
    };

    shell = {
      enable = true;
      apps.enable = true;
    };

    web = {
      enable = true;
      browser = "brave";
    };

    development = {
      enable = true;
    };

    # Déjà true avec development mais plus explicite
    git.enable = true;
    lsp.enable = true;
    formatters.enable = true;
    mise.enable = true;

    media = {
      enable = true;
    };

    documents = {
      enable = true;
    };
  };
}
