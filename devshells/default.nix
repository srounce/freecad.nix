{
  pkgs,
  perSystem,
  ...
}:
pkgs.mkShell {
  packages = [
    perSystem.self.formatter
  ];
}
