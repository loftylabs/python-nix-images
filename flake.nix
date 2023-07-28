{
  inputs.nix2container.url = "github:nlewo/nix2container";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  outputs = {
    self,
    nixpkgs,
    nix2container,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      userOverlays = builtins.readDir ./python/overlays;
      basicPkgsForSystem = system:
        import nixpkgs {
          inherit system;
        };
      pkgsForSystem = system:
        import nixpkgs {
          system = system;
          overlays =
            builtins.attrValues
            (builtins.mapAttrs
              (name: _: import ./python/overlays/${name})
              userOverlays);
        };
      pkgs = pkgsForSystem system;
      simplePkgs = basicPkgsForSystem system;
      nix2containerPkgs = nix2container.packages.${system};
    in {
      packages = import ./python {
        inherit pkgs;
        inherit nix2containerPkgs;
      };
      devShell = simplePkgs.mkShell {
        buildInputs = with pkgs; [
          trivy
          grype
          syft
          dive
        ];
      };
    });
}
