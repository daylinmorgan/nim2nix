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
  atlasDepsHash = "sha256-cYxK/Q06KYKOYUILtlk4Vw6aUONRdSdwgHgQSg2zdvs=";

  buildInputs = [ openssl ];
  doCheck = false;
}
