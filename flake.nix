{
  description = "my flake";

  # Add all your dependencies here
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    blueprint = {
      url = "github:numtide/blueprint";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-github-actions = {
      url = "github:nix-community/nix-github-actions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-substituters = [ "https://freecad-nix.cachix.org" ];
    extra-trusted-public-keys = [
      "freecad-nix.cachix.org-1:4udrBfknw1PmAxiLtiyiij7in4jlU//l64G7zaAYYYE="
    ];
  };

  # Keep the magic invocations to minimum.
  outputs =
    inputs@{
      self,
      nix-github-actions,
      nixpkgs,
      ...
    }:
    let
      supportedSystems = [ "x86_64-linux" ];
    in
    (
      inputs.blueprint { inherit inputs; }
      // {
        githubActions = nix-github-actions.lib.mkGithubMatrix {
          checks = nixpkgs.lib.getAttrs supportedSystems self.packages;
        };
      }
    );
}
