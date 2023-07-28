final: prev: {
  pythonPackagesExtensions =
    prev.pythonPackagesExtensions
    ++ [
      (python-final: python-prev: {
        certifi = python-prev.certifi.overridePythonAttrs (oldAttrs: {
          src = prev.fetchFromGitHub {
            owner = oldAttrs.pname;
            repo = "python-certifi";
            rev = "2023.07.22";
            hash = "sha256-V3bptJDNMGXlCMg6GHj792IrjfsG9+F/UpQKxeM0QOc=";
          };
        });
      })
    ];
}
