{pkgs}:
pkgs.writeShellApplication {
  name = "auto-garbage-nixos";

  runtimeInputs = with pkgs; [
    jq
    libnotify
  ];

  text = ''
    size_before=$(nix path-info --json --all | jq 'map(.narSize) | add // 0')

    nix-collect-garbage --delete-older-than 20d

    size_after=$(nix path-info --json --all | jq 'map(.narSize) | add // 0')

    free_size=$((size_before - size_after))

    if (( free_size > 1024**3 )); then
        display_size=$((free_size / 1024**3))
        msg="$display_size GiB"
    elif (( free_size > 1024**2 )); then
        display_size=$((free_size / 1024**2))
        msg="$display_size MiB"
    elif (( free_size > 1024 )); then
        display_size=$((free_size / 1024))
        msg="$display_size kiB"
    else
        msg="$free_size bytes"
    fi

    if (( free_size > 0 )); then
        notify-send "Nettoyage du store terminé" "$msg libérés"
    fi
  '';
}
