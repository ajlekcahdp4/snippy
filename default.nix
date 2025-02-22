{
  pkgs,
  stdenv,
  lib,
  cmake,
  ninja,
  python3,
  gtest,
  ...
}:
let
  fs = lib.fileset;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "llvm-snippy";
  version = "1.0.0";

  src = fs.toSource {
    root = ./.;
    fileset = fs.unions [
      ./llvm
      ./cmake
      ./libunwind
    ];
  };
  sourceRoot = "${finalAttrs.src.name}/llvm";
  strictDeps = true;
  nativeBuildInputs = [
    cmake
    ninja
    python3
  ];
  buildInputs = [ ];

  patches = [
    ./overlays/snippy-fix-link-order.patch
    ./overlays/snippy-install-target.patch
  ];

  cmakeFlags = [
    (lib.cmakeFeature "LLVM_SNIPPY_VERSION" finalAttrs.version)
    (lib.cmakeBool "LLVM_ENABLE_RTTI" false)
    (lib.cmakeBool "LLVM_BUILD_SNIPPY" true)
    (lib.cmakeBool "LLVM_ENABLE_ASSERTIONS" true)
    (lib.cmakeBool "LLVM_BUILD_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "LLVM_INCLUDE_UTILS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "LLVM_INCLUDE_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "LLVM_INCLUDE_BENCHMARKS" false)
    (lib.cmakeFeature "LLVM_TARGETS_TO_BUILD" "RISCV")
    (lib.cmakeFeature "LLVM_ENABLE_PROJECTS" "lld")
  ];

  installTargets = [ "install-llvm-snippy" ];

  ninjaFlags = [ "llvm-snippy" ];

  doCheck = true;
  nativeCheckInputs = [ ];
  checkInputs = [ gtest ];
  checkTarget = "check-llvm-tools-llvm-snippy";
})
