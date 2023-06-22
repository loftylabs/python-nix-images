{
  nix2containerPkgs,
  pkgs,
  version,
  versionTag,
}: let
  pythonTag = "python" + version;
  python = pkgs.${pythonTag};
  pythonEnv = python.withPackages (p: [p.gdal]);
in
  nix2containerPkgs.nix2container.buildImage {
    name = "nix-python";
    tag = versionTag;
    copyToRoot = [
      (pkgs.buildEnv {
        name = "root";
        paths = with pkgs; [bashInteractive coreutils pythonEnv];
        pathsToLink = ["/bin" "/lib"];
      })
    ];
    layers = [
      (nix2containerPkgs.nix2container.buildLayer {
        deps = [pythonEnv pkgs.gdal];
      })
    ];
  }
