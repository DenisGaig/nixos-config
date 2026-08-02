{...}: {
  # Configuration du réseau

  networking.hostName = "denislab"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Enable Tailscale
  services.tailscale.enable = true;

  # Firewall
  networking.firewall.trustedInterfaces = ["tailscale0"];
  # Optionnel mais recommandé si tu veux SSH via Tailscale identity plus tard :
  networking.firewall.checkReversePath = "loose";
}
