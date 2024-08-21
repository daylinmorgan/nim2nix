{
  description = "nim2nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      inherit (nixpkgs.lib) genAttrs;
      forAllSystems =
        f:
        genAttrs [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"]
          (system: f nixpkgs.legacyPackages.${system});
    in
    {

      packages = forAllSystems (pkgs: rec {
        buildNimPackage = pkgs.callPackage ./pkgs/build-nim-package.nix {};
        nimlangserver = pkgs.callPackage ./pkgs/nimlangserver/package.nix {inherit buildNimPackage;};
      });

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          buildInputs = with pkgs; [
            zk
            hugo
            nodePackages.pnpm
          ];
        };
      });
    };
}
