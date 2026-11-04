{
  config,
  lib,
  ...
}: {
  options.userSettings.terminal = {
    default = lib.mkOption {
      type = lib.types.enum [
        "kitty"
        "foot"
      ];
      default = "kitty";
      description = "Default terminal";
    };
  };

  config = {
    userSettings.kitty.enable =
      lib.mkDefault (config.userSettings.terminal.default == "kitty");
  };
}
