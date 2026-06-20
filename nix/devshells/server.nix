{ pkgs }:
pkgs.mkShell {
  packages = with pkgs; [
    go
    protobuf
    protoc-gen-go
    protoc-gen-go-grpc
    curl
    jq
    gnumake
  ];
}
