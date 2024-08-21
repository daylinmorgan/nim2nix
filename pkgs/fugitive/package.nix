{
  openssl,
  buildNimblePackage,
  fetchFromGitHub,
}:
buildNimblePackage rec {
  pname = "fugitive";
  version = "0.11.4";

  nimbleLockFile = ./nimble.lock;
  nimbleDepsHash = "sha256-mc7Cap4BUcwhFRNmHWKd1RybPzfPHzBvVaYzb+4iF8Q=";

  src = fetchFromGitHub {
    owner = "haltcase";
    repo = "fugitive";
    rev = "v${version}";
    hash = "sha256-W06L/DNEpDmO69s318rPlElKD9vDXnx9O5ZFOEa3kyU=";
  };

  buildInputs = [ openssl ];
  doCheck = false;
}
