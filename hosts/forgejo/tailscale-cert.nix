{pkgs, ...}: let
  hostname = "forgejo.tail3e17a7.ts.net";

  certDir = "/etc/tailscale-certs";
  certFile = "${certDir}/${hostname}.crt";
  keyFile = "${certDir}/${hostname}.key";

  renewForgejoCert = pkgs.writeShellApplication {
    name = "renew-forgejo-tls";

    runtimeInputs = with pkgs; [
      tailscale
      coreutils
      systemd
    ];

    text = ''
      set -euo pipefail

      echo "Checking Tailscale certificate for ${hostname}..."

      # Hashes before renewal
      old_cert=""
      old_key=""

      if [[ -f "${certFile}" ]]; then
        old_cert=$(sha256sum "${certFile}")
      fi

      if [[ -f "${keyFile}" ]]; then
        old_key=$(sha256sum "${keyFile}")
      fi

      # Ask Tailscale for a certificate with at least
      # 30 days of remaining validity.
      tailscale cert \
        --min-validity=720h \
        --cert-file="${certFile}" \
        --key-file="${keyFile}" \
        "${hostname}"

      # Nginx needs to be able to read the certificate and key.
      chown nginx:nginx "${certFile}" "${keyFile}"
      chmod 640 "${certFile}"
      chmod 600 "${keyFile}"

      # Hashes after renewal
      new_cert=$(sha256sum "${certFile}")
      new_key=$(sha256sum "${keyFile}")

      if [[ "$old_cert" != "$new_cert" || "$old_key" != "$new_key" ]]; then
        echo "Certificate changed, reloading nginx..."
        systemctl reload nginx
      else
        echo "Certificate is still valid, no nginx reload needed."
      fi
    '';
  };
in {
  systemd.services.tailscale-cert-renew = {
    description = "Renew Forgejo Tailscale TLS certificate";

    after = [
      "tailscaled.service"
      "nginx.service"
      "network-online.target"
    ];

    wants = [
      "network-online.target"
    ];

    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };

    script = "${renewForgejoCert}/bin/renew-forgejo-tls";
  };

  systemd.timers.tailscale-cert-renew = {
    description = "Daily check of Forgejo Tailscale TLS certificate";

    wantedBy = ["timers.target"];

    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };
}
