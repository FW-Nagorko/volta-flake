{
  pkgs,
}:
pkgs.mkShell {
  packages = [ pkgs.vite-plus ];
  shellHook = ''
    export SSL_CERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
  '';
}
