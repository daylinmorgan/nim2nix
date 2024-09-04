{
  openssl,
  buildNimblePackage,
  fetchFromGitHub,
}:
buildNimblePackage rec {
  pname = "fugitive";
  version = "0.11.4";

  src = fetchFromGitHub {
    owner = "haltcase";
    repo = "fugitive";
    rev = "v${version}";
    hash = "sha256-W06L/DNEpDmO69s318rPlElKD9vDXnx9O5ZFOEa3kyU=";
  };
  
  nimbleLockFile = ./nimble.lock;
  nimbleDepsHash = "sha256-opj+KSd5REsTN2sSckPuuK+wN3c028Kja9UujbrWHwY=";

  buildInputs = [ openssl ];
  doCheck = false;
}
