{
  inputs.nix2container.url = "github:nlewo/nix2container";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {
    self,
    nixpkgs,
    nix2container,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      nix2containerPkgs = nix2container.packages.${system};
    in {
      packages = import ./python {
        inherit pkgs;
        inherit nix2containerPkgs;
      };
      devShell = pkgs.mkShell {
      	buildInputs = with pkgs; [trivy grype syft dive];
      };
    });
}
