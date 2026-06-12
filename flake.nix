{
  description = "Personal Volta dev shells (agent + server)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        cppLibs = [
          pkgs.grpc
          pkgs.protobuf
          pkgs.fmt
          pkgs.tomlplusplus
        ];
        cmakeLibs = cppLibs ++ [
          pkgs.openssl
          pkgs.zlib
          pkgs.c-ares
          pkgs.re2
          pkgs.abseil-cpp
        ];
        wslHook = ''
          if [ -d /usr/lib/wsl/lib ]; then
            export LD_LIBRARY_PATH="/usr/lib/wsl/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
          fi
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

          default = self.devShells.${system}.agent;

        };
      }
    );
}
