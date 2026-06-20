{ pkgs, perSystem }:
let
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
in
pkgs.mkShell {
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
  shellHook = ''
    if [ -d /usr/lib/wsl/lib ]; then
      export LD_LIBRARY_PATH="/usr/lib/wsl/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
    fi
  '';
}
