{
  openssl,
  buildAtlasPackage,
  fetchFromGitHub,
}:
buildAtlasPackage rec {
  pname = "forge";
  version = "2025.1010";

  src = fetchFromGitHub {
    owner = "daylinmorgan";
    repo = "forge";
    rev = "v${version}";
    hash = "sha256-yZybHdJrqpJBfLqF85Or+AgToA+vWPxP87bMVFy9olQ=";
  };

  atlasLockFile = ./atlas.lock;
  atlasDepsHash = "sha256-eg9NJa5bESQ6W2Sjbd+KrO6Rx8K2unm9jXYF98Qq19Q=";

  buildInputs = [ openssl ];
  doCheck = false;
}
