{ pkgs, ... }:
let
  versionInfo = builtins.fromJSON (builtins.readFile ./version.json);

  src = pkgs.fetchFromGitHub {
    owner = "FreeCAD";
    repo = "FreeCAD";
    rev = versionInfo.rev;
    hash = versionInfo.hash;
    fetchSubmodules = true;
  };
in
pkgs.freecad.overrideAttrs (final: prev: {
  version = builtins.substring 0 8 versionInfo.rev;

  inherit src;

  patches = [
    ./patches/FreeCad-OndselSolver-pkgconfig.patch
  ];

  cmakeFlags = prev.cmakeFlags ++ [
    "-DINSTALL_TO_SITEPACKAGES=OFF"
  ];

  nativeBuildInputs = prev.nativeBuildInputs ++ (with pkgs; [
    yaml-cpp
  ]);
})
