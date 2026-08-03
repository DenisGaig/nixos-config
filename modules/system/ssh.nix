{
  lib,
  config,
  ...
}: let
  cfg = config.systemSettings.ssh;
in {
  options.systemSettings.ssh = {
    enable = lib.mkEnableOption "OpenSSH";
  };

  config = lib.mkIf cfg.enable {
    services.openssh.enable = true;
    services.openssh.settings.PasswordAuthentication = true;
  };
}
