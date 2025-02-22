{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };
  outputs =
    { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      perSystem =
        { pkgs, ... }:
        rec {
          packages = rec {
            llvm-snippy = pkgs.callPackage ./. { stdenv = pkgs.llvmPackages.stdenv; };
            default = llvm-snippy;
          };
          devShells.default = (pkgs.mkShell.override {stdenv = pkgs.llvmPackages.stdenv;}) {
            nativeBuildInputs =
              packages.llvm-snippy.nativeBuildInputs
              ++ (with pkgs; [
                valgrind
              ]);
            buildInputs = packages.llvm-snippy.buildInputs;
          };
        };
    };
}
