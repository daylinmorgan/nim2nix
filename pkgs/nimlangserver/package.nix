{
  lib,
  buildNimblePackage,
  fetchFromGitHub,
}:
buildNimblePackage rec {
  pname = "nimlangserver";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "v${version}";
    hash = "sha256-j5YnTGPtt0WhRvNfpgO9tjAqZJA5Kt1FE1Mjqn0/DNY=";
  };

  doCheck = false;
  nimbleDepsHash = "sha256-U2AP4Thtiiem0nDfmwBTc0THshiG4y4A0xdfqjMbtrU=";
  meta = with lib; {
    description = "Nim language server implementation (based on nimsuggest)";
    homepage = "https://github.com/nim-lang/langserver";
    license = licenses.mit;
    mainProgram = "nimlangserver";
    maintainers = with maintainers; [ daylinmorgan ];
  };
}
