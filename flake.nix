{
  description = "nim2nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { nixpkgs, self, ... }:
    let
      inherit (nixpkgs.lib) genAttrs;
      forAllSystems =
        fn:
        genAttrs
          [
            "x86_64-linux"
            "x86_64-darwin"
            "aarch64-linux"
            "aarch64-darwin"
          ]
          (
            system:
            fn (
              import nixpkgs {
                inherit system;
                overlays = [ self.overlays.default ];
              }
            )
          );
    in
    {
      overlays = {
        default = final: _prev: {
          buildNimblePackage = final.callPackage ./build-nimble-package.nix { };
        };
      };
      packages = forAllSystems (pkgs: rec {
        # buildNimblePackage = pkgs.callPackage ./pkgs/build-nimble-package.nix {};
        # simple package to test functionality
        fugitive = pkgs.callPackage ./pkgs/fugitive/package.nix { };
        default = fugitive;

        # failing because of the compiler
        nimlangserver = pkgs.callPackage ./pkgs/nimlangserver/package.nix { };
      });

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nim
            nimble
          ];
        };
      });
      formatter = forAllSystems (pkgs: pkgs.nixfmt-rfc-style);
    };
}
