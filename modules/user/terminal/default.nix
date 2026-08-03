{
  config,
  lib,
  ...
}: {
  options = {
    userSettings.terminal = lib.mkOption {
      default = "kitty";
      description = "Default terminal";
      type = lib.types.enum ["kitty"];
    };
  };

  config = {
    userSettings.kitty.enable = lib.mkDefault (config.userSettings.terminal == "kitty");
  };
}
