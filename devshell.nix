{ pkgs, ... }: pkgs.mkShell {
  packages = with pkgs; [
    bashInteractive
    jq
    nix-prefetch-github
    nix-prefetch-git
    git
  ];
}
