{
  pkgs,
  withQt6 ? false,
  withWayland ? false,
  ...
}:
let
  inherit (pkgs)
    lib
    stdenv
    fetchFromGitHub
    cmake
    pkg-config
    wrapGAppsHook

    python3
    fmt
    yaml-cpp
    xercesc
    opencascade-occt
    libGLU
    vtk
    medfile
    hdf5
    eigen
    coin3d
    mpi
    libspnav
    libredwg
    swig
    doxygen
    ;

  versionInfo = builtins.fromJSON (builtins.readFile ./version.json);

  src = fetchFromGitHub {
    owner = "FreeCAD";
    repo = "FreeCAD";
    rev = versionInfo.rev;
    hash = versionInfo.hash;
    fetchSubmodules = true;
  };

  qtVersion = if withQt6 then pkgs.qt6Packages else pkgs.qt5;

  inherit (qtVersion) wrapQtAppsHook;

  qtPackages =
    (with qtVersion; [
      qtbase
      qtsvg
      qttools
      qtwayland
    ])
    ++ lib.optionals withQt6 [ qtVersion.qt5compat ];

  pythonPackages = with python3.pkgs; [
    boost
    shiboken2
    #shiboken6
    pyside2
    pyside2-tools
    #pyside6
    pybind11
    pivy
    matplotlib
  ];
in
stdenv.mkDerivation {
  pname = "freecad";
  version = builtins.substring 0 8 versionInfo.rev;

  inherit src;

  patches = [
    ./patches/0001-NIXOS-don-t-ignore-PYTHONPATH.patch
    ./patches/0002-FreeCad-OndselSolver-pkgconfig.patch
  ];

  # echo $PYTHONPATH | sed 's/:/\n/g'
  # exit 1
  preConfigure = ''
    qtWrapperArgs+=(--prefix PYTHONPATH : "$PYTHONPATH")
  '';

  qtWrapperArgs = [
    "--set COIN_GL_NO_CURRENT_CONTEXT_CHECK 1"
    "--prefix PATH : ${libredwg}/bin"
  ] ++ (lib.optional (!withWayland) "--set QT_QPA_PLATFORM xcb");

  postFixup = ''
    mv $out/share/doc $out
    ln -s $out/bin/FreeCAD $out/bin/freecad
    ln -s $out/bin/FreeCADCmd $out/bin/freecadcmd
  '';

  cmakeFlags = [
    "-Wno-dev" # turns off warnings which otherwise makes it hard to see what is going on
    "-DBUILD_DRAWING=ON"
    "-DINSTALL_TO_SITEPACKAGES=OFF"
    "-DFREECAD_USE_PYBIND11=ON"
    "-DBUILD_FLAT_MESH:BOOL=ON"
    "-DBUILD_FLAT_MESH:BOOL=ON"
  ] ++ (lib.optionals (!withQt6) [ "-DBUILD_QT5=ON" ]);

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook
    wrapQtAppsHook
  ];

  buildInputs = [
    fmt
    yaml-cpp
    xercesc
    opencascade-occt
    libGLU
    vtk
    medfile
    hdf5
    eigen
    coin3d
    mpi
    libspnav
    swig
    doxygen

    python3
  ] ++ qtPackages ++ pythonPackages;

  propagatedBuildInputs = pythonPackages;
}
