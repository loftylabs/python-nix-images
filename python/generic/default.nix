{
  nix2containerPkgs,
  pkgs,
  version,
  versionTag,
  add_gdal ? true,
}: let
  pythonTag = "python" + version;
  python = pkgs.${pythonTag};
  pythonBasePackages =
    if add_gdal
    then (p: [p.gdal])
    else (p: []);
  pythonEnv = python.withPackages pythonBasePackages;
in
  nix2containerPkgs.nix2container.buildImage {
    name = "nix-python";
    tag = versionTag;
    copyToRoot = with pkgs;
    with pkgs.dockerTools; [
      (buildEnv {
        name = "root";
        paths = with pkgs; [bashInteractive coreutils pythonEnv poetry postgresql];
        pathsToLink = ["/bin" "/lib"];
      })
      fakeNss
      caCertificates
      usrBinEnv
      busybox
    ];
    layers = [
      (nix2containerPkgs.nix2container.buildLayer {
        deps =
          [pythonEnv]
          ++ (
            if add_gdal
            then [pkgs.gdal]
            else []
          );
      })
    ];
  }
