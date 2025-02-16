{ pkgs, stdenv, lib, ... }:
stdenv.mkDerivation {
  pname = "llvm-snippy";
  version = "1.0.0";
  srcs = lib.cleanSource ./.;
  sourceRoot = "source/llvm";
  nativeBuildInputs = with pkgs; [
    cmake
    ninja
    python3
  ];
  buildInputs = with pkgs; [ ];

  cmakeFlags = [
    "-DLLVM_ENABLE_RTTI=OFF"
    "-DLLVM_BUILD_SNIPPY=ON"
    "-DLLVM_TARGETS_TO_BUILD=RISCV"
    "-DLLVM_ENABLE_PROJECTS=lld"
    "-DLLVM_INCLUDE_UTILS=FALSE"
    "-DLLVM_INCLUDE_TESTS=FALSE"
    "-DLLVM_INCLUDE_BENCHMARKS=FALSE"
  ];
  ninjaFlags = [
    "llvm-snippy"
  ];
}
