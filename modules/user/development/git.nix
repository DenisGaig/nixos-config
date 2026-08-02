{...}: {
  programs.git = {
    enable = true;
    signing = {
      key = "~/.ssh/id_ed25519.pub";
      format = "ssh";
      signByDefault = true;
    };
    settings = {
      user = {
        name = "Denis";
        email = "denis_gaignard@yahoo.fr";
      };
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
    };
  };
  services.ssh-agent.enable = true;
}
