{
  openssl,
  buildNimblePackage,
  fetchFromGitHub,
}:
buildNimblePackage rec {
  pname = "forge";
  version = "2025.1010";

  src = fetchFromGitHub {
    owner = "daylinmorgan";
    repo = "forge";
    rev = "v${version}";
    hash = "sha256-yZybHdJrqpJBfLqF85Or+AgToA+vWPxP87bMVFy9olQ=";
  };

  #nimbleLockFile = ./nimble.lock;
  nimbleDepsHash = "sha256-05poP0fWaZVkcpAj8H+7cq99MoxFNKeVl8Dk1bAfMEU=";

  buildInputs = [ openssl ];
  doCheck = false;
}
