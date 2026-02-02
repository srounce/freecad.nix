{
  pkgs,
  withQt6 ? false,
  withWayland ? false,
  python ? pkgs.python311,
  ...
}:
let
  inherit (pkgs)
    fetchFromGitHub
    lib
    gmsh
    ;

  versionInfo = builtins.fromJSON (builtins.readFile ./version.json);

  src = fetchFromGitHub {
    owner = "FreeCAD";
    repo = "FreeCAD";
    rev = versionInfo.rev;
    hash = versionInfo.hash;
    fetchSubmodules = true;
  };
in
pkgs.freecad.overrideAttrs {
  inherit src;

  version = "1.1.0-rc2";

  patches = [
    ./patches/0001-NIXOS-don-t-ignore-PYTHONPATH.patch
  ];

  postPatch = ''
    substituteInPlace src/Mod/Fem/femmesh/gmshtools.py \
      --replace-fail 'self.gmsh_bin = ""' 'self.gmsh_bin = "${lib.getExe gmsh}"'
  '';
}
