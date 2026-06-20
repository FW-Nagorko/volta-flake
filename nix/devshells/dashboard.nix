{
  pkgs,
  perSystem,
}:
let
  vp = perSystem.vp-nix.default;
in
pkgs.mkShell {
  packages = [ vp ];
  shellHook = ''
    export SSL_CERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
  '';
}
