{pkgs, ...}: {
  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "ter-124b";
    keyMap = "fr-latin9";

    packages = with pkgs; [
      terminus_font
    ];
  };
  # Present avant dans console
  # useXkbConfig = true; # use xkb.options in tty.
}
