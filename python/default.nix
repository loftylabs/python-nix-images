{
  nix2containerPkgs,
  pkgs,
}: {
  python311-gdal = import ./generic {
    inherit pkgs nix2containerPkgs;
    version = "311";
    versionTag = "3.11-gdal";
  };
  python310-gdal = import ./generic {
    inherit pkgs nix2containerPkgs;
    version = "310";
    versionTag = "3.10-gdal";
  };
}
