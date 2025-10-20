# Nim2nix

## Motivation

Building packages on `nix` can be annoying.
We want it to be as easy as possible for `nim` users and `nixos` users/maintainers.

### Issue

The current implementation in nixpkgs relies on a custom lock file.
But packages are more likely to have an existing `nimble.lock`,
making maintaining or generating a second lock file just for nix somewhat tedious.

There are currently two options for generating this `lock.json`:

1. Using the recommended [nim_lk](https://nixos.org/manual/nixpkgs/stable/#nim-lockfiles) which attempts dependency resolution to generate the lock file
2. [nnl](https://github.com/daylinmorgan/nnl) which performs no dependency resolution and simply converts a `nimble.lock` file (or generates one if necessary) to the equivalent `nim_lk` output

### Solution

`nim2nix` forgoes `buildNimPackage` for two custom builders, empowered by native tooling.

## Usage

nim2nix provides two builders: `buildNimblePackage` and `buildAtlasPackage`:

Both of which work essentially the same by using their associated package manager to download and wire up deps.

### `buildNimblePackage`

NOTE: `nim2nix` uses a patched `nimble` to prevent it from compiling any dependencies

```nix
buildNimblePackage {
  src = fetchFromGitHub {
    ...
  };

  # nimbleLockFile = ./nimble.lock;
  nimbleDepsHash = "<sha256>";
}
```

see [example](./checks/forge-nimble/default.nix);

### `buildAtlasPackage`

```nix
buildAtlasPackage {
  src = fetchFromGitHub {
    ...
  };

  # atlasLockFile = ./atlas.lock;
  atlasDepsHash = "<sha256>";
}
```

see [example](./checks/forge-atlas/default.nix);
