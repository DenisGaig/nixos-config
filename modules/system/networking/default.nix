{...}: {
  # Configuration du réseau
  networking = {
    hostName = "denislab";

    networkmanager.enable = true;

    useDHCP = false;

    bridges.br0.interfaces = ["enp0s31f6"];

    interfaces.br0.useDHCP = true;
  };

  # Enable Tailscale
  services.tailscale.enable = true;

  # Firewall
  networking.firewall.trustedInterfaces = ["tailscale0"];
  # Optionnel mais recommandé si tu veux SSH via Tailscale identity plus tard :
  networking.firewall.checkReversePath = "loose";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
}
