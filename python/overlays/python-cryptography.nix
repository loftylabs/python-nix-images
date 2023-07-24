final: prev: {
  pythonPackagesExtensions =
    prev.pythonPackagesExtensions
    ++ [
      (python-final: python-prev: {
        service-identity = python-prev.service-identity.overridePythonAttrs (oldAttrs: {
            doCheck = false;
            });
        pyopenssl = python-prev.pyopenssl.overridePythonAttrs (oldAttrs: {
          postPatch = ''
            substituteInPlace setup.py --replace "<41" ""
          '';
        });
        cryptography = python-prev.cryptography.overridePythonAttrs (oldAttrs: rec {
          version = "41.0.2";
          doCheck = false;
          src = prev.fetchPypi {
            inherit version;
            inherit (oldAttrs) pname;
            hash = "sha256-fSML+FYWTeFk7LYVzMFMf8beaQbd1bSR86+Q01FMklw=";
          };
          cargoDeps = prev.rustPlatform.fetchCargoTarball rec {
            inherit (oldAttrs) cargoRoot pname;
            inherit src;
            sourceRoot = "${pname}-${version}/${cargoRoot}";
            name = "${pname}-${version}";
            hash = "sha256-hkuoICa/suMXlr4u95JbMlFzi27lJqJRmWnX3nZfzKU=";
          };
        });
      })
    ];
}
