{
  description = "Personal Volta dev shells (agent + server + dashboard)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    vp-nix.url = "github:naitokosuke/vp-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      vp-nix,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        vp = vp-nix.packages.${system}.default;
        cppLibs = with pkgs; [
          grpc
          protobuf
          fmt
          tomlplusplus
        ];
        cmakeLibs =
          with pkgs;
          cppLibs
          ++ [
            openssl
            zlib
            c-ares
            re2
            abseil-cpp
          ];
        wslHook = ''
          if [ -d /usr/lib/wsl/lib ]; then
            export LD_LIBRARY_PATH="/usr/lib/wsl/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
          fi
        '';
        vpHook = ''
          export SSL_CERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
        '';
      in
      {
        devShells = {
          agent = pkgs.mkShell {
            name = "volta-agent";
            packages =
              with pkgs;
              [
                gcc
                cmake
                gnumake
                pkg-config
                git
                clang-tools
                cppcheck
              ]
              ++ cmakeLibs;
            CMAKE_PREFIX_PATH = pkgs.lib.makeSearchPath "lib/cmake" cmakeLibs;
            shellHook = wslHook;
          };

          server = pkgs.mkShell {
            name = "volta-server";
            packages = with pkgs; [
              go
              protobuf
              protoc-gen-go
              protoc-gen-go-grpc
              curl
              jq
              gnumake
            ];
            shellHook = wslHook;
          };

          dashboard = pkgs.mkShell {
            name = "volta-dashboard";
            packages = with pkgs; [
              vp
            ];
            shellHook = wslHook + vpHook;
          };

          default = self.devShells.${system}.agent;
        };
      }
    );
}
