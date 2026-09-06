{...}: {
  # Configuration du réseau
  networking = {
    hostName = "denislab";

    networkmanager.enable = true;

    useDHCP = false;

    bridges.br0.interfaces = ["enp0s31f6"];

    interfaces.br0 = {
      useDHCP = true;

      # MAC fixée sur bridge pour que le noyau linux ne le recalcule plus automatiquement
      # lors de l'ajout ou le retrait de port comme micro-vm
      macAddress = "50:9a:4c:19:8d:5e";
    };

    # Firewall
    firewall.trustedInterfaces = ["tailscale0"];
    # Optionnel mais recommandé si tu veux SSH via Tailscale identity plus tard :
    firewall.checkReversePath = "loose";

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };

  # Enable Tailscale
  services.tailscale.enable = true;
}
