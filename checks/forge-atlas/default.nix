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
  atlasDepsHash = "sha256-iSQBRxJAH5Z9iN8nR6AsI29AqJAdm+K5gDjdUtP8Q3w=";

  buildInputs = [ openssl ];
  doCheck = false;
}
