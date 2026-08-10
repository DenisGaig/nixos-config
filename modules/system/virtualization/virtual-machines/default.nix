# Module qui fourni à son hôte une infrastructure de virtualisation utilisable
# par ses utilisateurs normaux
{
  lib,
  config,
  ...
}: let
  cfg = config.systemSettings.virtualization.virtualMachines;

  # Liste des utilisateurs normaux dans la config (utilisation de isNormalUser = true)
  normalUsers = lib.attrNames (lib.filterAttrs (_: u: u.isNormalUser) config.users.users);
in {
  options.systemSettings.virtualization.virtualMachines = {
    enable = lib.mkEnableOption "Installation des outils de gestion de VMs";
  };

  config = lib.mkIf cfg.enable {
    programs.virt-manager.enable = true;

    virtualisation.libvirtd = {
      enable = true;
      qemu.runAsRoot = false;
    };

    # Concaténation dans extraGroups de tous les groupes des utilisateurs normaux
    users.users = lib.genAttrs normalUsers (_: {
      extraGroups = ["libvirtd"];
    });
  };
}
