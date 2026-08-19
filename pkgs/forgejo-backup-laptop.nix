{pkgs}:
pkgs.writeShellApplication {
  name = "forgejo-backup-laptop";

  runtimeInputs = with pkgs; [
    coreutils
    rsync
    openssh
  ];

  text = ''
    set -euo pipefail

    SOURCE="/srv/backups/forgejo/"
    DESTINATION="denis@192.168.1.142:/data/stockage/forgejo/"
    SSH_KEY="/home/forgejo-backup/.ssh/forgejo_laptop_ed25519"

    echo "=== Sauvegarde Forgejo → Laptop ==="
    echo "Source      : $SOURCE"
    echo "Destination : $DESTINATION"
    echo

    rsync -av \
      -e "ssh -i $SSH_KEY" \
      "$SOURCE" \
      "$DESTINATION"

    echo
    echo "=== Transfert vers le laptop terminé ==="
  '';
}
