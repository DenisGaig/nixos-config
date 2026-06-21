{
  description = "Configuration NixOS de denis - Optiplex 7050";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland/v0.55.0";
    hyprpaper.url = "github:hyprwm/hyprpaper";
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    hyprland,
    ...
  }: {
    nixosConfigurations.denislab = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
	    ./hardware-configuration.nix
      ];
    };
  };
}
