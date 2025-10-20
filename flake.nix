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
          buildAtlasPackage = final.callPackage ./build-atlas-package.nix {};
          nimble-no-bins = final.callPackage ./pkgs/nimble/package.nix { };
          nim-atlas = final.callPackage ./pkgs/atlas/package.nix {};
        };
      };

      packages = forAllSystems (pkgs: {
        atlas = pkgs.nim-atlas;
        nimble = pkgs.nimble-no-bins;
      });

      checks = forAllSystems (pkgs: {
        nimlangserver-nimble = pkgs.callPackage ./checks/nimlangserver-nimble { };
        # TODO:
        # nimlangserver-atlas = pkgs.callPackage ./checks/nimlangserver-atlas { };
        forge-atlas = pkgs.callPackage ./checks/forge-atlas {};
        forge-nimble = pkgs.callPackage ./checks/forge-nimble {};
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
