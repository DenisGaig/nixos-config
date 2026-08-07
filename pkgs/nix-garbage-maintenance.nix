{pkgs}:
pkgs.writeShellApplication {
  name = "nix-garbage-maintenance";

  runtimeInputs = with pkgs; [
    jq
    libnotify
    nix
  ];

  text = ''
    human_size() {
    local size=$1

    if (( size > 1024**3 )); then
        echo "$((size / 1024**3)) GiB"
    elif (( size > 1024**2 )); then
        echo "$((size / 1024**2)) MiB"
    elif (( size > 1024 )); then
        echo "$((size / 1024)) KiB"
    else
        echo "$size bytes"
    fi
    }

    size_before=$(nix path-info --json --all | jq 'map(.narSize) | add // 0')

    nix-collect-garbage --delete-older-than 20d

    size_after=$(nix path-info --json --all | jq 'map(.narSize) | add // 0')

    free_size=$((size_before - size_after))

    free_display=$(human_size "$free_size")
    store_display=$(human_size "$store_size")

    generations=$(find /nix/var/nix/profiles -name "system-*-link" | wc -l)

    message="
    ✔  Nettoyage du store terminé

    ✔ $free_display récupérés

    📦 Store : $store_display

    🗑️ Générations conservées : $generations
    "

    if (( free_size > 0 )); then
        notify-send "🧹 Maintenance NixOS" "$message"
    fi
  '';
}
