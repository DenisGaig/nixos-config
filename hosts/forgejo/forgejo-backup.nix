{
  pkgs,
  lib,
  config,
  ...
}: let
  forgejo = lib.getExe config.services.forgejo.package;

  forgejo-backup = pkgs.writeShellApplication {
    name = "forgejo-backup";

    runtimeInputs = with pkgs; [
      coreutils
      gnutar
      openssh
      postgresql
      rsync
      sudo
      util-linux
      zstd
    ];

    text = ''
      set -euo pipefail

      BACKUP_DIR="/var/lib/forgejo/backups"
      FORGEJO_BIN="${forgejo}"
      FORGEJO_CONFIG="/var/lib/forgejo/custom/conf/app.ini"

      TIMESTAMP="$(date '+%Y-%m-%d_%H-%M-%S')"

      FORGEJO_BACKUP="$BACKUP_DIR/forgejo-$TIMESTAMP.tar.zst"
      POSTGRES_BACKUP="$BACKUP_DIR/postgres-$TIMESTAMP.pgdump"

      if [[ "$EUID" -ne 0 ]]; then
        echo "ERREUR : forgejo-backup doit être exécuté avec sudo."
        exit 1
      fi

      mkdir -p "$BACKUP_DIR"
      sudo chown forgejo:forgejo /var/lib/forgejo/backups
      sudo chmod 700 /var/lib/forgejo/backups

      echo "=== Sauvegarde Forgejo ==="
      echo "Date : $(date)"
      echo

      # Toujours redémarrer Forgejo à la sortie du script,
      # même si une commande échoue.
      cleanup() {
          echo
          echo "=== Redémarrage de Forgejo ==="

          if systemctl start forgejo.service; then
              echo "Forgejo redémarré avec succès."
          else
              echo "ERREUR CRITIQUE : impossible de redémarrer Forgejo !"
              systemctl status forgejo.service --no-pager || true
          fi
      }

      trap cleanup EXIT

      echo "=== Arrêt de Forgejo ==="
      systemctl stop forgejo.service

      echo
      echo "=== Vérification de l'arrêt ==="
      if systemctl is-active --quiet forgejo.service; then
          echo "ERREUR : Forgejo est toujours actif."
          exit 1
      fi

      echo
      echo "=== Dump complet Forgejo ==="

      sudo -u forgejo "$FORGEJO_BIN" dump \
          --config "$FORGEJO_CONFIG" \
          --database postgres \
          --type tar.zst \
          --file "$FORGEJO_BACKUP"

      chmod 600 "$FORGEJO_BACKUP"

      echo
      echo "=== Dump PostgreSQL ==="

      POSTGRES_TMP="/tmp/postgres-$TIMESTAMP.pgdump"

      sudo -u postgres -- pg_dump \
        --format=custom \
        --dbname=forgejo \
        --file="$POSTGRES_TMP"

      mv "$POSTGRES_TMP" "$POSTGRES_BACKUP"

      chown forgejo:forgejo "$POSTGRES_BACKUP"
      chmod 600 "$POSTGRES_BACKUP"

      echo
      echo "=== Vérification PostgreSQL ==="

      sudo -u forgejo -- pg_restore \
        --list "$POSTGRES_BACKUP" > /dev/null

      echo "Archive PostgreSQL valide."

      echo
      echo "=== Sauvegardes terminées ==="

      ls -lh \
          "$FORGEJO_BACKUP" \
          "$POSTGRES_BACKUP"

      echo
      echo "=== Vérification archive Forgejo ==="

      zstd -t "$FORGEJO_BACKUP"

      echo
      echo "=== Toutes les vérifications sont terminées ==="

      echo
      echo "=== Nettoyage des anciennes sauvegardes ==="

      KEEP=5

      find "$BACKUP_DIR" \
        -maxdepth 1 \
        -type f \
        -name 'forgejo-*.tar.zst' \
        -printf '%T@ %p\n' |
      sort -nr |
      tail -n +"$((KEEP + 1))" |
      cut -d' ' -f2- |
      while IFS= read -r backup; do
        timestamp="''${backup#"$BACKUP_DIR/forgejo-"}"
        timestamp="''${timestamp%.tar.zst}"

        postgres_backup="$BACKUP_DIR/postgres-$timestamp.pgdump"

        echo "Suppression : $(basename "$backup")"

        rm -f -- "$backup"
        rm -f -- "$postgres_backup"
      done

      echo
      echo "=== Sauvegarde sur le Dell ==="

      sudo rsync -av \
        -e "ssh -i /home/denis/.ssh/forgejo_backup_ed25519" \
        /var/lib/forgejo/backups/ \
        forgejo-backup@192.168.1.120:/srv/backups/forgejo/

      echo
      echo "=== Sauvegarde sur le Dell terminée ==="

    '';
  };
in {
  environment.systemPackages = [
    forgejo-backup
  ];

  systemd.services.forgejo-backup = {
    description = "Sauvegarde Forgejo";

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${forgejo-backup}/bin/forgejo-backup";
    };
  };

  systemd.timers.forgejo-backup = {
    description = "Sauvegarde quotidienne de Forgejo";

    wantedBy = ["timers.target"];

    timerConfig = {
      OnCalendar = "03:00";
      RandomizedDelaySec = "10m";
      Persistent = true;
    };
  };
}
