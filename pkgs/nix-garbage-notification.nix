{pkgs}:
pkgs.writeShellApplication {
  name = "nix-garbage-notification";

  runtimeInputs = with pkgs; [
    libnotify
  ];

  text = ''
    filename="/run/nix-gc/report"

    if [ ! -f "$filename" ]; then
        exit 0
    fi

    msg=$(<"$filename")
    rm "$filename"

    [[ -z "$msg" ]] && exit 0
        notify-send "🧹 Maintenance NixOS"  "$msg"
  '';
}
