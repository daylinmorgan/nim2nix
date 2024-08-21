# Nim2nix


## Goal

```nix
buildNimPackage {
  pname = "langserver";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "v${version}";
    hash = "sha256-mh+p8t8/mbZvgsJ930lXkcBdUjjioZoNyNZzwywAiUI=";
  };

  nimbleHash = "<sha256>";
  # check for nimble.lock in src when nimbleHash provided
  # nimbleLock = ./nimble.lock;
}
```
## Motivation

Building packages on `nix` can be annoying.
We want it to be as easy as possible for `nim` users and `nixos` users/maintainers.

## Issue

Current implementation relies on a custom lock file.
Packages are more likely to have an existing `nimble.lock` making maintaining or generating a second lock file just for nix tedious.

There are currently two options for generating this `lock.json`:

1. Using the recommended [nim_lk](https://nixos.org/manual/nixpkgs/stable/#nim-lockfiles) which attempt dependency resolution to generate the lock file
2. [nnl](https://github.com/daylinmorgan/nnl) which performs no dependency resolution and simply converts a `nimble.lock` file to the equivalent `nim_lk` output




