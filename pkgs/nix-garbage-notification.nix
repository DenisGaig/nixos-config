{pkgs}:
pkgs.writeShellApplication {
  name = "nix-garbage-notification";

  runtimeInputs = with pkgs; [
    libnotify
  ];

  text = ''
    shopt -s nullglob

    reports=(/run/nix-gc/*.report)

    (( ''${#reports[@]} == 0 )) && exit 0

    report="''${reports[0]}"

    timestamp=$(basename "$report" .report)

    cachefile="$HOME/.cache/nix-gc.last"

    if [[ -f "$cachefile" ]]; then
        last_seen=$(<"$cachefile")
    else
        last_seen=""
    fi

    if [[ "$timestamp" == "$last_seen" ]]; then
        exit 0
    fi

    msg=$(<"$report")

    [[ -z "$msg" ]] && exit 0
        notify-send "🧹 Maintenance NixOS"  "$msg"

    printf "%s\n" "$timestamp" > "$cachefile"
  '';
}
