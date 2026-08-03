{pkgs, ...}: {
  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  environment.systemPackages = with pkgs; [
    pwvucontrol
  ];
}
