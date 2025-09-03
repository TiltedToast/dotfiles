{
  pkgs,
  cudaPkgs,
}:

pkgs.pocl.overrideAttrs (oldAttrs: {
  pname = "pocl-cuda";
  buildInputs = oldAttrs.buildInputs ++ [
    cudaPkgs.cuda_cudart
  ];
  nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [
    cudaPkgs.cuda_nvcc
  ];
  cmakeFlags = oldAttrs.cmakeFlags ++ [
    (pkgs.lib.cmakeBool "ENABLE_CUDA" true)
    (pkgs.lib.cmakeFeature "CUDA_TOOLKIT_ROOT_DIR" "${cudaPkgs.cudatoolkit}")
  ];
  hardeningDisable = oldAttrs.hardeningDisable or [ ] ++ [
    "stackprotector"
    "zerocallusedregs"
  ];
  meta = oldAttrs.meta // {
    description = "POCL with CUDA device backend enabled";
  };
})
