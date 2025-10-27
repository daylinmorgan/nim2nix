{
  lib,
  buildNimPackage,
  fetchFromGitHub,
  openssl,
}:

buildNimPackage (
  final: prev: {
    pname = "atlas";
    version = "unstable-2025-10-17";
    src = fetchFromGitHub {
      owner = "nim-lang";
      repo = "atlas";
      rev = "3e33c732546760359b58a81df2269edd1d0c5f4d";
      hash = "sha256-3hv5fEmoPR/Jt/x8Kpv41yVx3zbC0YK62I7a+20HFcM=";
    };
    lockFile = ./lock.json;
    buildInputs = [ openssl ];
    # prePatch = ''
    #   rm config.nims
    #   '';
    postPatch = ''
      substituteInPlace src/atlas.nim \
        --replace-fail 'staticExec("git log -n 1 --format=%H")' '"${final.src.rev}"'
    '';

    doCheck = false; # tests will clone repos
    meta = final.src.meta // {
      description = "Nim package cloner";
      mainProgram = "atlas";
      license = [ lib.licenses.mit ];
    };
  }
)
