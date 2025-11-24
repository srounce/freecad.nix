{
  pkgs,
  perSystem,
  ...
}:
pkgs.mkShell {
  packages = [
    perSystem.self.formatter
    pkgs.bashInteractive
    pkgs.jq
    pkgs.nix-prefetch-github
    pkgs.nix-prefetch-git
    pkgs.git
  ];
}

