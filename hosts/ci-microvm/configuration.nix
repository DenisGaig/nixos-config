{
  config,
  pkgs,
  ...
}: {
  networking.hostName = "ci-microvm";

  microvm = {
    hypervisor = "cloud-hypervisor";
  };

  environment.systemPackages = with pkgs; [
    btop
  ];
}
