{
  lib,
  buildNimblePackage,
  fetchFromGitHub,
}:
buildNimblePackage rec {
  pname = "nimlangserver";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "v${version}";
    hash = "sha256-mh+p8t8/mbZvgsJ930lXkcBdUjjioZoNyNZzwywAiUI=";
  };

  doCheck = false;

  meta = with lib; {
    description = "Nim language server implementation (based on nimsuggest)";
    homepage = "https://github.com/nim-lang/langserver";
    license = licenses.mit;
    mainProgram = "nimlangserver";
    maintainers = with maintainers; [ daylinmorgan ];
  };
}
