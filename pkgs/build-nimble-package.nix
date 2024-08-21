{
  stdenv,
  git,
  cacert,

  nim,
  nim_builder,
  nimble,
}:
{
  name ? "${args'.pname}-${args'.version}",
  nativeBuildInputs ? [ ],
  passthru ? { },
  nimbleDepsHash ? "",
  nimbleLockFile ? null,
  meta ? { },
  ...
}@args':
let
  args = removeAttrs args' [ "nimbleDepsHash" ];
  nimbleDeps = stdenv.mkDerivation {
    name = "${name}-nimbledeps";
    inherit (args) src;

    buildInputs = [
      nimble
      git
      cacert
    ];

    buildPhase =
      ''
        runHook preBuild
      ''
      + (
        if nimbleLockFile != null then
          ''
            cp ${nimbleLockFile} nimble.lock
          ''
        else
          ""
      )
      + ''
        nimble install -l --depsOnly --debug --passNim:"--nimcache:$TMPDIR"
        nimble setup -l

        # TODO: get nimble to stop building things...
        for f in nimbledeps/bin/*; do
          rm nimbledeps/bin/"$(readlink "$f")"
        done

        runHook postBuild
      '';

    installPhase = ''
      runHook preBuild
      mkdir -p $out
      cp -r nimbledeps $out/nimbledeps
      cp nimble.paths $out/nimble.paths
      runHook postBuild
    '';

    # dontFixup = true;
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    # outputHash = "sha256-xqEGilIo4J/WbwEFn1ZvirN5AvdZP7HjoOAXYf6k16s=";
    outputHash = nimbleDepsHash;
  };
in

stdenv.mkDerivation (
  args
  // {
    nativeBuildInputs = [
      nim
      nimble
      nim_builder
    ] ++ nativeBuildInputs;
    configurePhase = ''
      runHook preConfigure
      export NIX_NIM_BUILD_INPUTS=''${pkgsHostTarget[@]} $NIX_NIM_BUILD_INPUTS
      nim_builder --phase:configure

      cp -r ${nimbleDeps}/nimbledeps nimbledeps
      echo "--noNimblePath" >> nim.cfg
      for dir in nimbledeps/pkgs2/*-*; do
        echo "--path:\"$(pwd)/$dir\"" >> nim.cfg
      done
      runHook postConfigure
    '';

    buildPhase =
      args.buildPhase or ''
        runHook preBuild
        nim_builder --phase:build
        runHook postBuild
      '';

    checkPhase =
      args.checkPhase or ''
        runHook preCheck
        nim_builder --phase:check
        runHook postCheck
      '';

    installPhase =
      args.installPhase or ''
        runHook preInstall
        nim_builder --phase:install
        runHook postInstall
      '';

    passthru = passthru // {
      inherit nimbleDepsHash;
    };

    meta = {
      platforms = nim.meta.platforms;
    } // meta;
  }
)
