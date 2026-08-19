{pkgs}:
pkgs.writeShellApplication {
  name = "forgejo-backup-cleanup";

  runtimeInputs = with pkgs; [
    coreutils
    findutils
  ];

  text = ''
    set -euo pipefail

    BACKUP_DIR="/srv/backups/forgejo"
    KEEP=5

    echo "=== Nettoyage des anciennes sauvegardes Forgejo ==="
    echo "Répertoire : $BACKUP_DIR"
    echo "Conservation : $KEEP versions"
    echo

    mapfile -t BACKUPS < <(
      find "$BACKUP_DIR" \
        -maxdepth 1 \
        -type f \
        -name 'forgejo-*.tar.zst' \
        -printf '%T@ %p\n' |
      sort -nr |
      tail -n +"$((KEEP + 1))" |
      cut -d' ' -f2-
    )

    if ((''${#BACKUPS[@]} == 0)); then
      echo "Aucune ancienne sauvegarde à supprimer."
      exit 0
    fi

    for backup in "''${BACKUPS[@]}"; do
      timestamp="''${backup#"$BACKUP_DIR/forgejo-"}"
      timestamp="''${timestamp%.tar.zst}"

      postgres_backup="$BACKUP_DIR/postgres-$timestamp.pgdump"

      echo "Suppression : $(basename "$backup")"

      rm -f -- "$backup"
      rm -f -- "$postgres_backup"
    done

    echo
    echo "=== Nettoyage terminé ==="
  '';
}
