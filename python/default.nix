{
  nix2containerPkgs,
  pkgs,
}: {
  python311-gdal = import ./generic {
    inherit pkgs nix2containerPkgs;
    version = "311";
    versionTag = "3.11-gdal";
    add_gdal = true;
  };
  python310-gdal = import ./generic {
    inherit pkgs nix2containerPkgs;
    version = "310";
    versionTag = "3.10-gdal";
    add_gdal = true;
  };
  python310 = import ./generic {
    inherit pkgs nix2containerPkgs;
    version = "310";
    versionTag = "3.10";
    add_gdal = false;
  };
  python311 = import ./generic {
    inherit pkgs nix2containerPkgs;
    version = "311";
    versionTag = "3.11";
    add_gdal = false;
  };
}
