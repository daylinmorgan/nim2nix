{
  description = "nim2nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { nixpkgs, self, ... }:
    let
      inherit (nixpkgs.lib) genAttrs;
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      forAllSystems =
        fn:
        genAttrs systems (
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
          nimble-no-bins = final.callPackage ./pkgs/nimble/package.nix { };
          nim-atlas = final.callPackage ./pkgs/atlas/package.nix {};
        };
      };

      packages = forAllSystems (pkgs: {
        atlas = pkgs.nim-atlas;
      });

      checks = forAllSystems (pkgs: {
        fugitive = pkgs.callPackage ./pkgs/fugitive/package.nix { };
        nimlangserver = pkgs.callPackage ./pkgs/nimlangserver/package.nix { };
      });

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nim
            nimble
            nim-atlas
          ];
        };
      });
      formatter = forAllSystems (pkgs: pkgs.nixfmt-rfc-style);
    };
}
