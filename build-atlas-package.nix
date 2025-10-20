{
  stdenv,
  nim,
  nim_builder,

  # nimbledeps dependencies
  git,
  cacert,
  nim-atlas,
}:
{
  nativeBuildInputs ? [ ],
  passthru ? { },
  atlasDepsHash ? "",
  atlasLockFile ? null,
  meta ? { },
  ...
}@args':
let
  args = removeAttrs args' [ "atlasDepsHash" ];
  atlasDeps = stdenv.mkDerivation {
    name = "atlasdeps";
    src = args.src; #// { leaveDotGit = true; };

    buildInputs = [
      git
      cacert
      nim-atlas
    ];

  # # atlas needs to be run in a .git directory
  # git submodule update --init was returning 128?
  preBuild = ''
      export HOME=$TMPDIR
      if ! [ -d .git ]; then
        git init > /dev/null
      fi
    '';

    buildPhase =
      ''
        runHook preBuild
      ''
      + (
        if atlasLockFile != null then
          ''
            cp ${atlasLockFile} atlas.lock
          ''
        else
          ""
      )
      + ''
        atlas install --verbosity:trace
        rm $out/deps/_nimbles $outs/deps/_packages -rf
        find deps -name ".git" -type d -exec rm -rf {} +
      '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/deps
      cp -r deps nim.cfg $out
      runHook postInstall
    '';

    doCheck = false;
    dontPatchShebangs = true;

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = atlasDepsHash;
  };
in

stdenv.mkDerivation (finalAttrs:
  args
  // {
    nativeBuildInputs = [
      nim
      nim-atlas
      nim_builder
    ] ++ nativeBuildInputs;

    configurePhase = ''
      runHook preConfigure
      export NIX_NIM_BUILD_INPUTS=''${pkgsHostTarget[@]} $NIX_NIM_BUILD_INPUTS
      nim_builder --phase:configure

      cp -r ${atlasDeps}/deps deps
      cp -r ${atlasDeps}/nim.cfg nim.cfg

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
      inherit atlasDepsHash;
    };

    meta = {
      platforms = nim.meta.platforms;
    } // meta;
  })
