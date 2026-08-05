{pkgs}:
pkgs.writeShellApplication {
  name = "flake-update-reminder";

  runtimeInputs = with pkgs; [
    jq
    libnotify
  ];

  text = ''
    last_modified=$(jq -r '.nodes.nixpkgs.locked.lastModified' /etc/nixos/flake.lock)
    now=$(date +%s)

    days=$(( (now - last_modified) / 86400 ))
    if (( days == 0 )); then
        msg="Système à jour d'aujourd'hui"
    elif (( days == 1 )); then
        msg="Dernière mise à jour il y a 1 jour"
    else
        msg="Dernière mise à jour il y a $days jours"
    fi

    if (( days >= 14 )); then
        notify-send -u critical "Mise à jour système" "$msg ⚠️ Pense à mettre à jour !"
    else
        notify-send "Mise à jour système" "$msg"
    fi
  '';
}
