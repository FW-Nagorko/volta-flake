{
  description = "Nix flake for @monvit/volta";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    blueprint.url = "github:numtide/blueprint";
    blueprint.inputs.nixpkgs.follows = "nixpkgs";

    nix-vite-plus.url = "github:ryoppippi/nix-vite-plus";
    nix-vite-plus.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: inputs.blueprint {
      inherit inputs;
      prefix = "nix/";
      nixpkgs.overlays = [
        inputs.nix-vite-plus.overlays.default
      ];
    };
}
