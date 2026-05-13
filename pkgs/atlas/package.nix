{
  lib,
  buildNimPackage,
  fetchFromGitHub,
  openssl,
}:

buildNimPackage (
  final: prev: {
    pname = "atlas";
    version = "0.14.5";
    src = fetchFromGitHub {
      owner = "nim-lang";
      repo = "atlas";
      rev = final.version;
      hash = "sha256-VT8hVKWRtWWSigaErdGS20tYdBD3f4WP755OphH9DjA=";
    };
    lockFile = ./lock.json;
    buildInputs = [ openssl ];

    doCheck = false; # tests will clone repos
    meta = final.src.meta // {
      description = "Nim package cloner";
      mainProgram = "atlas";
      license = [ lib.licenses.mit ];
    };
  }
)
