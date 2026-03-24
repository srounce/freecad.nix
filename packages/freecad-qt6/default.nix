{ perSystem, ... }:
builtins.warn "FreeCAD has removed Qt5 support, the default freecad.nix attribute now uses Qt6." perSystem.self.freecad

