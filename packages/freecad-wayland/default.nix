{ perSystem, ... }:
perSystem.self.freecad.override {
  withWayland = true;
  withQt6 = true;
}
