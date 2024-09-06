{
  pkgs,
  flake,
  system,
  ...
}:
pkgs.mkShell {
  packages = [
    flake.packages.${system}.formatter
    #perSystem.blueprint.default
    pkgs.formatter
    pkgs.bashInteractive
    pkgs.jq
    pkgs.nix-prefetch-github
    pkgs.nix-prefetch-git
    pkgs.git
  ];
}
