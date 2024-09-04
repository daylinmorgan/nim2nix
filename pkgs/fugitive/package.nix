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
  nimbleDepsHash = "sha256-D5jyZ6Ja4N9XcJFfu3nifRSAAjQBfv/TFuMforAbY5A=";

  buildInputs = [ openssl ];
  doCheck = false;
}
